/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/
//import QtQuick 2.0
import QtQuick 2.9
//import QtQuick.Controls 2.5
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.Application 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0
import Machinekit.Application.Controls 1.0
import Qt.labs.settings 1.0
//import Theme 1.0
import "./Controls"
import "./Controls.2"
import "./ManualTab"
import "./StatusBar"

//HalApplicationWindow {


ServiceWindow {
    id: window

    property bool wasConnected: false
    property double gaugeZ0BorderValue: 50.0
    property double gaugeMinimumValue: 0
    property double gaugeMaximumValue: 1024
    property double gaugeZ1BorderValue: gaugeMaximumValue * 0.9
    property double savedMresValue
    property double savedTblValue
    property double savedHendValue
    property double savedHstrtValue
    property double savedToffValue
    property double savedSednValue
    property double savedSemaxValue
    property double savedSeupValue
    property double savedSeminValue
    property double savedSgtValue
    property double savedCsValue
    property double savedSiphValue
    property double savedSiplValue
    property double savedTs2gValue
    property double savedRdselValue

    property bool defIntpolValue
    property bool defDedgeValue
    property double defMresValue

    property double defTblValue
    property bool defChmValue
    property bool defRndtfValue
    property bool defHdec1Value
    property bool defHdec0Value
    property double defHendValue
    property double defHstrtValue
    property double defToffValue

    property bool defSeiminValue
    property double defSednValue
    property double defSemaxValue
    property double defSeupValue
    property double defSeminValue


    property bool defSfiltValue
    property double defSgtValue
    property double defCsValue

    property bool defTstValue
    property double defSlphValue
    property double defSlplValue
    property bool defDiss2gValue
    property double defTs2gValue
    property bool defSdoffValue
    property bool defVsenseValue
    property double defRdselValue

    property int drvctrlReg:  drvctrlRegPin.value
    property int chopconfReg: chopconfRegPin.value
    property int smartenReg:  smartenRegPin.value
    property int sgcsconfReg: sgcsconfRegPin.value
    property int drvconfReg:  drvconfRegPin.value
    property string regValues: "DRVCTRL  \t0x" + zeroPad(drvctrlReg,8) + "\n" +
                               "CHOPCONF \t0x" + zeroPad(chopconfReg,8) + "\n" +
                               "SMARTEN  \t0x" + zeroPad(smartenReg,8) + "\n" +
                               "SGCSCONF \t0x" + zeroPad(sgcsconfReg,8) + "\n" +
                               "DRVCONF  \t0x" + zeroPad(drvconfReg,8)
    property string fullreadresponses: "Read Response 0 \t0x" + zeroPad(fullreadresponsePin_0.value, 8) + "\n" +
                                       "Read Response 1 \t0x" + zeroPad(fullreadresponsePin_1.value,8) + "\n" +
                                       "Read Response 2 \t0x" + zeroPad(fullreadresponsePin_2.value,8) + "\n" +
                                       "Read Response 3 \t0x" + zeroPad(fullreadresponsePin_3.value,8) + "\n" +
                                       "Read Response 4 \t0x" + zeroPad(fullreadresponsePin_4.value,8)
    property string fullreadresponseValue_0: "Read Response 0:\t  0x" + zeroPad(fullreadresponsePin_0.value, 8)
    property string fullreadresponseValue_1: "Read Response 1:\t  0x" + zeroPad(fullreadresponsePin_1.value,8)
    property string fullreadresponseValue_2: "Read Response 2:\t  0x" + zeroPad(fullreadresponsePin_2.value,8)
    property string fullreadresponseValue_3: "Read Response 3:\t  0x" + zeroPad(fullreadresponsePin_3.value,8)
    property string fullreadresponseValue_4: "Read Response 4:\t  0x" + zeroPad(fullreadresponsePin_4.value,8)
    Component.onCompleted: { timer.setTimeout(function(){ g.dlymsg(1); }, 360 + 100); }
    title: applicationCore.applicationName + (d.machineName === "" ? "" :" - " +  d.machineName)

    statusBar: applicationStatusBar
    toolBar: applicationToolBar
    menuBar: applicationMenuBar

    function zeroPad(num, places) {
            num = num.toString(16).toUpperCase();
            return num.length < places ? zeroPad("0" + num, places) : num;
        }

    Timer {
        id: timer
        function setTimeout(cb, delayTime) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.triggered.connect(function release () {
                timer.triggered.disconnect(cb); // This is important
                timer.triggered.disconnect(release); // This is important as well
            });
            timer.start();
        }
    }

    QtObject {
        id: g

        function dlymsg(x) {
            if(x===1) {
                window.defIntpolValue = intpolSetPin.value
                window.defDedgeValue = dedgeSetPin.value
                window.defMresValue = mresSetSpin.value
                window.defTblValue = tblSetSpin.value
                window.defChmValue = chmSetPin.value
                window.defRndtfValue = rndtfSetPin.value
                window.defHdec1Value = hdec1SetPin.value
                window.defHdec0Value = hdec0SetPin.value
                window.defHendValue = hendSetSpin.value
                window.defHstrtValue = hstrtSetSpin.value
                window.defToffValue = toffSetSpin.value
                window.defSeiminValue = seiminSetPin.value
                window.defSednValue = sednSetSpin.value
                window.defSemaxValue = semaxSetSpin.value
                window.defSeupValue = seupSetSpin.value
                window.defSeminValue = seminSetSpin.value
                window.defSfiltValue = sfiltSetPin.value
                window.defSgtValue = sgtSetSpin.value
                window.defCsValue = csSetSpin.value
                window.defTstValue = tstSetPin.value
                window.defSlphValue = slphSetSpin.value
                window.defSlplValue = slplSetSpin.value
                window.defDiss2gValue = diss2gSetPin.value
                window.defTs2gValue = ts2gSetSpin.value
                window.defSdoffValue = sdoffSetPin.value
                window.defVsenseValue = vsenseSetPin.value
                window.defRdselValue = rdselSetSpin.value
            }
        }
    }

    ColumnLayout {
        id: columnwindow
        anchors.fill: parent
        anchors.margins: 10

        Loader {
                id: applicationToolBar
                source: "ApplicationToolBar.qml"
                active: true
        }

        Service {
            id: halrcompService
            type: "halrcomp"
        }

        Service {
            id: halrcmdService
            type: "halrcmd"
        }

        ApplicationCore {
            id: applicationCore
            notifications: applicationNotifications
            applicationName: "Trinamic-SPI"
        }


        visible: halRemoteComponent.ready || wasConnected
        enabled:  halRemoteComponent.connected

        HalRemoteComponent {
            id: halRemoteComponent
            halrcmdUri: halrcmdService.uri
            halrcompUri: halrcompService.uri
            ready: (halrcmdService.ready && halrcompService.ready) || connected
            name: "TrinamicSPI"
            containerItem: window
            create: false
            onErrorStringChanged: console.log(errorString)
            onConnectedChanged: window.wasConnected = true
        }

        Item {  // Hal Pins
            HalPin {
                id: drvctrlRegPin
                name: "drvctrl.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: chopconfRegPin
                name: "chopconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: smartenRegPin
                name: "smarten.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: sgcsconfRegPin
                name: "sgcsconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: drvconfRegPin
                name: "drvconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_0
                name: "full.0.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_1
                name: "full.1.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_2
                name: "full.2.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_3
                name: "full.3.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_4
                name: "full.4.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: intpolSetPin
                name: "intpol.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: dedgeSetPin
                name: "dedge.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: chmSetPin
                name: "chm.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: rndtfSetPin
                name: "rndtf.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: hdec1SetPin
                name: "hdec1.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: hdec0SetPin
                name: "hdec0.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: seiminSetPin
                name: "seimin.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: sfiltSetPin
                name: "sfilt.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: tstSetPin
                name: "tst.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: diss2gSetPin
                name: "diss2g.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: sdoffSetPin
                name: "sdoff.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: vsenseSetPin
                name: "vsense.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }
        }

        RowLayout {
            ColumnLayout { // Status leds
                Layout.preferredWidth: 50
                Layout.alignment: Qt.AlignLeft
                ColumnLayout {
                    Label {
                        id: ststLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "stst"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: ststLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "stst.status"
                        onColor: "yellow"
                        Layout.preferredHeight: ststLabel.height * 0.9
                        Layout.preferredWidth: ststLabel.height * 0.9
                        property string ststtoolTipText: "STST\ntandstill indicator\n0: No standstill condition detected.\nYellow: No active edge occurred on the STEP\ninput during the last 220 system clock cycles."
                        ToolTip.text: ststtoolTipText
                        ToolTip.visible: ststtoolTipText ? ststa.containsMouse : false
                        MouseArea {
                            id: ststa
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: olbLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "olb"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olbLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "olb.status"
                        onColor: "red"
                        Layout.preferredHeight: olbLabel.height * 0.9
                        Layout.preferredWidth: olbLabel.height * 0.9
                        property string olbtoolTipText: "OLB\nOpen load indicator\n0: No open load condition detected.\nRed: No chopper event has happened during\nthe last period with constant coil polarity.\nOnly a current above 1/16 of the maximum\nsetting can clear this bit!\nHint: This bit is only a status indicator. The\nchip takes no other action when this bit is\nset. False indications may occur during fast\nmotion and at standstill. Check this bit only\nduring slow motion."
                        ToolTip.text: olbtoolTipText
                        ToolTip.visible: olbtoolTipText ? olba.containsMouse : false
                        MouseArea {
                            id: olba
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: olaLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "ola"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olaLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "ola.status"
                        onColor: "red"
                        Layout.preferredHeight: olaLabel.height * 0.9
                        Layout.preferredWidth: olaLabel.height * 0.9
                        property string olatoolTipText: "OLA\nOpen load indicator\n0: No open load condition detected.\nRed: No chopper event has happened during\nthe last period with constant coil polarity.\nOnly a current above 1/16 of the maximum\nsetting can clear this bit!\nHint: This bit is only a status indicator. The\nchip takes no other action when this bit is\nset. False indications may occur during fast\nmotion and at standstill. Check this bit only\nduring slow motion."
                        ToolTip.text: olatoolTipText
                        ToolTip.visible: olatoolTipText ? olaa.containsMouse : false
                        MouseArea {
                            id: olaa
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gbLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "s2gb"
//                        color: "#21be2b"
                        horizontalAlignment: Text.AlignLeft
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gbLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "s2gb.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gbLabel.height * 0.9
                        Layout.preferredWidth: s2gbLabel.height * 0.9
                        property string s2gbtoolTipText: "S2GB\nShort to GND detection bits on high-side transistors\n0: No short to ground shutdown condition.\nRed: Short to ground shutdown condition.\nThe short counter is incremented by each\nshort circuit and the chopper cycle is\nsuspended. The counter is decremented for\neach phase polarity change. The MOSFETs are\nshut off when the counter reaches 3 and\nremain shut off until the shutdown condition\nis cleared by disabling and re-enabling the\ndriver. The shutdown condition becomes\nreset by deasserting the ENN input or clearing\nthe TOFF parameter."
                        ToolTip.text: s2gbtoolTipText
                        ToolTip.visible: s2gbtoolTipText ? s2gba.containsMouse : false
                        MouseArea {
                            id: s2gba
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gaLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text:" s2ga"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gaLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "s2ga.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gaLabel.height * 0.9
                        Layout.preferredWidth: s2gaLabel.height * 0.9
                        property string s2gatoolTipText: "S2GA\nShort to GND detection bits on high-side transistors\n0: No short to ground shutdown condition.\nRed: Short to ground shutdown condition.\nThe short counter is incremented by each\nshort circuit and the chopper cycle is\nsuspended. The counter is decremented for\neach phase polarity change. The MOSFETs are\nshut off when the counter reaches 3 and\nremain shut off until the shutdown condition\nis cleared by disabling and re-enabling the\ndriver. The shutdown condition becomes\nreset by deasserting the ENN input or clearing\nthe TOFF parameter."
                        ToolTip.text: s2gatoolTipText
                        ToolTip.visible: s2gatoolTipText ? s2gaa.containsMouse : false
                        MouseArea {
                            id: s2gaa
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: otpwLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "otpw"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otpwLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "otpw.status"
                        onColor: "red"
                        Layout.preferredHeight: otpwLabel.height * 0.9
                        Layout.preferredWidth: otpwLabel.height * 0.9
                        property string otpwtoolTipText: "OTPW\nOvertemperature warning\n0: No overtemperature warning condition.\nRed: Warning threshold is active."
                        ToolTip.text: otpwtoolTipText
                        ToolTip.visible: otpwtoolTipText ? otpwa.containsMouse : false
                        MouseArea {
                            id: otpwa
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: otLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "ot"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "ot.status"
                        onColor: "red"
                        Layout.preferredHeight: otLabel.height * 0.9
                        Layout.preferredWidth: otLabel.height * 0.9
                        property string ottoolTipText: "OT\nOvertemperature shutdown\n0: No overtemperature shutdown condition.\nRed: Overtemperature shutdown has occurred."
                        ToolTip.text: ottoolTipText
                        ToolTip.visible: ottoolTipText ? ota.containsMouse : false
                        MouseArea {
                            id: ota
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                ColumnLayout {
                    Label {
                        id: sgLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "sg"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: sgLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "sg.status"
                        onColor: "red"
                        Layout.preferredHeight: sgLabel.height * 0.9
                        Layout.preferredWidth: sgLabel.height * 0.9
                        property string sgtoolTipText: "SG\nstallGuard2 status\n0: No motor stall detected.\nRed: stallGuard2 threshold has been reached,\nand the SG_TST output is driven high."

                        ToolTip.text: sgtoolTipText
                        ToolTip.visible: sgtoolTipText ? sga.containsMouse : false
                        MouseArea {
                            id: sga
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            ColumnLayout {  // Main window
                id: transport
                ApplicationStatusBar { id: applicationStatusBar }
                ApplicationMenuBar { id: applicationMenuBar }

                RowLayout {  // Velocity labels
                    Layout.fillWidth: true


                    Label {
                        text: qsTr("Axis")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    AxisRadioGroup {
                        id: axisRadioGroup
                        Layout.fillWidth: false
                    }
                }

                RowLayout {  // Jog selection
                    Layout.fillWidth: true

                    JogButton {
                        id: decrementButton
                        Layout.fillWidth: false
                        direction: -1
                        distance: jogCombo.distance
                        axis: axisRadioGroup.axis
                        checkable: true
                    }

                    JogButton {
                        id: incrementButton
                        Layout.fillWidth: false
                        direction: 1
                        distance: jogCombo.distance
                        axis: axisRadioGroup.axis
                        checkable: true
                    }

                    JogDistanceComboBox {
                        id: jogCombo
                        Layout.fillWidth: true
                        axis: axisRadioGroup.axis
                    }

                    KeyboardJogControl {
                        id: keyboardJogControl
                        enabled: jogCombo.distance !== 0.0
                        onSelectAxis: axisRadioGroup.axis = axis
                        onIncrement: incrementButton._toggle(enabled)
                        onDecrement: decrementButton._toggle(enabled)
                        onSelectIncrement: {
                            if (jogCombo.currentIndex == 0) {
                                jogCombo.currentIndex = index;
                            }
                        }
                    }
                }

                RowLayout {  // Jog velocity labels
                    Layout.fillWidth: true
                    Layout.fillHeight: false

                    Label {
                        text: qsTr("Jog Velocity")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: (jogVelocitySlider.displayValue.toFixed(1) << mresSetSpin.value) + " " + "rev/min"
                    }
                }

                JogVelocitySlider { // Jog velocity slide
                    id: jogVelocitySlider
                    Layout.fillWidth: true
                    axis: axisRadioGroup.axis
                    proportional: false
                }

                HalGauge {
                    id: sgGauge
                    Layout.fillWidth: true
                    name: "sg.readout"
                    suffix: ""
                    decimals: 0
                    valueVisible: true
                    minimumValueVisible: false
                    maximumValueVisible: false
                    minimumValue: window.gaugeMinimumValue
                    maximumValue: window.gaugeMaximumValue
                    z0BorderValue: window.gaugeZ0BorderValue
                    z1BorderValue: window.gaugeZ1BorderValue
                    z0Color: valueVisible ? "green" : "white"
                    z1Color: valueVisible ? "yellow" : "white"
                    z2Color: valueVisible ? "red" : "white"

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: qsTr("N/A")
                        visible: !sgGauge.valueVisible
                    }

                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: control.visible = !control.visible
                        onClicked: sgChart.visible = !sgChart.visible
                        cursorShape: "PointingHandCursor"
                    }
                }

                RowLayout {  // Readout row
                    RowLayout {
                        id: readout
                        anchors.margins: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {  // First Column (SPI Readout)
                            spacing: 5// Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                            TextArea {  // Column header
                                height: 32
                                text: "SPI registers\t Values:              "
                                color: "black"// color can be set on the entire element with this property

                            }

                            Rectangle { // Current register values
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                height: 130; width: parent.width -20
                                color: "white"//mouseArea2.pressed ? "black" : "gray"
                                TextArea {
                                    id: regTxt
//                                    Layout.alignment: left
                                    text: window.regValues
                                    readOnly: true
                                    selectByMouse: true
                                    color: "black"// color can be set on the entire element with this property

                                    Popup {
                                        padding: 10
                                        id: popup1
                                        contentItem: Text { text: "Double click to copy register values to Clipboard" }
                                    }

                                    Popup {
                                        padding: 10
                                        id: popup2
                                        contentItem: Text { text: "Register values copied to Clipboard" }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onDoubleClicked: { regTxt.selectAll(); regTxt.copy(); popup2.open(); regTxt.deselect()}
                                        onClicked: popup1.open()
                                        cursorShape: "PointingHandCursor"
                                    }

                                    Menu {
                                        id: contextMenu
                                        MenuItem {
                                            text: "Cut"
                                            onTriggered: {
                                                regTxt.cut()
                                            }
                                        }
                                        MenuItem {
                                            text: "Copy"
                                            onTriggered: {
                                                regTxt.copy()
                                            }
                                        }
                                        MenuItem {
                                            text: "Paste"
                                            onTriggered: {
                                                regTxt.paste()
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {  // Read responses
                                height: 130; width: parent.width -20// color: mouseArea2.pressed ? "black" : "gray"
                                color: "light green"
                                Column {
                                    TextArea {
//                                        id: readresponseTxt_0
//                                        text: window.fullreadresponseValue_0
                                        id: readresponsesTxt
                                        text: window.fullreadresponses
                                        color: "black"// color can be set on the entire element with this property
                                    }
//                                    TextArea {
//                                        id: readresponseTxt_1
//                                        text: window.fullreadresponseValue_1
//                                        color: "black"// color can be set on the entire element with this property
//                                    }
//                                    TextArea {
//                                        id: readresponseTxt_2
//                                        text: window.fullreadresponseValue_2
//                                        color: "black"// color can be set on the entire element with this property
//                                    }
//                                    TextArea {
//                                        id: readresponseTxt_3
//                                        text: window.fullreadresponseValue_3
//                                        color: "black"// color can be set on the entire element with this property
//                                    }
//                                    TextArea {
//                                        id: readresponseTxt_4
//                                        text: window.fullreadresponseValue_4
//                                        color: "black"// color can be set on the entire element with this property
//                                    }
                                }
                            }
                        }

                        Column {  // First Column (SPI Readout)
                            TextArea {  // Column header
                                height: 32
                                text: "SG Values:              "
                                color: "black"// color can be set on the entire element with this property

                            }

                            LogChart {
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                id: sgChart
                                Layout.fillHeight: true
                                visible: true
                                value: sgGauge.value
                                minimumValue: sgGauge.minimumValue
                                maximumValue: sgGauge.maximumValue
                                leftTextVisible: false
                                rightTextVisible: false
                                autoSampling: (sgGauge.halPin.synced) && visible
                                autoUpdate: autoSampling
                                updateInterval: 250
                                timeSpan: 100000
                                Layout.maximumHeight: 256
                                Layout.maximumWidth: 1024
                                gridColor: qsTr("#eeeeee")
                                backgroundColor: qsTr("#ffffff")
                                property string sgCharttoolTipText: " Tuning the stallGuard2 Threshold\n" +
                                "Due to the dependency of the stallGuard2 value SG from motor-specific characteristics and application-\n" +
                                "specific demands on load and velocity the easiest way to tune the stallGuard2 threshold SGT for a\n" +
                                "specific motor type and operating conditions is interactive tuning in the actual application.\n" +
                                "The procedure is:\n" +
                                "1. Operate the motor at a reasonable velocity for your application and monitor SG.\n" +
                                "2. Apply slowly increasing mechanical load to the motor. If the motor stalls before SG reaches\n" +
                                "zero, decrease SGT. If SG reaches zero before the motor stalls, increase SGT. A good SGT\n" +
                                "starting value is zero. SGT is signed, so it can have negative or positive values.\n" +
                                "3. The optimum setting is reached when SG is between 0 and 400 at increasing load shortly\n" +
                                "before the motor stalls, and SG increases by 100 or more without load. SGT in most cases can\n" +
                                "be tuned together with the motion velocity in a way that SG goes to zero when the motor\n" +
                                "stalls and the stall output SG_TST is asserted. This indicates that a step has been lost."
                                ToolTip.text: sgCharttoolTipText
                                ToolTip.visible: sgCharttoolTipText ? sgCharta.containsMouse : false
                                MouseArea {
                                    id: sgCharta
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }
                        }
                    }
                }

                RowLayout {  // Settings row
                    Column {  // First Column (Drvctrl)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Drvctrl:")
                        }

                        RowLayout {// set intpol bit

                            id: intpolcontrol
                            visible: true

                            Label {
                                id: intpolLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text:"Interpolation"
                                property string intpoltoolTipText: "INTPOL"
                                ToolTip.text: intpoltoolTipText
                                ToolTip.visible: intpoltoolTipText ? intpola.containsMouse : false
                                MouseArea {
                                    id: intpola
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Switch2 {
                                id: intpolonOffSwitch
                                enabled: true
                                text: intpolSetPin.value  > 0 ? "x16" : "Disabled"
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("0: Disable STEP pulse interpolation.\n1: Enable STEP pulse multiplication by 16.")

                                onCheckedChanged: {
                                    if (checked) {
                                            intpolSetPin.value = 1
                                            intpolonOffSwitch.text = "x16"
                                    }
                                    else {
                                        intpolSetPin.value = 0
                                        intpolonOffSwitch.text = "Disabled"
                                    }
                                    transport.forceActiveFocus()
                                    transport.focus = true
                                }

                                Binding {
                                    target: intpolonOffSwitch
                                    property: "down"
                                    value: intpolSetPin.value  != window.defIntpolValue
                                }
                            }
                        }

                        RowLayout {// set dedge bit

                            id: dedgecontrol
                            visible: true
//                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Label {
                                id: dedgeLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text: "Step Edges"
                                property string dedgetoolTipText: "DEDGE"
                                ToolTip.text: dedgetoolTipText
                                ToolTip.visible: dedgetoolTipText ? dedgea.containsMouse : false
                                MouseArea {
                                    id: dedgea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Switch2 {
                                id: dedgeonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: dedgeSetPin.value  > 0 ? "Double Edge" : "Rising Edge"
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("0: Rising STEP pulse edge is active, falling edge is inactive.\n1: Both rising and falling STEP pulse edges are active.")
                                onCheckedChanged: {
                                    if (checked) {
                                            dedgeSetPin.value = 1
                                            dedgeonOffSwitch.text = "Double Edge"
                                    }
                                    else {
                                        dedgeSetPin.value = 0
                                        dedgeonOffSwitch.text = "Rising Edge"
                                    }
                                }

                                Binding {
                                    target: dedgeonOffSwitch
                                    property: "down"
                                    value: dedgeSetPin.value  != window.defDedgeValue
                                }
                            }
                        }

                        RowLayout {// set mres values

                            id: mrescontrol
                            visible: true

                            Label {
                                id: mresLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Res"
                                property string mrestoolTipText: "MRES"
                                ToolTip.text: mrestoolTipText
                                ToolTip.visible: mrestoolTipText ? mresa.containsMouse : false
                                MouseArea {
                                    id: mresa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: mresSetSpin
                                enabled: true
                                name: "mres.set"
                                halPin.direction: HalPin.IO
                                from: items.length - 1
                                to: 0// items.length - 1
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Microsteps per Fullstep:")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5
//                                  onValueModified: {            // remove the focus from this control
//                                      applicationNotifications.forceActiveFocus()
//                                      applicationNotifications.focus = true
//                                  }

                                property var items: ["256", "128", "64", "32", "16", "8", "4", "2", "1"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(256|128|64|32|16|8|4|2|1)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return mressb.value
                                }
                            }

                            Label {
                                id: mresValsetLabel
                                font.bold: true
                                text: "μSt"
                            }

                            Switch2 {
                                id: mresonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (mresSetSpin.value != window.savedMresValue) {
                                            window.savedMresValue = mresSetSpin.value
                                        }
                                    }
                                    else {
                                        mresSetSpin.value = window.savedMresValue
                                    }
                                }

                                Binding {
                                    target: mresonOffSwitch
                                    property: "down"
                                    value: mresSetSpin.value != window.defMresValue
                                }
                            }
                        }

//                     Item {
//                         Layout.fillHeight: true
//                     }

                    }

                    Column {  // Second Column (Chopconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {  // Header
                            font.bold: true
                            text: qsTr("Chopconf:")
                        }

                        RowLayout {// set tbl values

                            id: tblcontrol
                            visible: true

                            Label {
                                id: tblValsetLabel
                                font.bold: true
                                text: "Blank time"
                                property string tbltoolTipText: "TBL"
                                ToolTip.text: tbltoolTipText
                                ToolTip.visible: tbltoolTipText ? tbla.containsMouse : false
                                MouseArea {
                                    id: tbla
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: tblSetSpin
//                                property double defTbl

                                enabled: true
                                name: "tbl.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
    //                                 font.pixelSize: 30
    //                                 scale: 0.5
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Blanking time interval, in system clock periods:")

                                property var items: ["16", "24", "36", "54"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(16|24|36|54)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return tblSetSpin.value
                                }
                            }

                            Switch2 {
                                id: tblonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (tblSetSpin.value != window.savedTblValue) {
                                            window.savedTblValue = tblSetSpin.value
                                        }
                                    }
                                    else {
                                        tblSetSpin.value = window.savedTblValue
                                    }
                                }
                                 Binding {
                                     target: tblonOffSwitch
                                     property: "down"
                                     value: tblSetSpin.value  != window.defTblValue
                                 }
                            }

                        }

                        RowLayout {// set chm bit

                            id: chmcontrol
                            visible: true

                            Label {
                                id: chmValsetLabel
                                font.bold: true
                                text: "CHop Mode"
                                property string chmtoolTipText: "CHM"
                                ToolTip.text: chmtoolTipText
                                ToolTip.visible: chmtoolTipText ? chma.containsMouse : false
                                MouseArea {
                                    id: chma
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Switch2 {
                                id: chmonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: chmSetPin.value  > 0 ? "Constant tOFF" : "SpreadCycle"
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("This mode bit affects the interpretation of the HDEC,\nHEND, and HSTRT parameters shown below.\n0: Standard mode (spreadCycle)\n1: Constant tOFF with fast decay time.\nFast decay time is also terminated when the\nnegative nominal current is reached. Fast\ndecay is after on time.
")
                                onCheckedChanged: {
                                    if (checked) {
                                            chmSetPin.value = 1
                                            chmonOffSwitch.text = "Constant tOFF"
                                    }
                                    else {
                                        chmSetPin.value = 0
                                        chmonOffSwitch.text = "SpreadCycle"
                                    }
                                }

                                Binding {
                                    target: chmonOffSwitch
                                    property: "down"
                                    value: chmSetPin.value  != window.defChmValue
                                }
                            }
                        }

                        RowLayout {// set rndtf bit

                            id: rndtfcontrol
                            visible: true

                            Label {
                                id: rndtfValsetLabel
                                font.bold: true
                                text: "TOFF time"
                                property string rndtftoolTipText: "RNDTF"
                                ToolTip.text: rndtftoolTipText
                                ToolTip.visible: rndtftoolTipText ? rndtfa.containsMouse : false
                                MouseArea {
                                    id: rndtfa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Switch2 {
                                id: rndtfonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: rndtfSetPin.value  > 0 ? "Random" : "Fixed"
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Enable randomizing the slow decay phase duration:\n0: Chopper off time is fixed as set by bits t OFF\n1:  Random mode, tOFF is random modulated by\ndNCLK= -12 ... +3 clocks.")
                                onCheckedChanged: {
                                    if (checked) {
                                            rndtfSetPin.value = 1
                                            rndtfonOffSwitch.text = "Random"
                                    }
                                    else {
                                        rndtfSetPin.value = 0
                                        rndtfonOffSwitch.text = "Fixed"
                                    }
                                }

                                Binding {
                                    target: rndtfonOffSwitch
                                    property: "down"
                                    value: rndtfSetPin.value  != window.defRndtfValue
                                }
                            }
                        }

                        RowLayout {// set hdec1 values

                            id: hdec1control
                            visible: true

                            Switch2 {
                                id: hdec1onOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: qsTr("Hysteresis DECrement period 1")
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("HCEC1:\nCHopMode=0:\n Hysteresis decrement period setting, in\nsystem clock periods:\n\nCHopMode=1:\nHDEC1=0: current comparator can terminate\nthe fast decay phase before timer expires.\nHDEC1=1: only the timer terminates the fast\ndecay phase.\nHDEC0: MSB of fast decay time setting.")
                                onCheckedChanged: {
                                    if (checked) {
                                            hdec1SetPin.value = 1
                                    }
                                    else {
                                        hdec1SetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: hdec1onOffSwitch
                                    property: "down"
                                    value: hdec1SetPin.value  != window.defHdec1Value
                                }
                            }
                        }

                        RowLayout {// set hdec0 values

                            id: hdec0control
                            visible: true

                            Switch2 {
                                id: hdec0onOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: qsTr("Hysteresis DECrement period 0")
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("HCEC0:\nCHopMode=0:\n Hysteresis decrement period setting, in\nsystem clock periods:\n\nCHopMode=1:\nHDEC1=0: current comparator can terminate\nthe fast decay phase before timer expires.\nHDEC1=1: only the timer terminates the fast\ndecay phase.\nHDEC0: MSB of fast decay time setting.")
                                onCheckedChanged: {
                                    if (checked) {
                                            hdec0SetPin.value = 1
                                    }
                                    else {
                                        hdec0SetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: hdec0onOffSwitch
                                    property: "down"
                                    value: hdec0SetPin.value != window.defHdec0Value
                                }
                            }
                        }

                        RowLayout {// set hend values

                            id: hendcontrol
                            visible: true

                            Label {
                                id: hendValsetLabel
                                font.bold: true
                                text: "Hys END (lo)  "
                                property string hendtoolTipText: "HEND"
                                ToolTip.text: hendtoolTipText
                                ToolTip.visible: hendtoolTipText ? henda.containsMouse : false
                                MouseArea {
                                    id: henda
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: hendSetSpin
                                enabled: true
                                name: "hend.set"
                                halPin.direction: HalPin.IO
                                from: -3
                                to: 12
                                // chm =0
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("HEND\nCHopMode=0:\n %0000 ... %1111:\nHysteresis is -3, -2, -1, 0, 1, ..., 12\n(1/512 of this setting adds to current setting)\nThis is the hysteresis value which becomes\nused for the hysteresis chopper.\n\nCHopMode=1:\n%0000 ... %1111:\nOffset is -3, -2, -1, 0, 1, ..., 12\nThis is the sine wave offset and 1/512 of the\nvalue becomes added to the absolute value\nof each sine wave entry.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

//                                 onValueModified: {            // remove the focus from this control
//                                     parent.forceActiveFocus()
//                                     parent.focus = true
//                                 }
                            }

                            Switch2 {
                                id: hendonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (hendSetSpin.value != window.savedHendValue) {
                                            window.savedHendValue = hendSetSpin.value
                                        }
                                    }
                                    else {
                                        hendSetSpin.value = window.savedHendValue
                                    }
                                }

                                Binding {
                                    target: hendonOffSwitch
                                    property: "down"
                                    value: hendSetSpin.value  != window.defHendValue
                                }
                            }
                        }

                        RowLayout {// set hstrt values

                            id: hstrtcontrol
                            visible: true

                            Label {
                                id: hstrtValsetLabel
                                font.bold: true
                                text: "HyS sTaRT val"
                                property string hstrttoolTipText: "HSTRT"
                                ToolTip.text: hstrttoolTipText
                                ToolTip.visible: hstrttoolTipText ? hstrta.containsMouse : false
                                MouseArea {
                                    id: hstrta
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: hstrtSetSpin
                                enabled: true
                                name: "hstrt.set"
                                halPin.direction: HalPin.IO
                                from: 0 //items.length - 1
                                to: items.length - 1
                            // chm =0
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("CHopMode=0:\nHysteresis start offset from HEND:\n%000: 1\n %100: 5\n%001: 2\n %101: 6\n%010: 3\n %110: 7\n%011: 4\n %111: 8\nEffective: HEND+HSTRT must be ≤ 15\n\nCHopMode=1:\nThree least-significant bits of the duration of\nthe fast decay phase. The MSB is HDEC0.\nFast decay time is a multiple of system clock\nperiods: NCLK= 32 x (HDEC0+HSTRT)")
    //                                    value: 0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5
                                // if chm = 0
                                property var items: ["1", "2", "3", "4", "5", "6", "7", "8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1|2|3|4|5|6|7|8)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return hstrtsb.value
                                }
                            }

                            Switch2 {
                                id: hstrtonOffSwitch
                                enabled: true
    //                               background.color: "blue"
                                onCheckedChanged: {
                                    if (checked) {
                                        if (hstrtSetSpin.value != window.savedHstrtValue) {
                                            window.savedHstrtValue = hstrtSetSpin.value
                                        }
                                    }
                                    else {
                                        hstrtSetSpin.value = window.savedHstrtValue
                                    }
                                }

                                Binding {
                                    target: hstrtonOffSwitch
                                    property: "down"
                                    value: hstrtSetSpin.value  != window.defHstrtValue
                                }
                            }
                        }

                        RowLayout {// set toff values

                            id: toffcontrol
                            visible: true

                            Label {
                                id: toffdValsetLabel
                                font.bold: true
                                text: "Off t/MFET"
                                property string tofftoolTipText: "TOFF"
                                ToolTip.text: tofftoolTipText
                                ToolTip.visible: tofftoolTipText ? toffa.containsMouse : false
                                MouseArea {
                                    id: toffa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: toffSetSpin
    //                                    hoverEnabled: true
                                enabled: true
                                name: "toff.set"
                                halPin.direction: HalPin.IO

                                from: 0
                                to: 15
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Off time/MOSFET\ndisable\n\nDuration of slow decay phase. If TOFF is 0, the\nMOSFETs are shut off. If TOFF is nonzero, slow decay\ntime is a multiple of system clock periods:\nNCLK= 12 + (32 x TOFF) (Minimum time is 64clocks.)\n0000: Driver disable, all bridges off\n0001: 1 (use with TBL of minimum 24 clocks)\n0010 ... %1111: 2 ... 15")
                                // chm =0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

//                                     onValueModified: {            // remove the focus from this control
//                                         parent.forceActiveFocus()
//                                         parent.focus = true
//                                     }
                                }

                            Switch2 {
                                id: toffonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                                if (toffSetSpin.value != window.savedToffValue) {
                                            window.savedToffValue = toffSetSpin.value
                                                }
                                    }
                                    else {
                                        toffSetSpin.value = window.savedToffValue
                                    }
                                }

                                Binding {
                                    target: toffonOffSwitch
                                    property: "down"
                                    value: toffSetSpin.value  != window.defToffValue
                                }
                            }
                        }
                    }

                    Column {  // third Column (Smarten)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Smarten:")
                        }

                        RowLayout {// set seimin bit

                            id: seimincontrol
                            visible: true

                            Label {
                                id: seiminLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text:"Minimum coolStep curren"
                                property string seimintoolTipText: "SEIMIN"
                                ToolTip.text: seimintoolTipText
                                ToolTip.visible: seimintoolTipText ? seimina.containsMouse : false
                                MouseArea {
                                    id: seimina
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            Switch2 {
                                id: seiminonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: seiminSetPin.value  > 0 ? "1⁄4 CS" : "1⁄2 CS"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Minimum coolStep\ncurrent\n0: 1⁄2 CS current setting\n1: 1⁄4 CS current setting")
                                onCheckedChanged: {
                                    if (checked) {
                                            seiminSetPin.value = 1
                                            seiminonOffSwitch.text = "1⁄4 CS"
                                    }
                                    else {
                                        seiminSetPin.value = 0
                                        seiminonOffSwitch.text = "1⁄2 CS"
                                    }
                                }

                                Binding {
                                    target: seiminonOffSwitch
                                    property: "down"
                                    value: seiminSetPin.value  != window.defSeiminValue
                                }
                            }
                        }

                        RowLayout {// set sedn values

                            id: sedncontrol
                            visible: true

                            Label {
                                id: sednValsetLabel
                                font.bold: true
                                text: "Cur dec spd"
                                property string sedntoolTipText: "SEDN"
                                ToolTip.text: sedntoolTipText
                                ToolTip.visible: sedntoolTipText ? sedna.containsMouse : false
                                MouseArea {
                                    id: sedna
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                 id: sednSetSpin
//                                property double defSedn

                                enabled: true
                                name: "sedn.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Current decrement\nspeed\nNumber of times that the stallGuard2 value must be\nsampled equal to or above the upper threshold for each\ndecrement of the coil current:\n%00: 32\n%01: 8\n%10: 2\n%11: 1")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["32", "8", "2", "1"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(32|6|2|1)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return sednSetSpin.value
                                }
                            }

                            Switch2 {
                                id: sednonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (sednSetSpin.value != window.savedSednValue) {
                                            window.savedSednValue = sednSetSpin.value
                                        }
                                    }
                                    else {
                                        sednSetSpin.value = window.savedSednValue
                                    }
                                }
                                 Binding {
                                     target: sednonOffSwitch
                                     property: "down"
                                     value: sednSetSpin.value  != window.defSednValue
                                 }
                            }

                        }

                        RowLayout {// set semax values

                            id: semaxcontrol
                            visible: true

                            Label {
                                id: semaxValsetLabel
                                font.bold: true
                                text: "Up CS trs offs"
                                property string semaxtoolTipText: "SEMAX"
                                ToolTip.text: semaxtoolTipText
                                ToolTip.visible: semaxtoolTipText ? semaxma.containsMouse : false
                                MouseArea {
                                    id: semaxma
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: semaxSetSpin
//                                property double defSemax

                                enabled: true
                                name: "semax.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to: 15
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Upper coolStep threshold\n as an offset from the lower\nthreshold\n\nIf the stallGuard2 measurement value SG is sampled\nequal to or above (SEMIN+SEMAX+1) x 32 enough times,\nthen the coil current scaling factor is decremented.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

//                                 onValueModified: {            // remove the focus from this control
//                                     parent.forceActiveFocus()
//                                     parent.focus = true
//                                 }

                            }

                            Switch2 {
                                id: semaxonOffSwitch
                                enabled: true

                                onCheckedChanged: {
                                    if (checked) {
                                        if (semaxSetSpin.value != window.savedSemaxValue) {
                                            window.savedSemaxValue = semaxSetSpin.value
                                        }
                                    }
                                    else {
                                        semaxSetSpin.value = window.savedSemaxValue
                                    }
                                }
                                Binding {
                                    target: semaxonOffSwitch
                                    property: "down"
                                    value: semaxSetSpin.value  != window.defSemaxValue
                                }
                            }

                        }

                        RowLayout {// set seup values

                            id: seupcontrol
                            visible: true

                            Label {
                                id: seupValsetLabel
                                font.bold: true
                                text: "Curr incr size"
                                property string seuptoolTipText: "SEUP"
                                ToolTip.text: seuptoolTipText
                                ToolTip.visible: seuptoolTipText ? seupa.containsMouse : false
                                MouseArea {
                                    id: seupa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: seupSetSpin
//                                property double defSeup

                                enabled: true
                                name: "seup.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Current increment size\n\nNumber of current increment steps for each time that\nthe stallGuard2 value SG is sampled below the lower\nthreshold:")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["1", "2", "4", "8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1|2|4|8)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return seupSetSpin.value
                                }
                            }

                            Switch2 {
                                id: seuponOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (seupSetSpin.value != window.savedSeupValue) {
                                            window.savedSeupValue = seupSetSpin.value
                                        }
                                    }
                                    else {
                                        seupSetSpin.value = window.savedSeupValue
                                    }
                                }
                                 Binding {
                                     target: seuponOffSwitch
                                     property: "down"
                                     value: seupSetSpin.value  != window.defSeupValue
                                 }
                            }

                        }

                        RowLayout {// set semin values

                            id: semincontrol
                            visible: true

                                Label {
                                    id: seminValsetLabel
                                    font.bold: true
                                    text: "Lo CS trs offs"
                                    property string semintoolTipText: "SEMIN"
                                    ToolTip.text: semintoolTipText
                                    ToolTip.visible: semintoolTipText ? seminma.containsMouse : false
                                    MouseArea {
                                        id: seminma
                                        anchors.fill: parent
                                        hoverEnabled: true
                                    }
                                }

                            HalSpinBox2 {
                                id: seminSetSpin
//                                property double defSemin

                                enabled: true
                                name: "semin.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to: 15
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Lower coolStep threshold/coolStep disable\n\nIf SEMIN is 0, coolStep is disabled. If SEMIN is nonzero\nand the stallGuard2 value SG falls below SEMIN x 32,\nthe coolStep current scaling factor is increased.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

//                                 onValueModified: {            // remove the focus from this control
//                                     parent.forceActiveFocus()
//                                     parent.focus = true
//                                 }
                            }

                            Switch2 {
                                id: seminonOffSwitch
                                enabled: true

                                onCheckedChanged: {
                                    if (checked) {
                                        if (seminSetSpin.value != window.savedSeminValue) {
                                            window.savedSeminValue = seminSetSpin.value
                                        }
                                    }
                                    else {
                                        seminSetSpin.value = window.savedSeminValue
                                    }
                                }
                                Binding {
                                    target: seminonOffSwitch
                                    property: "down"
                                    value: seminSetSpin.value  != window.defSeminValue
                                }
                            }

                        }
                    }

                    Column { // Forth Column (Sgsconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Sgcsconf:")
                        }

                        RowLayout {// set sfilt bit

                            id: sfiltcontrol
                            visible: true

                            Switch2 {
                                id: sfiltonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: sfiltSetPin.value  > 0 ? "SG2 filter enabled" : "SG2 filter disabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("stallGuard2 filter enable\n\n0: Standard mode, fastest response time.\n1: Filtered mode, updated once for each four fullsteps to\ncompensate for variation in motor construction, highest\naccuracy.")
                                onCheckedChanged: {
                                    if (checked) {
                                            sfiltSetPin.value = 1
                                            sfiltonOffSwitch.text = "SG2 filter enabled"
                                    }
                                    else {
                                        sfiltSetPin.value = 0
                                        sfiltonOffSwitch.text = "SG2 filter disabled"
                                    }
                                }

                                Binding {
                                    target: sfiltonOffSwitch
                                    property: "down"
                                    value: sfiltSetPin.value  != window.defSfiltValue
                                }
                            }
                        }

                        RowLayout {// set sgt values

                            id: sgtcontrol
                            visible: true

                            Label {
                                id: sgtLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "SG2 thres"
                                property string sgttoolTipText: "SGT"
                                ToolTip.text: sgttoolTipText
                                ToolTip.visible: sgttoolTipText ? sgta.containsMouse : false
                                MouseArea {
                                    id: sgta
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: sgtSetSpin
                                enabled: true
                                name: "sgt.set"
                                halPin.direction: HalPin.IO
                                from: -64
                                to: 63
                                ToolTip.delay: 1000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("stallGuard2 threshold value\n\nThe stallGuard2 threshold value controls the optimum\n" +
                                "measurement range for readout. A lower value results in\n" +
                                "a higher sensitivity and requires less torque to indicate\n" +
                                "a stall. The value is a two’s complement signed integer.\n" +
                                "Values below -10 are not recommended.\n" +
                                "Range: -64 to +63")

//                                    onValueModified: {            // remove the focus from this control
//                                        parent.forceActiveFocus()
//                                        parent.focus = true
//                                    }
                                }

                            Switch2 {
                                id: sgtonOffSwitch
                                enabled: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr(" Tuning the stallGuard2 Threshold\n" +
                                "Due to the dependency of the stallGuard2 value SG from motor-specific characteristics and application-\n" +
                                "specific demands on load and velocity the easiest way to tune the stallGuard2 threshold SGT for a\n" +
                                "specific motor type and operating conditions is interactive tuning in the actual application.\n" +
                                "The procedure is:\n" +
                                "1. Operate the motor at a reasonable velocity for your application and monitor SG.\n" +
                                "2. Apply slowly increasing mechanical load to the motor. If the motor stalls before SG reaches\n" +
                                "zero, decrease SGT. If SG reaches zero before the motor stalls, increase SGT. A good SGT\n" +
                                "starting value is zero. SGT is signed, so it can have negative or positive values.\n" +
                                "3. The optimum setting is reached when SG is between 0 and 400 at increasing load shortly\n" +
                                "before the motor stalls, and SG increases by 100 or more without load. SGT in most cases can\n" +
                                "be tuned together with the motion velocity in a way that SG goes to zero when the motor\n" +
                                "stalls and the stall output SG_TST is asserted. This indicates that a step has been lost.")
                                onCheckedChanged: {
                                    if (checked) {
                                        if (sgtSetSpin.value != window.savedSgtValue) {
                                            window.savedSgtValue = sgtSetSpin.value
                                        }
                                    }
                                    else {
                                        sgtSetSpin.value = window.savedSgtValue
                                    }
                                }

                                Binding {
                                    target: sgtonOffSwitch
                                    property: "down"
                                    value: sgtSetSpin.value  != window.defSgtValue
                                }
                            }
                        }

                        RowLayout {// set cs values

                            id: cscontrol
                            visible: true

                            Label {
                                id: csLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Curr scale"
                                property string cstoolTipText: "CS"
                                ToolTip.text: cstoolTipText
                                ToolTip.visible: cstoolTipText ? csa.containsMouse : false
                                MouseArea {
                                    id: csa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: csSetSpin
                                enabled: true
                                name: "cs.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "Current scaling for SPI and step/direction operation.\n%00000 ... %11111: 1/32, 2/32, 3/32, ... 32/32\nThis value is biased by 1 and divided by 32, so the\nrange is 1/32 to 32/32.\nExample: CS=0 is 1/32 current"

                                property var items: ["1/32", "2/32", "3/32", "4/32", "5/32", "6/32", "7/32", "8/32", "9/32",
                                    "10/32", "11/32", "12/32", "13/32", "14/32", "15/32", "16/32", "17/32", "18/32", "19/32",
                                    "20/32", "21/32", "22/32", "23/32", "24/32", "25/32", "26/32", "27/32", "28/32", "29/32",
                                    "30/32", "31/32", "32/32"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1/32|2/32|3/32|4/32|5/32|6/32|7/32|8/32|9/32|10/32|11/32|12/32|13/32|14/32|15/32|16/32
                                        17/32|18/32|19/32|20/32|21/32|22/32|23/32|24/32|25/32|26/32|27/32|28/32|29/32|30/32|31/32|32/32)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return cssb.value
                                }
                            }

                            Switch2 {
                                id: csonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (csSetSpin.value != window.savedCsValue) {

                                            window.savedCsValue = csSetSpin.value
                                        }
                                    }
                                    else {
                                        csSetSpin.value = window.savedCsValue
                                    }
                                }

                                Binding {
                                    target: csonOffSwitch
                                    property: "down"
                                    value: csSetSpin.value != window.defCsValue
                                }
                            }
                        }
                    }

                    Column { // Fith Column (Drvconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Drvconf:")
                        }

                        RowLayout {// set tst bit

                            id: tstcontrol
                            visible: true

                            Switch2 {
                                id: tstonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: tstSetPin.value  > 0 ? "Reserved TEST mode enable" : "Reserved TEST mode disabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("TST\nMust be cleared for normal operation. When set, the\nSG_TST output exposes digital test values, and the\nTEST_ANA output exposes analog test values. Test value\nselection is controlled by SGT1 and SGT0:\nTEST_ANA:\n %00: anatest_2vth,\n%01: anatest_dac_out,\n%10: anatest_vdd_half.\nSG_TST:\n%00: comp_A,\n%01: comp_B,\n%10: CLK,\n%11: on_state_xy")

                                onCheckedChanged: {
                                    if (checked) {
                                            tstSetPin.value = 1
                                            tstonOffSwitch.text = "Reserved TEST mode enabled"
                                    }
                                    else {
                                        tstSetPin.value = 0
                                        tstonOffSwitch.text = "Reserved TEST mode disabled"
                                    }
                                }

                                Binding {
                                    target: tstonOffSwitch
                                    property: "down"
                                    value: tstSetPin.value  != window.defTstValue
                                }
                            }
                        }

                        RowLayout {// set slph values

                            id: slphcontrol
                            visible: true

                            Label {
                                id: slphLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Slope ctrl, high"
                                property string slphtoolTipText: "SLPH"
                                ToolTip.text: slphtoolTipText
                                ToolTip.visible: slphtoolTipText ? slpha.containsMouse : false
                                MouseArea {
                                    id: slpha
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: slphSetSpin
                                enabled: true
                                name: "slph.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to:3
        //                                 font.pixelSize: 30
        //                                 scale: 0.5
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "Slope control, high side\n%00: Minimum\n%01: Minimum temperature compensation mode.\n%10: Medium temperature compensation mode.\n%11: Maximum\nIn temperature compensated mode (tc), the MOSFET gate\ndriver strength is increased if the overtemperature\nwarning temperature is reached. This compensates for\ntemperature dependency of high-side slope control."

//                                     onValueModified: {            // remove the focus from this control
//                                         parent.forceActiveFocus()
//                                         parent.focus = true
//                                     }
                                }

                            Switch2 {
                                id: slphonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (slphSetSpin.value != window.savedSlphValue) {
                                            window.savedSlphValue = slphSetSpin.value
                                        }
                                    }
                                    else {
                                        slphSetSpin.value = window.savedSlphValue
                                    }
                                }

                                Binding {
                                    target: slphonOffSwitch
                                    property: "down"
                                    value: slphSetSpin.value  != window.defSlphValue
                                }
                            }
                        }

                        RowLayout {// set slpl values

                            id: slplcontrol
                            visible: true

                            Label {
                                id: slplLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Slope ctrl, low"
                                property string slpltoolTipText: "SLPL"
                                ToolTip.text: slpltoolTipText
                                ToolTip.visible: slpltoolTipText ? slpla.containsMouse : false
                                MouseArea {
                                    id: slpla
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: slplSetSpin
                                enabled: true
                                name: "slpl.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to:3
        //                                 font.pixelSize: 30
        //                                 scale: 0.5
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "Slope control, low side\n%00: Minimum.\n%01: Minimum.\n%10: Medium.\n%11: Maximum."

//                                     onValueModified: {            // remove the focus from this control
//                                         parent.forceActiveFocus()
//                                         parent.focus = true
//                                     }
                                }

                            Switch2 {
                                id: slplonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (slplSetSpin.value != window.savedSlplValue) {
                                            window.savedSlplValue = slplSetSpin.value
                                        }
                                    }
                                    else {
                                        slplSetSpin.value = window.savedSlplValue
                                    }
                                }

                                Binding {
                                    target: slplonOffSwitch
                                    property: "down"
                                    value: slplSetSpin.value  != window.defSlplValue
                                }
                            }
                        }

                        RowLayout {// set diss2g bit

                            id: diss2gcontrol
                            visible: true

                            Switch2 {
                                id: diss2gonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: diss2gSetPin.value  > 0 ? "Short to GND protection disabled" : "Short to GND protection enabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("DISS2G\n0: Short to GND protection is enabled.\n1: Short to GND protection is disabled.")

                                onCheckedChanged: {
                                    if (checked) {
                                            diss2gSetPin.value = 1
                                            diss2gonOffSwitch.text = "Short to GND protection disabled"
                                    }
                                    else {
                                        diss2gSetPin.value = 0
                                        diss2gonOffSwitch.text = "Short to GND protection rnabled"
                                    }
                                }

                                Binding {
                                    target: diss2gonOffSwitch
                                    property: "down"
                                    value: diss2gSetPin.value != window.defDiss2gValue
                                }
                            }
                        }

                        RowLayout {// set ts2g values

                            id: ts2gcontrol
                            visible: true

                            Label {
                                id: ts2gValsetPreLabel
                                font.bold: true
                                text: "GND short tmr"
                                property string ts2gtoolTipText: "TS2G"
                                ToolTip.text: ts2gtoolTipText
                                ToolTip.visible: ts2gtoolTipText ? ts2ga.containsMouse : false
                                MouseArea {
                                    id: ts2ga
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: ts2gSetSpin
//                                property double defTs2g

                                enabled: true
                                name: "ts2g.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Short to GND\ndetection timer:\n%00: 3.2μs.\n%01: 1.6μs.\n%10: 1.2μs.\n%11: 0.8μs.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["3.2", "1.6", "1.2", "0.8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(3.2|1.6|1.2|0.8)")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return ts2gSetSpin.value
                                }
                            }

                            Label {
                                id: ts2gValsetLabel
                                font.bold: true
                                text: "μs"
                            }

                            Switch2 {
                                id: ts2gonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (ts2gSetSpin.value != window.savedTs2gValue) {
                                            window.savedTs2gValue = ts2gSetSpin.value
                                        }
                                    }
                                    else {
                                        ts2gSetSpin.value = window.savedTs2gValue
                                    }
                                }
                                 Binding {
                                     target: ts2gonOffSwitch
                                     property: "down"
                                     value: ts2gSetSpin.value  != window.defTs2gValue
                                 }
                            }

                        }

                        RowLayout {// set sdoff bit

                            id: sdoffcontrol
                            visible: true

                            Switch2 {
                                id: sdoffonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: sdoffSetPin.value  > 0 ? "STEP/DIR interface disabled" : "STEP/DIR interface enabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("SDOFF\n0: Enable STEP and DIR interface.\n1: Disable STEP and DIR interface. SPI interface is used\nto move motor.")

                                onCheckedChanged: {
                                    if (checked) {
                                            sdoffSetPin.value = 1
                                            sdoffonOffSwitch.text = "STEP/DIR interface disabled"
                                    }
                                    else {
                                        sdoffSetPin.value = 0
                                        sdoffonOffSwitch.text = "STEP/DIR interface enabled"
                                    }
                                }

                                Binding {
                                    target: sdoffonOffSwitch
                                    property: "down"
                                    value: sdoffSetPin.value  != window.defSdoffValue
                                }
                            }
                        }

                        RowLayout {// set vsense bit

                            id: vsensecontrol
                            visible: true

                            Switch2 {
                                id: vsenseonOffSwitch
                                enabled: true
                                // display: AbstractButton.TextBesideIcon
                                text: vsenseSetPin.value  > 0 ? "Sense resistor voltage is 165mV." : "Sense resistor voltage is 305mV."
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("VSENSE\nSense resistor voltage-based current scaling:\n0: Full-scale sense resistor voltage is 305mV.\n1: Full-scale sense resistor voltage is 165mV.\n(Full-scale refers to a current setting of 31 and a DAC\nvalue of 255.)")

                                onCheckedChanged: {
                                    if (checked) {
                                            vsenseSetPin.value = 1
                                            vsenseonOffSwitch.text = "Sense resistor voltage is 165mV."
                                    }
                                    else {
                                        vsenseSetPin.value = 0
                                        vsenseonOffSwitch.text = "Sense resistor voltage is 305mV."
                                    }
                                }

                                Binding {
                                    target: vsenseonOffSwitch
                                    property: "down"
                                    value: vsenseSetPin.value  != window.defVsenseValue
                                }
                            }
                        }

                        RowLayout {// set rdsel values

                            id: rdselcontrol
                            visible: true

                            Label {
                                id: rdselValsetPreLabel
                                font.bold: true
                                text: "RD bits"
                                property string rdseltoolTipText: "RDSEL"
                                ToolTip.text: rdseltoolTipText
                                ToolTip.visible: rdseltoolTipText ? rdsela.containsMouse : false
                                MouseArea {
                                    id: rdsela
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }

                            HalSpinBox2 {
                                id: rdselSetSpin
//                                property double defRdsel

                                enabled: true
                                name: "rdsel.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 2
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Select value for read out (RD bits)\n%00 Microstep position read back\n%01 stallGuard2 level read back\n%10\nstallGuard2 and coolStep current level read back\n%11 Reserved, do not use")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["Microstep position read back", "SG2 level read back", "SG2 and coolStep current level read back", "Na"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(Microstep position read back|SG2 level read back|SG2 and coolStep current level read back|8)|Na")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return rdselSetSpin.value
                                }
                            }

                            Switch2 {
                                id: rdselonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (rdselSetSpin.value != window.savedRdselValue) {
                                            window.savedRdselValue = rdselSetSpin.value
                                        }
                                    }
                                    else {
                                        rdselSetSpin.value = window.savedRdselValue
                                    }
                                }
                                 Binding {
                                     target: rdselonOffSwitch
                                     property: "down"
                                     value: rdselSetSpin.value  != window.defRdselValue
                                 }
                            }

                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }


        Item {
            Layout.fillHeight: true
        }
    }


    ApplicationNotifications {
        id: applicationNotifications
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: Screen.pixelDensity
        messageWidth: parent.width * 0.25
    }
}










