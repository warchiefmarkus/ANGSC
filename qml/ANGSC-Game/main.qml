
import QtQuick 2.2
import Box2D 1.0
//import QtQml 2.2
import QtQuick.Particles 2.0
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.1
import QtMultimedia 5.0
import QtGraphicalEffects 1.0


// Background
Image {
    id:background
    source:"background.png"
    width:800
    height:600

    Component.onCompleted: {
        console.log("start QML")
    }

    Timer{
        id: velocityTimer
        onTriggered: {
            //polygon2.linearVelocity.x = 200
            if (b==1){           
            rj_root_wing1.motorSpeed = -0.3
                b=0
            }else{               
                rj_root_wing1.motorSpeed = 0.3
                b=1
            }
        }
        property int b: 1
        interval: 1000
        running: true
        repeat: true
    }

    focus: true
    // Mouse Area
    MouseArea{
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            console.log("impulse")         
            wing1.applyLinearImpulse(Qt.point(5,5),Qt.point(2000,2000))             
        }
    }

    // World
    World {
        id: world
        width:background.width
        height:background.height

        gravity.x: 0
        gravity.y: -9

        // Ground
        Body {
            id: ground
            x: background.x
            y: background.height-30

            width: background.width
            height: 30

            bodyType: Body.Static

            fixtures: Box {                
                density: 1
                friction: 0.3
                restitution: 0.5
                anchors.fill: parent
            }
        }





        //-----------Двойное соединение между костями болт - растояние
        //-------------WINGS

        // Root
        Body {
            id: root

            x: 40
            y: 390
            width: 20;
            height: 20;

            sleepingAllowed: false
            bodyType: Body.Static

            fixtures: Box {
                transformOrigin: Item.Center
                density: 1.0
                friction: 0.4
                restitution: 0.3
                anchors.fill: parent
            }
            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }
        }

        /*
        Body {
            id: line

            x: 300
            y: 0
            width: 200;
            height: 100;

            sleepingAllowed: false
            bodyType: Body.Dynamic

            fixtures: Box {
                transformOrigin: Item.Center
                density: 0.3 // плотность (чем меньше стает легче и летает)
                friction: 0.12 // трение
                restitution: 0.3  // упругость (прыгает как мячик чем больше)
                anchors.fill: parent
            }
            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }
        }
        */

        Body {
            id: wing1

            x: 50
            y: 400
            width: 80;
            height: 5;

            sleepingAllowed: false
            bodyType: Body.Dynamic

            fixtures: Box {
                //--my
                //density: 0.05
                //friction: 0.01
                //restitution: 0.5
                //--ragdoll
                density: 0.3 //Плотность
                friction: 0.12 //Коэффициент трения
                restitution: 0.03 //Упругость тела
                anchors.fill: parent
            }
            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }
        }
        // соединение - растояние
        DistanceJoint{
        	id: dist_root_wing1
            world: world
            bodyA: root
            bodyB: wing1

            localAnchorA: Qt.point((root.width/2),(root.height/2)) // указівается в локальных координатах
            localAnchorB: Qt.point((wing1.width/2),(wing1.height/2))
            frequencyHz: 1.0 //пружинистость соединения
            length: 50 //длина соединения
            dampingRatio: 0.01 //коэффициент затухания
            collideConnected: false //тела могут сталкиваться
        }
        // соединение - болт
        RevoluteJoint{
            id: rj_root_wing1
            world: world
            bodyA: root
            bodyB: wing1

            enableMotor: true
            motorSpeed: 10
            maxMotorTorque: 2000

            localAnchorA: Qt.point((root.width/2),(root.height/2)) //polygon.Center
            localAnchorB: Qt.point(5,wing1.height/2)
            enableLimit: true //включаем пределы
            lowerAngle: (67/180) //нижний предел
            upperAngle: (71/180) //верхний предел

            collideConnected: false //тела могут сталкиваться
        }



         Body {
            id: wing2

            x: 125
            y: 400

            width: 80;
            height: 5;

            sleepingAllowed: false
            bodyType: Body.Dynamic

            fixtures: Box {
                   transformOrigin: Item.Center
                density: 0.3
                friction: 0.12
                restitution: 0.03
                anchors.fill: parent
            }
            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }
        }
        // соединение - растояние
        DistanceJoint{
        	id: dist_root_wing2
            world: world
            bodyA: wing1
            bodyB: wing2
            localAnchorA: Qt.point((wing1.width/2),(wing1.height/2)) // указывается в локальных координатах
            localAnchorB: Qt.point((wing2.width/2),(wing2.height/2))
            frequencyHz: 1.0 //пружинистость соединения
            length: 50 //длина соединения
            dampingRatio: 0.01 //коэффициент затухания
            collideConnected: false //тела могут сталкиваться
        }
        // соединение - болт
        RevoluteJoint{
            id: rj_root_wing2
            world: world
            bodyA: wing1
            bodyB: wing2

            localAnchorA: Qt.point((wing1.width-2),(wing1.height/2)) //polygon.Center
            localAnchorB: Qt.point(5,wing2.height/2)
            enableLimit: true //включаем пределы
            lowerAngle: (-3/180) //нижний предел
            upperAngle: (1/66) //верхний предел

            collideConnected: false //тела могут сталкиваться
        }

         Body {
            id: wing3

            x: 200
            y: 400

            width: 80;
            height: 5;

            sleepingAllowed: false
            bodyType: Body.Dynamic

            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }


            fixtures: Box {
                   transformOrigin: Item.Center
                density: 0.3
                friction: 0.12
                restitution: 0.03
                anchors.fill: parent
            }


        }
        // соединение - растояние
        DistanceJoint{
        	id: dist_root_wing3
            world: world
            bodyA: wing2
            bodyB: wing3
            localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указівается в локальных координатах
            localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
            frequencyHz: 1.0 //пружинистость соединения
            length: 50 //длина соединения
            dampingRatio: 0.01 //коэффициент затухания
            collideConnected: false //тела могут сталкиваться
        }
        // соединение - болт
        RevoluteJoint{
            id: rj_root_wing3
            world: world
            bodyA: wing2
            bodyB: wing3

            localAnchorA: Qt.point((wing2.width),(wing2.height/2)) //polygon.Center
            localAnchorB: Qt.point(5,wing3.height/2)

            enableLimit: true //включаем пределы
            lowerAngle: (-3/180) //нижний предел
            upperAngle: (1/66) //верхний предел

            collideConnected: false //тела могут сталкиваться
        }


        Body {
           id: wing4

           x: 278
           y: 400

           width: 80;
           height: 5;

           sleepingAllowed: false
           bodyType: Body.Dynamic

           Rectangle{
               color: "#f90404"
               anchors.fill: parent
           }


           fixtures: Box {
                  transformOrigin: Item.Center
               density: 0.3
               friction: 0.12
               restitution: 0.03
               anchors.fill: parent
           }


       }
       // соединение - растояние
       DistanceJoint{
           id: dist_root_wing4
           world: world
           bodyA: wing3
           bodyB: wing4
           localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указівается в локальных координатах
           localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
           frequencyHz: 1.0 //пружинистость соединения
           length: 50 //длина соединения
           dampingRatio: 0.01 //коэффициент затухания
           collideConnected: false //тела могут сталкиваться
       }
       // соединение - болт
       RevoluteJoint{
           id: rj_root_wing4
           world: world
           bodyA: wing3
           bodyB: wing4

           localAnchorA: Qt.point((wing2.width),(wing2.height/2)) //polygon.Center
           localAnchorB: Qt.point(5,wing3.height/2)

           enableLimit: true //включаем пределы
           lowerAngle: (-3/180) //нижний предел
           upperAngle: (1/66) //верхний предел

           collideConnected: false //тела могут сталкиваться
       }

       Body {
          id: wing5

          x: 358
          y: 400

          width: 80;
          height: 5;

          sleepingAllowed: false
          bodyType: Body.Dynamic

          Rectangle{
              color: "#f90404"
              anchors.fill: parent
          }


          fixtures: Box {
                 transformOrigin: Item.Center
              density: 0.3
              friction: 0.12
              restitution: 0.03
              anchors.fill: parent
          }


      }
      // соединение - растояние
      DistanceJoint{
          id: dist_root_wing5
          world: world
          bodyA: wing4
          bodyB: wing5
          localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указівается в локальных координатах
          localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
          frequencyHz: 1.0 //пружинистость соединения
          length: 50 //длина соединения
          dampingRatio: 0.01 //коэффициент затухания
          collideConnected: false //тела могут сталкиваться
      }
      // соединение - болт
      RevoluteJoint{
          id: rj_root_wing5
          world: world
          bodyA: wing4
          bodyB: wing5

          localAnchorA: Qt.point((wing2.width),(wing2.height/2)) //polygon.Center
          localAnchorB: Qt.point(5,wing3.height/2)

          enableLimit: true //включаем пределы
          lowerAngle: (-3/180) //нижний предел
          upperAngle: (1/66) //верхний предел

          collideConnected: false //тела могут сталкиваться
      }

      Body {
         id: wing6

         x: 438
         y: 400

         width: 80;
         height: 5;

         sleepingAllowed: false
         bodyType: Body.Dynamic

         Rectangle{
             color: "#f90404"
             anchors.fill: parent
         }


         fixtures: Box {
                transformOrigin: Item.Center
             density: 0.3
             friction: 0.12
             restitution: 0.03
             anchors.fill: parent
         }


     }
     // соединение - растояние
     DistanceJoint{
         id: dist_root_wing6
         world: world
         bodyA: wing5
         bodyB: wing6
         localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указівается в локальных координатах
         localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
         frequencyHz: 1.0 //пружинистость соединения
         length: 50 //длина соединения
         dampingRatio: 0.01 //коэффициент затухания
         collideConnected: false //тела могут сталкиваться
     }
     // соединение - болт
     RevoluteJoint{
         id: rj_root_wing6
         world: world
         bodyA: wing5
         bodyB: wing6

         localAnchorA: Qt.point((wing2.width),(wing2.height/2)) //polygon.Center
         localAnchorB: Qt.point(5,wing3.height/2)

         enableLimit: true //включаем пределы
         lowerAngle: (-3/180) //нижний предел
         upperAngle: (1/66) //верхний предел

         collideConnected: false //тела могут сталкиваться
     }

     Body {
        id: wing7

        x: 398
        y: 400

        width: 80;
        height: 5;

        sleepingAllowed: false
        bodyType: Body.Dynamic

        Rectangle{
            color: "#f90404"
            anchors.fill: parent
        }

        fixtures: Box {
               transformOrigin: Item.Center
            density: 0.3
            friction: 0.12
            restitution: 0.03
            anchors.fill: parent
        }


    }
    // соединение - растояние
    DistanceJoint{
        id: dist_root_wing7
        world: world
        bodyA: wing5
        bodyB: wing7
        localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указывается в локальных координатах
        localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
        frequencyHz: 1.0 //пружинистость соединения
        length: 50 //длина соединения
        dampingRatio: 0.01 //коэффициент затухания
        collideConnected: false //тела могут сталкиваться
    }
    // соединение - болт
    RevoluteJoint{
        id: rj_root_wing7
        world: world
        bodyA: wing5
        bodyB: wing7

        localAnchorA: Qt.point((wing5.width/2),(wing2.height/2)) //polygon.Center
        localAnchorB: Qt.point(5,wing2.height/2)

        enableLimit: true //включаем пределы
        lowerAngle: (-17/180) //нижний предел
        upperAngle: (1/66) //верхний предел

        collideConnected: false //тела могут сталкиваться
    }

    Body {
            id: wing8
            x: 278
            y: 400

            width: 80;
            height: 5;

            sleepingAllowed: false
            bodyType: Body.Dynamic

            Rectangle{
                color: "#f90404"
                anchors.fill: parent
            }

            fixtures: Box {
                   transformOrigin: Item.Center
                density: 0.3
                friction: 0.12
                restitution: 0.03
                anchors.fill: parent
            }


        }
        // соединение - растояние
        DistanceJoint{
            id: dist_root_wing8
            world: world
            bodyA: wing3
            bodyB: wing8
            localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указывается в локальных координатах
            localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
            frequencyHz: 1.0 //пружинистость соединения
            length: 50 //длина соединения
            dampingRatio: 0.01 //коэффициент затухания
            collideConnected: false //тела могут сталкиваться
        }
        // соединение - болт
        RevoluteJoint{
            id: rj_root_wing8
            world: world
            bodyA: wing3
            bodyB: wing8

            localAnchorA: Qt.point((wing3.width),(wing3.height/2)) //polygon.Center
            localAnchorB: Qt.point(5,wing7.height/2)

            enableLimit: true //включаем пределы
            lowerAngle: (-17/180) //нижний предел
            upperAngle: (1/66) //верхний предел

            collideConnected: false //тела могут сталкиваться
        }

        Body {
                id: wing9
                x: 358
                y: 400

                width: 80;
                height: 5;

                sleepingAllowed: false
                bodyType: Body.Dynamic

                Rectangle{
                    color: "#f90404"
                    anchors.fill: parent
                }

                fixtures: Box {
                       transformOrigin: Item.Center
                    density: 0.3
                    friction: 0.12
                    restitution: 0.03
                    anchors.fill: parent
                }


            }
            // соединение - растояние
            DistanceJoint{
                id: dist_root_wing9
                world: world
                bodyA: wing8
                bodyB: wing9
                localAnchorA: Qt.point((wing2.width/2),(wing2.height/2)) //Qt.point(78,3) // указывается в локальных координатах
                localAnchorB: Qt.point((wing3.width/2),(wing3.height/2))//Qt.point(2,3)
                frequencyHz: 1.0 //пружинистость соединения
                length: 50 //длина соединения
                dampingRatio: 0.01 //коэффициент затухания
                collideConnected: false //тела могут сталкиваться
            }
            // соединение - болт
            RevoluteJoint{
                id: rj_root_wing9
                world: world
                bodyA: wing8
                bodyB: wing9

                localAnchorA: Qt.point((wing5.width),(wing2.height/2)) //polygon.Center
                localAnchorB: Qt.point(5,wing2.height/2)

                enableLimit: true //включаем пределы
                lowerAngle: (-17/180) //нижний предел
                upperAngle: (1/66) //верхний предел

                collideConnected: false //тела могут сталкиваться
            }

            Body {
                    id: wing10
                    x: 438
                    y: 400

                    width: 80;
                    height: 5;




                    sleepingAllowed: false
                    bodyType: Body.Dynamic

                    Rectangle{
                        color: "#f90404"
                        anchors.fill: parent
                    }


                    fixtures: Box {
                           transformOrigin: Item.Center
                        density: 0.3
                        friction: 0.12
                        restitution: 0.03
                        anchors.fill: parent
                    }


                }
                // соединение - растояние
                DistanceJoint{
                    id: dist_root_wing10
                    world: world
                    bodyA: wing9
                    bodyB: wing10
                    localAnchorA: Qt.point((wing10.width/2),(wing10.height/2)) //Qt.point(78,3) // указывается в локальных координатах
                    localAnchorB: Qt.point((wing10.width/2),(wing10.height/2))//Qt.point(2,3)
                    frequencyHz: 1.0 //пружинистость соединения
                    length: 50 //длина соединения
                    dampingRatio: 0.01 //коэффициент затухания
                    collideConnected: false //тела могут сталкиваться
                }
                // соединение - болт
                RevoluteJoint{
                    id: rj_root_wing10
                    world: world
                    bodyA: wing9
                    bodyB: wing10

                    localAnchorA: Qt.point((wing10.width),(wing10.height/2)) //polygon.Center
                    localAnchorB: Qt.point(5,wing10.height/2)

                    enableLimit: false //включаем пределы
                    lowerAngle: (-17/180) //нижний предел
                    upperAngle: (1/66) //верхний предел

                    collideConnected: false //тела могут сталкиваться
                }




        /*
        GBody {
            id: girl_body

            anchors.centerIn: parent
        }
        */


        DebugDraw {
            world: world
            anchors.fill: world
            opacity: 0.75
        }



    }

















}


