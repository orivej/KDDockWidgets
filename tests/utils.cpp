/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "utils.h"
#include "Config.h"
#include "core/ViewFactory.h"
#include "NonQtCompat_p.h"
#include "kddockwidgets/core/DropArea.h"
#include "kddockwidgets/core/MainWindow.h"
#include "kddockwidgets/core/Platform.h"
#include "core/ViewGuard.h"
#include "core/Logging_p.h"
#include "kddockwidgets/core/Window.h"

using namespace KDDockWidgets;
using namespace KDDockWidgets::Core;
using namespace KDDockWidgets::Tests;

// clazy:excludeall=ctor-missing-parent-argument,missing-qobject-macro,range-loop,missing-typeinfo,detaching-member,function-args-by-ref,non-pod-global-static,reserve-candidates


std::unique_ptr<Core::MainWindow>
KDDockWidgets::Tests::createMainWindow(QSize sz, KDDockWidgets::MainWindowOptions options,
                                       const QString &name, bool show)
{
    static int count = 0;
    count++;

    if (!sz.isValid())
        sz = QSize(1000, 1000);

    const QString mainWindowName =
        name.isEmpty() ? QStringLiteral("MyMainWindow%1").arg(count) : name;
    CreateViewOptions viewOpts;
    viewOpts.isVisible = show;
    viewOpts.size = sz;
    auto ptr = std::unique_ptr<Core::MainWindow>(
        Platform::instance()->createMainWindow(mainWindowName, viewOpts, options));

    if (show)
        ptr->show();
    ptr->view()->resize(sz);

    return ptr;
}

Core::DockWidget *
KDDockWidgets::Tests::createDockWidget(const QString &name, View *guest, DockWidgetOptions options,
                                       LayoutSaverOptions layoutSaverOptions, bool show,
                                       const QString &affinityName)
{
    Q_ASSERT(guest);
    guest->setFocusPolicy(Qt::StrongFocus);
    auto dock = Config::self()
                    .viewFactory()
                    ->createDockWidget(name, options, layoutSaverOptions)
                    ->asDockWidgetController();
    dock->setAffinityName(affinityName);
    dock->setGuestView(guest->asWrapper());
    dock->setObjectName(name);
    dock->view()->setGeometry(QRect(0, 0, 400, 400));
    if (show) {
        dock->open();
        dock->dptr()->morphIntoFloatingWindow();
        Q_ASSERT(dock->floatingWindow());
        dock->view()->activateWindow();
        Q_ASSERT(dock->view()->window());
#if defined(KDDW_FRONTEND_FLUTTER)
        // Wait for window activation once we have flutter multi window
        return dock;
#else
        if (Platform::instance()->tests_waitForWindowActive(dock->view()->window(), 1000)) {
            return dock;
        }
#endif

        KDDW_INFO("KDDockWidgets::Tests::createDockWidget: Couldn't activate window");
        Q_ASSERT(false);
        return nullptr;
    } else {
        return dock;
    }
}

Core::DockWidget *KDDockWidgets::Tests::createDockWidget(const QString &name)
{
    return createDockWidget(name,
                            Platform::instance()->tests_createView({ true, {}, { 100, 100 } }));
}

std::unique_ptr<MainWindow> KDDockWidgets::Tests::createMainWindow(QVector<DockDescriptor> &docks)
{
    static int count = 0;
    count++;

    View *parent = nullptr;

    CreateViewOptions viewOpts;
    viewOpts.isVisible = true;
    viewOpts.size = QSize(1000, 1000);
    auto m = std::unique_ptr<Core::MainWindow>(Platform::instance()->createMainWindow(
        QStringLiteral("MyMainWindow%1").arg(count), viewOpts, MainWindowOption_None, parent));
    auto layout = m->layout();
    m->show();
    m->view()->resize(QSize(700, 700));

    int i = 0;
    for (DockDescriptor &desc : docks) {
        auto guest = Platform::instance()->tests_createView({ true, {}, { 100, 100 } });
        desc.createdDock =
            createDockWidget(QStringLiteral("%1-%2").arg(i).arg(count), guest, {}, {}, false);
        Core::DockWidget *relativeTo = nullptr;
        if (desc.relativeToIndex != -1)
            relativeTo = docks.at(desc.relativeToIndex).createdDock;

        m->addDockWidget(desc.createdDock, desc.loc, relativeTo, desc.option);

        layout->checkSanity();
        ++i;
    }

    return m;
}

bool KDDockWidgets::Tests::shouldBlacklistWarning(const QString &msg, const QString &category)
{
    if (category == QLatin1String("qt.qpa.xcb"))
        return true;

    return msg.contains(QLatin1String("QSocketNotifier: Invalid socket"))
        || msg.contains(QLatin1String("QWindowsWindow::setGeometry"))
        || msg.contains(QLatin1String("This plugin does not support"))
        || msg.contains(QLatin1String("Note that Qt no longer ships fonts"))
        || msg.contains(QLatin1String("Another dock KDDockWidgets::DockWidget"))
        || msg.contains(
            QLatin1String("There's multiple MainWindows, not sure what to do about parenting"));
}

void KDDockWidgets::Tests::doubleClickOn(QPoint globalPos, Window::Ptr receiver)
{
    Platform::instance()->tests_doubleClickOn(globalPos, receiver);
}

void KDDockWidgets::Tests::pressOn(QPoint globalPos, View *receiver)
{
    Platform::instance()->tests_pressOn(globalPos, receiver);
}

void KDDockWidgets::Tests::pressOn(QPoint globalPos, Window::Ptr receiver)
{
    Platform::instance()->tests_pressOn(globalPos, receiver);
}

KDDW_QCORO_TASK KDDockWidgets::Tests::releaseOn(QPoint globalPos, View *receiver)
{
    KDDW_CO_AWAIT Platform::instance()->tests_releaseOn(globalPos, receiver);
    KDDW_CO_RETURN true;
}

void KDDockWidgets::Tests::clickOn(QPoint globalPos, View *receiver)
{
    pressOn(globalPos, receiver);
    releaseOn(globalPos, receiver);
}

KDDW_QCORO_TASK KDDockWidgets::Tests::moveMouseTo(QPoint globalDest, View *receiver)
{
    QPoint globalSrc = receiver->mapToGlobal(QPoint(5, 5));

    while (globalSrc != globalDest) {
        if (globalSrc.x() < globalDest.x()) {
            globalSrc.setX(globalSrc.x() + 1);
        } else if (globalSrc.x() > globalDest.x()) {
            globalSrc.setX(globalSrc.x() - 1);
        }
        if (globalSrc.y() < globalDest.y()) {
            globalSrc.setY(globalSrc.y() + 1);
        } else if (globalSrc.y() > globalDest.y()) {
            globalSrc.setY(globalSrc.y() - 1);
        }

        if (!KDDW_CO_AWAIT Platform::instance()->tests_mouseMove(globalSrc, receiver))
            KDDW_CO_RETURN true;
    }

    KDDW_CO_RETURN true;
}

void KDDockWidgets::Tests::nestDockWidget(Core::DockWidget *dock, DropArea *dropArea,
                                          Core::Group *relativeTo, Location location)
{
    auto group = new Core::Group();
    group->addTab(dock);
    dock->d->group()->setObjectName(dock->objectName());

    dropArea->addWidget(group->view(), location, relativeTo);
    Q_ASSERT(dropArea->checkSanity());
}
