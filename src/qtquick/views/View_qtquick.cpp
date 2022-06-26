/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "View_qtquick.h"
#include "private/Utils_p.h"
#include "private/View_p.h"
#include "ViewWrapper_qtquick.h"
#include "private/multisplitter/Item_p.h"
#include "kddockwidgets/Window_qtquick.h"

#include <qpa/qplatformwindow.h>
#include <QGuiApplication>
#include <QFile>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Views;

namespace KDDockWidgets::Views {

/**
 * @brief Event filter which redirects mouse events from one QObject to another.
 * Needed for QtQuick to redirect the events from MouseArea to our KDDW classes which derive from Draggable.
 * For QtWidgets it's not needed, as the Draggables are QWidgets themselves.
 */
class MouseEventRedirector : public QObject
{
    Q_OBJECT
public:
    explicit MouseEventRedirector(QObject *eventSource, QObject *eventTarget)
        : QObject(eventTarget)
        , m_eventSource(eventSource)
        , m_eventTarget(eventTarget)
    {
        eventSource->installEventFilter(this);

        // Each source can only have one MouseEventRedirector
        auto oldRedirector = s_mouseEventRedirectors.take(eventSource);
        if (oldRedirector) {
            eventSource->removeEventFilter(oldRedirector);
            oldRedirector->deleteLater();
        }

        s_mouseEventRedirectors.insert(eventSource, this);
    }

    static MouseEventRedirector *redirectorForSource(QObject *eventSource)
    {
        return s_mouseEventRedirectors.value(eventSource);
    }

    ~MouseEventRedirector() override;

    bool eventFilter(QObject *source, QEvent *ev) override
    {
        QMouseEvent *me = mouseEvent(ev);
        if (!me)
            return false;

        // MouseArea.enable is different from Item.enabled. The former still lets the events
        // go through event loops. So query MouseArea.enable here and bail out if false.
        const QVariant v = source->property("enabled");
        if (v.isValid() && !v.toBool())
            return false;

        // Finally send the event
        m_eventTarget->setProperty("cursorPosition", m_eventSource->property("cursorPosition"));
        qGuiApp->sendEvent(m_eventTarget, me);
        m_eventTarget->setProperty("cursorPosition", CursorPosition_Undefined);

        return false;
    }

    QObject *const m_eventSource;
    QObject *const m_eventTarget;
    static QHash<QObject *, MouseEventRedirector *> s_mouseEventRedirectors;
};

QHash<QObject *, MouseEventRedirector *> MouseEventRedirector::s_mouseEventRedirectors = {};

MouseEventRedirector::~MouseEventRedirector()
{
    s_mouseEventRedirectors.remove(m_eventSource);
}

}

static bool flagsAreTopLevelFlags(Qt::WindowFlags flags)
{
    return flags & (Qt::Window | Qt::Tool);
}

static QQuickItem *actualParentItem(QQuickItem *candidateParentItem, Qt::WindowFlags flags)
{
    // When we have a top-level, such as FloatingWindow, we only want to set QObject parentship
    // and not parentItem.
    return flagsAreTopLevelFlags(flags) ? nullptr
                                        : candidateParentItem;
}

View_qtquick::View_qtquick(KDDockWidgets::Controller *controller, Type type,
                           QQuickItem *parent,
                           Qt::WindowFlags flags)
    : QQuickItem(actualParentItem(parent, flags))
    , View(controller, type, this)
    , m_windowFlags(flags)
{
    if (parent && flagsAreTopLevelFlags(flags)) {
        // See comment in actualParentItem(). We set only the QObject parent. Mimics QWidget behaviour
        QObject::setParent(parent);
    }

    connect(this, &QQuickItem::widthChanged, this, [this] {
        if (!aboutToBeDestroyed()) { // If Window is being destroyed we don't bother
            onResize(View::size());
            updateGeometry();
        }
    });

    connect(this, &QQuickItem::heightChanged, this, [this] {
        if (!aboutToBeDestroyed()) { // If Window is being destroyed we don't bother
            onResize(View::size());
            updateGeometry();
        }
    });

    qGuiApp->installEventFilter(this);
    setSize(800, 800);
}

void View_qtquick::setGeometry(QRect rect)
{
    setSize(rect.width(), rect.height());
    View::move(rect.topLeft());
}

QQuickItem *View_qtquick::createItem(QQmlEngine *engine, const QString &filename)
{
    QQmlComponent component(engine, filename);
    QObject *obj = component.create();
    if (!obj) {
        qWarning() << Q_FUNC_INFO << component.errorString();
        return nullptr;
    }

    return qobject_cast<QQuickItem *>(obj);
}

