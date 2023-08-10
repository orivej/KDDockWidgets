/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "Config.h"
#include "qtwidgets/ViewFactory.h"

#include "core/MainWindow.h"
#include "core/DockWidget.h"
#include "core/Platform.h"

#include <QDebug>
#include <QString>
#include <QGuiApplication>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Core;

static bool lint(const QString &filename, RestoreOptions options)
{
    DockWidgetFactoryFunc dwFunc = [](const QString &dwName) {
        return Config::self().viewFactory()->createDockWidget(dwName)->asDockWidgetController();
    };

    MainWindowFactoryFunc mwFunc = [](const QString &mwName, MainWindowOptions mainWindowOptions) {
        return Platform::instance()->createMainWindow(mwName, {}, mainWindowOptions);
    };

    KDDockWidgets::Config::self().setDockWidgetFactoryFunc(dwFunc);
    KDDockWidgets::Config::self().setMainWindowFactoryFunc(mwFunc);

    LayoutSaver restorer(options);
    return restorer.restoreFromFile(filename);
}

int main(int argc, char *argv[])
{
    const auto frontends = Platform::frontendTypes();
    if (frontends.empty()) {
        qDebug() << "Error: Your KDDockWidgets installation doesn't support any frontend!";
        return -1;
    }

    if (argc != 2) {
        qDebug() << "Usage: kddockwidgets_linter <layout json file>";
        return 1;
    }

    // Just take the 1st frontend, any is fine
    KDDockWidgets::Core::Platform::tests_initPlatform(argc, argv, frontends[0]);

    const auto options = RestoreOption_None;
    const int exitCode = lint(qGuiApp->arguments().at(1), options) ? 0 : 2;

    KDDockWidgets::Core::Platform::tests_deinitPlatform();

    return exitCode;
}
