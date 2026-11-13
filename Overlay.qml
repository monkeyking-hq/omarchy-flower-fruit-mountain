import QtQuick
import QtQuick.Particles
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Ui

Item {
  id: root

  property var shell: null
  readonly property string home: Quickshell.env("HOME")
  readonly property string backgroundLink: home + "/.local/state/omarchy/current/background"
  property string currentBackground: ""
  readonly property bool active: currentBackground.indexOf("flower-fruit-mountain") !== -1

  // Shared breeze across screens. Heading is Qt particle degrees (0 = right, 90 = down).
  property real windHeading: 18
  property real windSpeed: 16
  property real windGust: 0
  readonly property real windForce: windSpeed + windGust * 64
  readonly property real windSwirl: 70 + windGust * 140

  function wrapHeading(value) {
    var h = value
    while (h < -30) h += 360
    while (h > 330) h -= 360
    if (h > 50 && h < 130)
      h = Math.random() < 0.5 ? 20 : 160
    return h
  }

  function rollWind() {
    var flip = Math.random() < 0.22
    var fromLeft = windHeading > 90
    var nextHeading
    if (flip)
      nextHeading = fromLeft ? (Math.random() * 48 - 8) : (150 + Math.random() * 48)
    else
      nextHeading = wrapHeading(windHeading + (Math.random() * 56 - 28))

    headingAnim.stop()
    headingAnim.to = nextHeading
    headingAnim.duration = 1600 + Math.floor(Math.random() * 2400)
    headingAnim.start()

    speedAnim.stop()
    speedAnim.to = 7 + Math.random() * 24
    speedAnim.duration = 1400 + Math.floor(Math.random() * 1800)
    speedAnim.start()

    if (Math.random() < 0.48) {
      gustAnim.stop()
      gustPeak.to = 0.45 + Math.random() * 0.55
      gustPeak.duration = 260 + Math.floor(Math.random() * 420)
      gustHold.duration = 400 + Math.floor(Math.random() * 1600)
      gustFade.duration = 900 + Math.floor(Math.random() * 1500)
      gustAnim.start()
    }

    windTimer.interval = 2400 + Math.floor(Math.random() * 7800)
  }

  NumberAnimation {
    id: headingAnim
    target: root
    property: "windHeading"
    easing.type: Easing.InOutSine
  }

  NumberAnimation {
    id: speedAnim
    target: root
    property: "windSpeed"
    easing.type: Easing.InOutSine
  }

  SequentialAnimation {
    id: gustAnim
    NumberAnimation {
      id: gustPeak
      target: root
      property: "windGust"
      easing.type: Easing.OutQuad
    }
    PauseAnimation { id: gustHold }
    NumberAnimation {
      id: gustFade
      target: root
      property: "windGust"
      to: 0
      easing.type: Easing.InOutSine
    }
  }

  Timer {
    id: windTimer
    interval: 3500
    running: root.active
    repeat: true
    onTriggered: root.rollWind()
  }

  function refreshBackground() {
    if (!readlinkProc.running)
      readlinkProc.running = true
  }

  Process {
    id: readlinkProc
    command: ["readlink", "-f", root.backgroundLink]
    stdout: StdioCollector {
      onStreamFinished: root.currentBackground = String(text || "").trim()
    }
  }

  Timer {
    interval: 900
    running: true
    repeat: true
    onTriggered: root.refreshBackground()
  }

  Component.onCompleted: {
    root.refreshBackground()
    root.rollWind()
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel
      required property var modelData

      screen: modelData
      visible: !remapGuard.remapping && root.active
      color: "transparent"
      anchors { top: true; bottom: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "flower-fruit-mountain-live"
      WlrLayershell.layer: WlrLayer.Bottom
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}
      updatesEnabled: true

      ScreenMoveRemap {
        id: remapGuard
        window: panel
      }

      // Map the 1600x900 mountain viewBox through the same crop the wallpaper uses.
      Item {
        id: scene
        readonly property real viewW: 1600
        readonly property real viewH: 900
        readonly property real s: Math.max(panel.width / viewW, panel.height / viewH)
        width: viewW
        height: viewH
        x: (panel.width - viewW * s) / 2
        y: (panel.height - viewH * s) / 2
        transform: Scale { xScale: scene.s; yScale: scene.s }
        visible: root.active

        // --- Summit pulse (matches monkeyking.dev summit-pulse 5s) ---
        Item {
          id: summit
          x: 800
          y: 450
          width: 1
          height: 1
          scale: 0.92
          opacity: 0.7

          Repeater {
            model: 3
            Item {
              required property int index
              readonly property real rw: index === 0 ? 440 : index === 1 ? 280 : 130
              readonly property real rh: index === 0 ? 320 : index === 1 ? 200 : 94
              width: rw
              height: rh
              anchors.centerIn: parent

              Rectangle {
                width: parent.rw
                height: parent.rw
                radius: parent.rw / 2
                anchors.centerIn: parent
                color: index === 0 ? "#28f5a524" : index === 1 ? "#40f8d28a" : "#58f8d28a"
                transform: Scale {
                  origin.x: parent.rw / 2
                  origin.y: parent.rw / 2
                  yScale: parent.rh / parent.rw
                }
              }
            }
          }

          SequentialAnimation on opacity {
            running: root.active
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 2500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.55; duration: 2500; easing.type: Easing.InOutSine }
          }
          SequentialAnimation on scale {
            running: root.active
            loops: Animation.Infinite
            NumberAnimation { to: 1.08; duration: 2500; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.92; duration: 2500; easing.type: Easing.InOutSine }
          }
        }

        // Waterfall sits in a cleft on the dark right face and dies in the
        // cloud sea — never a free-standing white bar in front of the peak.
        Item {
          id: fall
          z: 2
          anchors.fill: parent

          Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer
            ShapePath {
              strokeWidth: -1
              fillGradient: LinearGradient {
                x1: 990; y1: 572
                x2: 1020; y2: 742
                GradientStop { position: 0.00; color: "#6ae8e3d8" }
                GradientStop { position: 0.08; color: "#48e8e3d8" }
                GradientStop { position: 0.38; color: "#2ce8e3d8" }
                GradientStop { position: 0.70; color: "#16e8e3d8" }
                GradientStop { position: 1.00; color: "#00e8e3d8" }
              }
              startX: 976; startY: 576
              PathCubic { x: 1006; y: 578; control1X: 984; control1Y: 572; control2X: 996; control2Y: 573 }
              PathCubic { x: 1036; y: 738; control1X: 1020; control1Y: 640; control2X: 1032; control2Y: 700 }
              PathCubic { x: 988; y: 736; control1X: 1020; control1Y: 750; control2X: 1002; control2Y: 750 }
              PathCubic { x: 976; y: 576; control1X: 980; control1Y: 690; control2X: 978; control2Y: 630 }
            }
          }

          Repeater {
            model: 5
            Rectangle {
              required property int index
              width: 1.2 + (index % 2) * 0.5
              height: 28 + index * 5
              radius: 1
              color: "#e8e3d8"
              opacity: 0
              x: 982 + index * 5.0
              y: 584
              SequentialAnimation on y {
                running: root.active
                loops: Animation.Infinite
                PauseAnimation { duration: index * 240 }
                NumberAnimation { from: 584; to: 718; duration: 1300 + index * 80; easing.type: Easing.InQuad }
              }
              SequentialAnimation on opacity {
                running: root.active
                loops: Animation.Infinite
                PauseAnimation { duration: index * 240 }
                NumberAnimation { from: 0; to: 0.22; duration: 240 }
                NumberAnimation { to: 0.08; duration: 640 }
                NumberAnimation { to: 0; duration: 500 + index * 80 }
              }
            }
          }
        }

        ParticleSystem {
          id: particles
          z: 3
          running: root.active
          paused: !root.active
        }

        ImageParticle {
          system: particles
          source: Qt.resolvedUrl("petal.png")
          alpha: 0.88
          autoRotation: true
          colorVariation: 0.18
          rotationVelocity: 36 + root.windGust * 90
          rotationVelocityVariation: 28 + root.windGust * 40
          entryEffect: ImageParticle.Fade
        }

        Wander {
          system: particles
          xVariance: root.windSwirl
          yVariance: 28 + root.windGust * 50
          pace: 55 + root.windGust * 85
          affectedParameter: Wander.Position
        }

        Gravity {
          system: particles
          magnitude: 10
          angle: 90
        }

        Gravity {
          system: particles
          angle: root.windHeading
          magnitude: root.windForce
        }

        Emitter {
          system: particles
          enabled: root.active
          x: -40
          y: -30
          width: 1680
          height: 50
          emitRate: 3.2 * (1 + root.windGust * 0.9)
          lifeSpan: 17000
          lifeSpanVariation: 4000
          size: 16
          sizeVariation: 8
          endSize: 10
          velocity: AngleDirection {
            angle: 90 * 0.62 + root.windHeading * 0.38
            angleVariation: 16 + root.windGust * 14
            magnitude: 32 + root.windForce * 0.22
            magnitudeVariation: 14
          }
        }

        Emitter {
          system: particles
          enabled: root.active
          x: 540
          y: 690
          width: 180
          height: 30
          emitRate: 0.65 * (1 + root.windGust)
          lifeSpan: 12000
          lifeSpanVariation: 2500
          size: 14
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 18 : -18)
            angleVariation: 26
            magnitude: 36 + root.windForce * 0.35
            magnitudeVariation: 16
          }
        }

        Emitter {
          system: particles
          enabled: root.active
          x: 880
          y: 670
          width: 220
          height: 30
          emitRate: 0.65 * (1 + root.windGust)
          lifeSpan: 12000
          lifeSpanVariation: 2500
          size: 14
          sizeVariation: 6
          velocity: AngleDirection {
            angle: root.windHeading + (root.windHeading > 90 ? 12 : -12)
            angleVariation: 22
            magnitude: 34 + root.windForce * 0.35
            magnitudeVariation: 14
          }
        }
      }
    }
  }
}