void View_qtquick::redirectMouseEvents(QObject *source)
{
    if (auto existingRedirector = MouseEventRedirector::redirectorForSource(source)) {
        if (existingRedirector->m_eventTarget == this) {
            // Nothing to do. The specified event source is already redirecting to this instance
            return;
        }
    }

    new MouseEventRedirector(source, this);
}

void View_qtquick::itemChange(QQuickItem::ItemChange change, const QQuickItem::ItemChangeData &data)
{
    QQuickItem::itemChange(change, data);

    // Emulate the QWidget behaviour as QQuickItem doesn't receive some QEvents.
    switch (change) {
    case QQuickItem::ItemParentHasChanged: {
        QEvent ev(QEvent::ParentChange);
        qGuiApp->sendEvent(this, &ev); // Not calling event() directly, otherwise it would skip event filters
        Q_EMIT parentChanged(this);
        break;
    }
    case QQuickItem::ItemVisibleHasChanged: {
        if (m_inSetParent) {
            // Setting parent to nullptr will emit visible true in QtQuick
            // which we don't want, as we're going to hide it (as we do with QtWidgets)
            break;
        }

        QEvent ev(isVisible() ? QEvent::Show : QEvent::Hide);
        event(&ev);
        break;
    }
    default:
        break;
    }
}

void View_qtquick::updateNormalGeometry()
{
    QWindow *window = QQuickItem::window();
    if (!window) {
        return;
    }

    QRect normalGeometry;
    if (const QPlatformWindow *pw = window->handle()) {
        normalGeometry = pw->normalGeometry();
    }

    if (!normalGeometry.isValid() && isNormalWindowState(WindowState(window->windowState()))) {
        normalGeometry = window->geometry();
    }

    if (normalGeometry.isValid()) {
        setNormalGeometry(normalGeometry);
    }
}

void View_qtquick::move(int x, int y)
{
    if (isRootView()) {
        if (QWindow *w = QQuickItem::window()) {
            w->setPosition(x, y);
            return;
        }
    }

    QQuickItem::setX(x);
    QQuickItem::setY(y);
    setAttribute(Qt::WA_Moved);
}

bool View_qtquick::event(QEvent *ev)
{
    if (ev->type() == QEvent::Close)
        View::d->closeRequested.emit(static_cast<QCloseEvent *>(ev));

    return QQuickItem::event(ev);
}

bool View_qtquick::eventFilter(QObject *watched, QEvent *ev)
{
    if (qobject_cast<QWindow *>(watched)) {
        if (m_mouseTrackingEnabled) {
            switch (ev->type()) {
            case QEvent::MouseMove:
            case QEvent::MouseButtonPress:
            case QEvent::MouseButtonRelease:
                ev->ignore();
                qGuiApp->sendEvent(this, ev);
                // qDebug() << "Mouse event" << ev;
                if (ev->isAccepted())
                    return true;
                break;
            default:
                break;
            }
        }

        if (ev->type() == QEvent::Resize || ev->type() == QEvent::Move) {
            updateNormalGeometry();
        } else if (ev->type() == QEvent::WindowStateChange) {
            onWindowStateChangeEvent(static_cast<QWindowStateChangeEvent *>(ev));
        }
    }

    return QQuickItem::eventFilter(watched, ev);
}

bool View_qtquick::close(QQuickItem *item)
{
    if (auto viewqtquick = qobject_cast<View_qtquick *>(item)) {
        QCloseEvent ev;
        viewqtquick->View::d->closeRequested.emit(&ev);

        if (ev.isAccepted()) {
            viewqtquick->setVisible(false);
            return true;
        }
    }

    return false;
}

bool View_qtquick::close()
{
    return close(this);
}

void View_qtquick::QQUICKITEMgeometryChanged(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    // Send a few events manually, since QQuickItem doesn't do it for us.
    QQuickItem::QQUICKITEMgeometryChanged(newGeometry, oldGeometry);

    // Not calling event() directly, otherwise it would skip event filters

    if (newGeometry.size() != oldGeometry.size()) {
        QEvent ev(QEvent::Resize);
        qGuiApp->sendEvent(this, &ev);
    }

    if (newGeometry.topLeft() != oldGeometry.topLeft()) {
        QEvent ev(QEvent::Move);
        qGuiApp->sendEvent(this, &ev);
    }

    Q_EMIT itemGeometryChanged();
}

