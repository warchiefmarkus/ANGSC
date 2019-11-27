#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "box2dplugin.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Box2DPlugin plugin;
    plugin.registerTypes("Box2D");

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/ANGSC-Game/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
