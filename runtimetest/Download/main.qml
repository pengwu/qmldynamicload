/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt3D module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Scene3D 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import Qt3D.Core 2.0

import Download 1.0

Item {
    id: main

    property real rotationValue: 0
    property var tempSubscription: 0
    property bool isPublisher: false

    Scene3D {
        id: scene3D
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        focus: true
        aspects: "input"
        Logo {
            id: watch
        }
    }

    MqttClient {
        id: client
        hostname: "localhost"
        property string name: "client3"
        //port: "1883"

    }
    Component.onCompleted: {
        client.connectToHost()
    }

    function getMessage(payload)
    {
        var res = payload.split("=");

        if ( res[2] === client.name )
            return;

        if ( res[0] === "R" )
            color_r.value = res[1];
        else if ( res[0] === "G" )
            color_g.value = res[1];
        else if ( res[0] === "B" )
            color_b.value = res[1];
        console.log(payload)
    }

    ColumnLayout {
        id: colorLayout
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: parent.width * 0.25
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.top: scene3D.top
        spacing: 5

        Text { text: "Appearance"; font.bold: true }
        Text { text: "Ambient color RGB" }
        RowLayout {
            Text { text: "R" }
            Slider {
                id: color_r
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 255
                value: 128
                onValueChanged: {
                    if ( pressed )
                         client.publish("mytopic", "R=" + value + "=" + client.name);
                }
            }
        }
        RowLayout {
            Text { text: "G" }
            Slider {
                id: color_g
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 255
                value: 195
                onPressedChanged: {
                    client.publish("mytopic", "G=" + value + "=" + client.name);
                }
            }
        }
        RowLayout {
            Text { text: "B" }
            Slider {
                id: color_b
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 255
                value: 66
                onPressedChanged: {
                    client.publish("mytopic", "B=" + value + "=" + client.name);
                }
            }
        }
        Text { text: "Shininess" }
        Slider {
            id: shining
            Layout.fillWidth: true
            minimumValue: 30
            maximumValue: 90
            value: 50
        }
    }

    ColumnLayout {
        id: transformLayout

        anchors.left: colorLayout.left
        anchors.right: colorLayout.right
        anchors.top: colorLayout.bottom
        anchors.topMargin: 10
        spacing: 5

        Text { text: "Item transform"; font.bold: true }
        Text { text: "Rotation" }
        RowLayout {
            Text { text: "X" }
            Slider {
                id: rotation_x
                Layout.fillWidth: true
                minimumValue: -45
                maximumValue: 45
                value: rotationValue
            }
        }
        RowLayout {
            Text { text: "Y" }
            Slider {
                id: rotation_y
                Layout.fillWidth: true
                minimumValue: -45
                maximumValue: 45
                value: rotationValue
            }
        }
        RowLayout {
            Text { text: "Z" }
            Slider {
                id: rotation_z
                Layout.fillWidth: true
                minimumValue: -45
                maximumValue: 45
                value: rotationValue
            }
        }

        RowLayout {
            CheckBox {id: animation; text: "Animation"; checked: false}
        }
    }

    ColumnLayout {
        id: cameraLayout

        anchors.left: colorLayout.left
        anchors.right: colorLayout.right
        anchors.top: transformLayout.bottom
        anchors.topMargin: 10
        spacing: 5

        Text { text: "Camera"; font.bold: true }
        Text { text: "View Ctr Z: " + watch.cameraZ.toFixed(2) }
        Slider {
            id: viewCenter_z
            Layout.fillWidth: true
            minimumValue: 4
            maximumValue: 12
            value: 7.5
            onValueChanged: watch.setPositionZ(value)
        }
        Button {
            id: viewAll
            Layout.fillWidth: true
            text: "View All"
            onClicked: {
                tempSubscription = client.subscribe("mytopic")
                tempSubscription.messageReceived.connect(getMessage)
                watch.viewLogo() }
        }
    }

    SequentialAnimation {
        running: true
        paused: !animation.checked
        loops: Animation.Infinite

        NumberAnimation {
            target: main
            property: "rotationValue"
            easing.type: Easing.OutQuad
            duration: 1000
            from: 0
            to: 45
        }
        NumberAnimation {
            target: main
            property: "rotationValue"
            easing.type: Easing.InOutQuad
            duration: 1000
            from: 45
            to: -45
        }
        NumberAnimation {
            target: main
            property: "rotationValue"
            easing.type: Easing.InQuad
            duration: 1000
            from: -45
            to: 0
        }
    }
}