bool View_qtquick::isVisible() const
{
    if (QWindow *w = QQuickItem::window()) {
        if (!w->isVisible())
            return false;
    }

    return QQuickItem::isVisible();
}

void View_qtquick::setVisible(bool is)
{
    if (isRootView()) {
        if (QWindow *w = QQuickItem::window()) {
            if (is && !w->isVisible()) {
                w->show();
            } else if (!is && w->isVisible()) {
                w->hide();
            }
        }
    }

    QQuickItem::setVisible(is);
}

void View_qtquick::setSize(int w, int h)
{
    // TODOm3: Test that setting a size less than min doesn't set it
    const auto newSize = QSize(w, h).expandedTo(minSize());

    if (isRootView()) {
        if (QWindow *window = QQuickItem::window()) {

            if (window->size() != newSize) {
                QRect windowGeo = window->geometry();
                windowGeo.setSize(newSize);
                window->setGeometry(windowGeo);
            }
        }
    }

    QQuickItem::setSize(QSizeF(w, h));
}

std::shared_ptr<View> View_qtquick::rootView() const
{
    if (Window::Ptr window = View_qtquick::window())
        return window->rootView();

    auto thisNonConst = const_cast<View_qtquick *>(this);
    return thisNonConst->asWrapper();
}

void View_qtquick::makeItemFillParent(QQuickItem *item)
{
    if (!item) {
        qWarning() << Q_FUNC_INFO << "Invalid item";
        return;
    }

    QQuickItem *parentItem = item->parentItem();
    if (!parentItem) {
        qWarning() << Q_FUNC_INFO << "Invalid parentItem for" << item;
        return;
    }

    QObject *anchors = item->property("anchors").value<QObject *>();
    if (!anchors) {
        qWarning() << Q_FUNC_INFO << "Invalid anchors for" << item;
        return;
    }

    anchors->setProperty("fill", QVariant::fromValue(parentItem));
}

void View_qtquick::setAttribute(Qt::WidgetAttribute attr, bool enable)
{
    if (enable)
        m_widgetAttributes |= attr;
    else
        m_widgetAttributes &= ~attr;
}

bool View_qtquick::testAttribute(Qt::WidgetAttribute attr) const
{
    return m_widgetAttributes & attr;
}

void View_qtquick::setFlag(Qt::WindowType f, bool on)
{
    if (on) {
        m_windowFlags |= f;
    } else {
        m_windowFlags &= ~f;
    }
}

Qt::WindowFlags View_qtquick::flags() const
{
    return m_windowFlags;
}

void View_qtquick::free_impl()
{
    // QObject::deleteLater();
    delete this;
}

QSize View_qtquick::sizeHint() const
{
    return m_sizeHint;
}

QSize View_qtquick::minSize() const
{
    const QSize min = property("kddockwidgets_min_size").toSize();
    return min.expandedTo(Layouting::Item::hardcodedMinimumSize);
}

QSize View_qtquick::maxSizeHint() const
{
    const QSize max = property("kddockwidgets_max_size").toSize();
    return max.isEmpty() ? Layouting::Item::hardcodedMaximumSize
                         : max.boundedTo(Layouting::Item::hardcodedMaximumSize);
}

QSize View_qtquick::maximumSize() const
{
    return maxSizeHint();
}

QRect View_qtquick::geometry() const
{
    if (isRootView()) {
        if (QWindow *w = QQuickItem::window()) {
            return w->geometry();
        }
    }

    return QRect(QPointF(QQuickItem::x(), QQuickItem::y()).toPoint(), QQuickItem::size().toSize());
}

QRect View_qtquick::normalGeometry() const
{
    return m_normalGeometry;
}

void View_qtquick::setNormalGeometry(QRect geo)
{
    m_normalGeometry = geo;
}

void View_qtquick::setMaximumSize(QSize sz)
{
    if (maximumSize() != sz) {
        setProperty("kddockwidgets_max_size", sz);
        updateGeometry();
        View::d->layoutInvalidated.emit();
    }
}

void View_qtquick::setWidth(int w)
{
    QQuickItem::setWidth(w);
}

void View_qtquick::setHeight(int h)
{
    QQuickItem::setHeight(h);
}

void View_qtquick::setFixedWidth(int w)
{
    setWidth(w);
}

void View_qtquick::setFixedHeight(int h)
{
    setHeight(h);
}

void View_qtquick::show()
{
    setVisible(true);
}

void View_qtquick::hide()
{
    setVisible(false);
}

void View_qtquick::updateGeometry()
{
    Q_EMIT geometryUpdated();
}

