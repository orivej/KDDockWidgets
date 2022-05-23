/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "TitleBar_qtquick.h"

#include "private/DragController_p.h"

#include "controllers/Frame.h"
#include "controllers/FloatingWindow.h"
#include "controllers/TitleBar.h"

#include "private/Logging_p.h"
#include "private/WindowBeingDragged_p.h"
#include "private/Utils_p.h"


using namespace KDDockWidgets;
using namespace KDDockWidgets::Views;


TitleBar_qtquick::TitleBar_qtquick(Controllers::TitleBar *controller, QQuickItem *parent)
    : View_qtquick(controller, Type::TitleBar, parent)
    , m_controller(controller)
{
    setFixedHeight(30);
}

TitleBar_qtquick::~TitleBar_qtquick()
{
}

void TitleBar_qtquick::init()
{
    // QML inteface signals
    connect(m_controller, &Controllers::TitleBar::titleChanged, this, &TitleBar_qtquick::titleChanged);
    connect(m_controller, &Controllers::TitleBar::iconChanged, this, &TitleBar_qtquick::iconChanged);
    connect(m_controller, &Controllers::TitleBar::isFocusedChanged, this, &TitleBar_qtquick::isFocusedChanged);
    connect(m_controller, &Controllers::TitleBar::closeButtonEnabledChanged, this, &TitleBar_qtquick::closeButtonEnabledChanged);
    connect(m_controller, &Controllers::TitleBar::floatButtonVisibleChanged, this, &TitleBar_qtquick::floatButtonVisibleChanged);
    connect(m_controller, &Controllers::TitleBar::floatButtonToolTipChanged, this, &TitleBar_qtquick::floatButtonToolTipChanged);
}

#ifdef DOCKS_DEVELOPER_MODE

bool TitleBar_qtquick::isCloseButtonEnabled() const
{
    if (QQuickItem *button = closeButton())
        return button->isEnabled();
    return false;
}

bool TitleBar_qtquick::isCloseButtonVisible() const
{
    if (QQuickItem *button = closeButton())
        return button->isVisible();

    return true;
}

bool TitleBar_qtquick::isFloatButtonVisible() const
{
    if (QQuickItem *button = floatButton())
        return button->isVisible();

    return true;
}

#endif

QQuickItem *TitleBar_qtquick::titleBarQmlItem() const
{
    return m_titleBarQmlItem;
}

QQuickItem *TitleBar_qtquick::titleBarMouseArea() const
{
    if (m_titleBarQmlItem)
        return m_titleBarQmlItem->property("mouseAreaForTests").value<QQuickItem *>();

    return nullptr;
}

void TitleBar_qtquick::setTitleBarQmlItem(QQuickItem *item)
{
    if (item != m_titleBarQmlItem) {
        m_titleBarQmlItem = item;
        Q_EMIT titleBarQmlItemChanged();
    }
}

QQuickItem *TitleBar_qtquick::floatButton() const
{
    return m_titleBarQmlItem ? m_titleBarQmlItem->property("floatButton").value<QQuickItem *>()
                             : nullptr;
}

QQuickItem *TitleBar_qtquick::closeButton() const
{
    return m_titleBarQmlItem ? m_titleBarQmlItem->property("closeButton").value<QQuickItem *>()
                             : nullptr;
}

void TitleBar_qtquick::updateMaximizeButton()
{
    qFatal("Not implemented");
}

bool TitleBar_qtquick::isFocused() const
{
    return m_controller->isFocused();
}

bool TitleBar_qtquick::floatButtonVisible() const
{
    return m_controller->floatButtonVisible();
}

bool TitleBar_qtquick::closeButtonEnabled() const
{
    return m_controller->closeButtonEnabled();
}

QString TitleBar_qtquick::floatButtonToolTip() const
{
    return m_controller->floatButtonToolTip();
}

bool TitleBar_qtquick::hasIcon() const
{
    return m_controller->hasIcon();
}

QString TitleBar_qtquick::title() const
{
    return m_controller->title();
}

void TitleBar_qtquick::setCloseButtonEnabled(bool is)
{
    m_controller->setCloseButtonEnabled(is);
}

void TitleBar_qtquick::setFloatButtonVisible(bool is)
{
    m_controller->setFloatButtonVisible(is);
}
