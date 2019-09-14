/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQuick.Templates 2.2 as T
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2

T.Switch {
    id: control
    property int themeBaseSize: 10
    property string lightgrayColour: "light green"
    property string darkgrayColour: "gray"
    property string themeLight: "blue"
    property string themeKnob: "white"
    property string themeLightGray: "light gray"
    property string themeGray: "gray"
    property string themeMainColor: "light green"
    property string themeMainColorDarker: "orange"

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 6
    spacing: 6

    indicator: Rectangle {
        id: switchHandle
        implicitWidth: control.themeBaseSize * 4.8
        implicitHeight: control.themeBaseSize * 1.3
        x: control.leftPadding
        anchors.verticalCenter: parent.verticalCenter
        radius: control.themeBaseSize * 1.3
        color: control.lightgrayColour
        border.color: control.darkgrayColour

        Rectangle {
            id: rectangle

            width: control.themeBaseSize * 2.6
            height: control.themeBaseSize * 2.6
            radius: control.themeBaseSize * 1.3
            anchors.verticalCenter: parent.verticalCenter
            color: control.themeKnob
            border.color: control.themeGray
        }

        states: [
            State {
                name: "off"
                when: !control.checked && !control.down
            },
            State {
                name: "on"
                when: control.checked && !control.down

                PropertyChanges {
                    target: switchHandle
                    color: control.themeMainColor
                    border.color: control.themeMainColor
                }

                PropertyChanges {
                    target: rectangle
                    x: parent.width - width

                }
            },
            State {
                name: "off_down"
                when: !control.checked && control.down

                PropertyChanges {
                    target: rectangle
                    color: control.themeLight
                }

            },
            State {
                name: "on_down"
                extend: "off_down"
                when: control.checked && control.down

                PropertyChanges {
                    target: rectangle
                    x: parent.width - width
                    color: control.themeLight
                }

                PropertyChanges {
                    target: switchHandle
                    color: control.themeMainColorDarker
                    border.color: control.themeMainColorDarker
                }
            }
        ]
    }


    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

        text: control.text
        font: control.font
        color: control.enabled ? Default.textDarkColor : Default.textDisabledColor
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
}