void View_qtquick::update()
{
    // Nothing to do for QtQuick
}

void View_qtquick::setParent(QQuickItem *parentItem)
{
    {
        QScopedValueRollback<bool> guard(m_inSetParent, true);
        QQuickItem::setParent(parentItem);
        QQuickItem::setParentItem(parentItem);
    }

    // Mimic QWidget::setParent(), hide widget when setting parent
    // Only of no parent item though, as that causes binding loops. Since it's benign we won't bother
    // making it strictly like qtwidgets.
    if (!parentItem && !m_inDtor)
        setVisible(false);
}

void View_qtquick::setParent(View *parent)
{
    setParent(Views::asQQuickItem(parent));
}

void View_qtquick::raiseAndActivate()
{
    if (QWindow *w = QQuickItem::window()) {
        w->raise();
        w->requestActivate();
    }
}

void View_qtquick::activateWindow()
{
    if (QWindow *w = QQuickItem::window())
        w->requestActivate();
}

void View_qtquick::raise()
{
    if (isRootView()) {
        if (QWindow *w = QQuickItem::window())
            w->raise();
    } else if (auto p = QQuickItem::parentItem()) {
        // It's not a top-level, so just increase its Z-order
        const auto siblings = p->childItems();
        QQuickItem *last = siblings.last();
        if (last != this)
            stackAfter(last);
    }
}

QVariant View_qtquick::property(const char *name) const
{
    return QObject::property(name);
}

/*static*/ bool View_qtquick::isRootView(const QQuickItem *item)
{
    QQuickItem *parent = item->parentItem();
    if (!parent)
        return true;

    if (auto *w = qobject_cast<QQuickWindow *>(item->window())) {
        if (parent == w->contentItem() || item == w->contentItem())
            return true;
        if (auto *qv = qobject_cast<QQuickView *>(item->window())) {
            if (parent == qv->rootObject() || item == qv->rootObject())
                return true;
        }
    }

    return false;
}

bool View_qtquick::isRootView() const
{
    return View_qtquick::isRootView(this);
}

QQuickView *View_qtquick::quickView() const
{
    return qobject_cast<QQuickView *>(QQuickItem::window());
}

QPoint View_qtquick::mapToGlobal(QPoint localPt) const
{
    return QQuickItem::mapToGlobal(localPt).toPoint();
}

QPoint View_qtquick::mapFromGlobal(QPoint globalPt) const
{
    return QQuickItem::mapFromGlobal(globalPt).toPoint();
}

QPoint View_qtquick::mapTo(View *parent, QPoint pos) const
{
    if (!parent)
        return {};

    auto parentItem = asQQuickItem(parent);
    return parentItem->mapFromGlobal(QQuickItem::mapToGlobal(pos)).toPoint();
}

void View_qtquick::setWindowOpacity(double v)
{
    if (QWindow *w = QQuickItem::window())
        w->setOpacity(v);
}

void View_qtquick::setSizePolicy(SizePolicy h, SizePolicy v)
{
    m_horizontalSizePolicy = h;
    m_verticalSizePolicy = v;
}

SizePolicy View_qtquick::verticalSizePolicy() const
{
    return m_verticalSizePolicy;
}

SizePolicy View_qtquick::horizontalSizePolicy() const
{
    return m_horizontalSizePolicy;
}

void View_qtquick::setWindowTitle(const QString &title)
{
    if (QWindow *w = QQuickItem::window())
        w->setTitle(title);
}

void View_qtquick::setWindowIcon(const QIcon &icon)
{
    if (QWindow *w = QQuickItem::window())
        w->setIcon(icon);
}

bool View_qtquick::isActiveWindow() const
{
    if (QWindow *w = QQuickItem::window())
        return w->isActive();

    return false;
}


void View_qtquick::showNormal()
{
    if (QWindow *w = QQuickItem::window())
        w->showNormal();
}

void View_qtquick::showMinimized()
{
    if (QWindow *w = QQuickItem::window())
        w->showMinimized();
}

void View_qtquick::showMaximized()
{
    if (QWindow *w = QQuickItem::window())
        w->showMaximized();
}

bool View_qtquick::isMinimized() const
{
    if (QWindow *w = QQuickItem::window())
        return w->windowStates() & Qt::WindowMinimized;

    return false;
}

bool View_qtquick::isMaximized() const
{
    if (QWindow *w = QQuickItem::window())
        return w->windowStates() & Qt::WindowMaximized;

    return false;
}

