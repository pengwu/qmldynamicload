import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Window {
    visible: true
    width: 800
    height: 800
    title: qsTr("Hello World")

    Loader {
        id: pageLoader
        anchors.fill: parent
    }

    Button {
        id: button
        anchors.centerIn: parent
        text: "load"
        onClicked: {
            button.visible = false;
            console.log("start load");
            pageLoader.source = "file://" +  applicationDirPath + "/Download/main.qml"
        }
    }
}
