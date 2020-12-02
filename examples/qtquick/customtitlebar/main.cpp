/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sergio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/


#include <kddockwidgets/Config.h>
#include <kddockwidgets/DockWidgetQuick.h>
#include <kddockwidgets/private/DockRegistry_p.h>
#include <kddockwidgets/FrameworkWidgetFactory.h>

#include <QQuickView>
#include <QGuiApplication>

class CustomFrameworkWidgetFactory : public KDDockWidgets::DefaultWidgetFactory
{
public:
    QUrl titleBarFilename() const override
    {
        return QUrl("qrc:/MyTitleBar.qml");
    }
};

int main(int argc, char *argv[])
{
#ifdef Q_OS_WIN
    QGuiApplication::setAttribute(Qt::AA_UseOpenGLES);
#endif
    QGuiApplication app(argc, argv);

    auto &config = KDDockWidgets::Config::self();
    auto flags = config.flags();

    config.setFlags(flags);
    config.setFrameworkWidgetFactory(new CustomFrameworkWidgetFactory());

    QQuickView view;
    view.setObjectName("MainWindow QQuickView");
    KDDockWidgets::Config::self().setQmlEngine(view.engine());
    view.resize(1000, 800);
    view.show();
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    auto dw1 = new KDDockWidgets::DockWidgetQuick("Dock #1");
    view.setSource(QUrl("qrc:/main.qml"));

    dw1->setWidget(QStringLiteral("qrc:/Guest1.qml"));
    dw1->resize(QSize(800, 800));
    dw1->show();

    auto dw2 = new KDDockWidgets::DockWidgetQuick("Dock #2");
    dw2->setWidget(QStringLiteral("qrc:/Guest2.qml"));
    dw2->resize(QSize(800, 800));
    dw2->show();

    auto dw3 = new KDDockWidgets::DockWidgetQuick("Dock #3");
    dw3->setWidget(QStringLiteral("qrc:/Guest3.qml"));

    dw1->addDockWidgetToContainingWindow(dw3, KDDockWidgets::Location_OnRight);

    KDDockWidgets::MainWindowBase *mainWindow = KDDockWidgets::DockRegistry::self()->mainwindows().constFirst();
    mainWindow->addDockWidget(dw2, KDDockWidgets::Location_OnTop);
    return app.exec();
}
