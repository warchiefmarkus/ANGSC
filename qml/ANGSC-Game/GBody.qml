import QtQuick 2.2
import Box2D 1.0


Body {
    property alias image: image.source

    bodyType: Body.Static
        fixtures: Box {
            anchors.fill: image
            friction: 1.0
        }

        Image {
            id: image
            source: "body.png"
        }
}