std::shared_ptr<Window> View_qtquick::window() const
{
    if (QWindow *w = QQuickItem::window()) {
        auto windowqtquick = new Window_qtquick(w);
        return std::shared_ptr<Window>(windowqtquick);
    }

    return {};
}

std::shared_ptr<View> View_qtquick::childViewAt(QPoint p) const
{
    auto child = QQuickItem::childAt(p.x(), p.y());
    return child ? asQQuickWrapper(child) : nullptr;
}

/*static*/
std::shared_ptr<View> View_qtquick::parentViewFor(const QQuickItem *item)
{
    auto p = item->parentItem();
    if (QQuickWindow *window = item->window()) {
        if (p == window->contentItem()) {
            // For our purposes, the root view is the one directly bellow QQuickWindow::contentItem
            return nullptr;
        }
    }

    return p ? asQQuickWrapper(p) : nullptr;
}

/* static */
std::shared_ptr<View> View_qtquick::asQQuickWrapper(QQuickItem *item)
{
    auto wrapper = new ViewWrapper_qtquick(item);
    return std::shared_ptr<View>(wrapper);
}

std::shared_ptr<View> View_qtquick::parentView() const
{
    return parentViewFor(this);
}

std::shared_ptr<View> View_qtquick::asWrapper()
{
    ViewWrapper *wrapper = new ViewWrapper_qtquick(this);
    return std::shared_ptr<View>(wrapper);
}

void View_qtquick::setObjectName(const QString &name)
{
    QQuickItem::setObjectName(name);
}

void View_qtquick::grabMouse()
{
    QQuickItem::grabMouse();
}

void View_qtquick::releaseMouse()
{
    QQuickItem::ungrabMouse();
}

void View_qtquick::releaseKeyboard()
{
    // Not needed for QtQuick
}

void View_qtquick::setFocus(Qt::FocusReason reason)
{
    QQuickItem::setFocus(true, reason);
    forceActiveFocus(reason);
}

bool View_qtquick::hasFocus() const
{
    return QQuickItem::hasActiveFocus();
}

Qt::FocusPolicy View_qtquick::focusPolicy() const
{
    return m_focusPolicy;
}

void View_qtquick::setFocusPolicy(Qt::FocusPolicy policy)
{
    m_focusPolicy = policy;
}

QString View_qtquick::objectName() const
{
    return QQuickItem::objectName();
}

void View_qtquick::setMinimumSize(QSize sz)
{
    if (minSize() != sz) {
        setProperty("kddockwidgets_min_size", sz);
        updateGeometry();
        View::d->layoutInvalidated.emit();
    }
}

void View_qtquick::render(QPainter *)
{
    qWarning() << Q_FUNC_INFO << "Implement me";
}

void View_qtquick::setCursor(Qt::CursorShape shape)
{
    QQuickItem::setCursor(shape);
}

void View_qtquick::setMouseTracking(bool enable)
{
    m_mouseTrackingEnabled = enable;
}

QVector<std::shared_ptr<View>> View_qtquick::childViews() const
{
    QVector<std::shared_ptr<View>> result;
    const auto childItems = QQuickItem::childItems();
    for (QQuickItem *child : childItems) {
        result << asQQuickWrapper(child);
    }

    return result;
}

void View_qtquick::onWindowStateChangeEvent(QWindowStateChangeEvent *)
{
    if (QWindow *window = QQuickItem::window()) {
        m_oldWindowState = window->windowState();
    }
}

QQuickItem *View_qtquick::createQQuickItem(const QString &filename, QQuickItem *parent) const
{
    auto p = parent;
    QQmlEngine *engine = nullptr;
    while (p && !engine) {
        engine = qmlEngine(p);
        p = p->parentItem();
    }

    if (!engine) {
        qWarning() << Q_FUNC_INFO << "No engine found";
        return nullptr;
    }

    if (!QFile::exists(filename)) {
        qWarning() << Q_FUNC_INFO << "File not found" << filename;
        return nullptr;
    }

    QQmlComponent component(engine, filename);
    auto qquickitem = qobject_cast<QQuickItem *>(component.create());
    if (!qquickitem) {
        qWarning() << Q_FUNC_INFO << component.errorString();
        return nullptr;
    }

    qquickitem->setParentItem(parent);
    qquickitem->QObject::setParent(parent);

    return qquickitem;
}

void View_qtquick::setZOrder(int z)
{
    QQuickItem::setZ(z);
}

QQuickItem *View_qtquick::visualItem() const
{
    qWarning() << Q_FUNC_INFO << "Base class called, please implement in your derived class if needed";
    return nullptr;
}

#include "View_qtquick.moc"
