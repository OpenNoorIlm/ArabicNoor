

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import Lesson
import QtQuick3D
import QtQuick3D.AssetUtils
import QtQuick3D.Effects
import QtQuick3D.Helpers
import QtQuick3D.Particles3D
import QtQuick3D.Physics
import QtQuick3D.Physics.Helpers
import QtQuick3D.SpatialAudio
import QtQuick3D.Xr

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    color: "#000000"

    Item {
        id: __materialLibrary__

        PrincipledMaterial {
            id: principledMaterial
            lightProbe: color_table
            objectName: "New Material"
        }

        Texture {
            id: color_table
            source: "color_table.png"
            objectName: "Color table"
        }

        PrincipledMaterial {
            id: newMaterial
            baseColor: "#d21212"
            objectName: "New Material"
        }
    }

    View3D {
        id: extendedView3D
        x: 0
        y: 0
        width: 1048
        height: 1848

        Node {
            id: scene
            DirectionalLight {
                id: directionalLight
                brightness: 0
            }

            Model {
                id: cone
                x: 2.734
                y: 37.029
                source: "#Cone"
                z: 0
                materials: principledMaterial
            }

            Model {
                id: sphere
                y: -10
                source: "#Sphere"
                materials: principledMaterial

                CharacterController {
                    id: characterController
                    receiveContactReports: true
                    sendContactReports: true
                    receiveTriggerReports: true
                    sendTriggerReports: true
                }

                WasdController {
                    id: wasdController
                    layer.enabled: true
                }

                OrbitCameraController {
                    id: orbitCameraController
                    layer.enabled: true
                }
            }

            ParticleSystem3D {
                id: fire
                x: -7.878
                y: -83.587
                z: 241.3093
                paused: false
                logging: true
                time: 100
                ParticleEmitter3D {
                    id: smokeEmitter
                    velocity: smokeDirection
                    particleScaleVariation: 4
                    particleScale: 1
                    particleEndScale: 25
                    particle: smokeParticle
                    lifeSpanVariation: 750
                    lifeSpan: 1500
                    emitRate: 20
                    VectorDirection3D {
                        id: smokeDirection
                        directionVariation.z: 10
                        directionVariation.y: 10
                        directionVariation.x: 10
                        direction.y: 75
                    }

                    SpriteParticle3D {
                        id: smokeParticle
                        color: "#ffffff"
                        spriteSequence: sequence
                        sprite: smokeTexture
                        sortMode: Particle3D.SortNewest
                        particleScale: 5
                        maxAmount: 400
                        fadeOutDuration: 1250
                        fadeInDuration: 3500
                        Texture {
                            id: smokeTexture
                            source: "smoke_sprite.png"
                        }

                        SpriteSequence3D {
                            id: sequence
                            frameCount: 15
                            duration: 6000
                        }
                        blendMode: SpriteParticle3D.SourceOver
                        billboard: true
                    }
                }

                ParticleEmitter3D {
                    id: sparkEmitter
                    velocity: sparkDirection
                    particleScaleVariation: 1
                    particle: sparkParticle
                    lifeSpanVariation: 600
                    lifeSpan: 800
                    emitRate: 10
                    depthBias: -100
                    VectorDirection3D {
                        id: sparkDirection
                        directionVariation.z: 25
                        directionVariation.y: 10
                        directionVariation.x: 25
                        direction.y: 60
                    }

                    SpriteParticle3D {
                        id: sparkParticle
                        color: "#ffffff"
                        sprite: sphereTexture
                        sortMode: Particle3D.SortNewest
                        particleScale: 1
                        maxAmount: 100
                        fadeOutEffect: Particle3D.FadeScale
                        Texture {
                            id: sphereTexture
                            source: "sphere.png"
                        }

                        Texture {
                            id: colorTable
                            source: "colorTable.png"
                        }
                        colorTable: colorTable
                        blendMode: SpriteParticle3D.Screen
                        billboard: true
                    }
                }

                ParticleEmitter3D {
                    id: fireEmitter
                    velocity: fireDirection
                    particleScaleVariation: 2
                    particleScale: 3
                    particle: fireParticle
                    lifeSpanVariation: 100
                    lifeSpan: 750
                    emitRate: 90
                    depthBias: -100
                    VectorDirection3D {
                        id: fireDirection
                        directionVariation.z: 10
                        directionVariation.x: 10
                        direction.y: 75
                    }

                    SpriteParticle3D {
                        id: fireParticle
                        color: "#ffffff"
                        sprite: sphereTexture
                        sortMode: Particle3D.SortNewest
                        maxAmount: 500
                        fadeOutEffect: Particle3D.FadeOpacity
                        fadeInEffect: Particle3D.FadeScale
                        Texture {
                            id: colorTable2
                            source: "color_table2.png"
                        }
                        colorTable: colorTable2
                        blendMode: SpriteParticle3D.Screen
                        billboard: true
                    }
                }

                Gravity3D {
                    id: sparkGravity
                    particles: sparkParticle
                    magnitude: 100
                    enabled: true
                }
            }

            ParticleSystem3D {
                id: cloudSystem
                x: -0
                y: 147.223
                z: 0
                ParticleEmitter3D {
                    id: baseCloudEmitter
                    velocity: cloudDirection
                    shape: cloudShape
                    particleScaleVariation: 10
                    particleScale: 35
                    particle: cloudParticle
                    lifeSpan: 200000
                    emitRate: 0
                    emitBursts: cloudBaseBurst
                    depthBias: -20
                    SpriteParticle3D {
                        id: cloudParticle
                        color: "#bcffffff"
                        spriteSequence: cloudSequence
                        sprite: cloudTexture
                        sortMode: Particle3D.SortNewest
                        particleScale: 12
                        maxAmount: 50
                        fadeOutDuration: 0
                        fadeInEffect: Particle3D.FadeScale
                        fadeInDuration: 0
                        Texture {
                            id: cloudTexture
                            source: "smoke_sprite2.png"
                        }

                        SpriteSequence3D {
                            id: cloudSequence
                            randomStart: true
                            interpolate: true
                            frameCount: 15
                            durationVariation: 3000
                            duration: 50000
                            animationDirection: SpriteSequence3D.Alternate
                        }
                        blendMode: SpriteParticle3D.SourceOver
                        billboard: true
                    }

                    ParticleShape3D {
                        id: cloudShape
                        type: ParticleShape3D.Sphere
                        fill: false
                        extents.z: 250
                        extents.y: 100
                        extents.x: 250
                    }

                    EmitBurst3D {
                        id: cloudBaseBurst
                        amount: 10
                    }
                }

                ParticleEmitter3D {
                    id: smallCloudEmitter
                    velocity: cloudDirection
                    shape: cloudOuterShape
                    particleScaleVariation: 7
                    particleScale: 18
                    particle: cloudSmallParticle
                    lifeSpan: 2000000
                    emitRate: 0
                    emitBursts: cloudSmallBurst
                    depthBias: -25
                    SpriteParticle3D {
                        id: cloudSmallParticle
                        color: "#65ffffff"
                        spriteSequence: cloudSequence
                        sprite: cloudTexture
                        sortMode: Particle3D.SortNewest
                        particleScale: 12
                        maxAmount: 75
                        fadeOutDuration: 0
                        fadeInEffect: Particle3D.FadeScale
                        fadeInDuration: 0
                        blendMode: SpriteParticle3D.SourceOver
                        billboard: true
                    }

                    ParticleShape3D {
                        id: cloudOuterShape
                        type: ParticleShape3D.Sphere
                        fill: true
                        extents.z: 350
                        extents.y: 150
                        extents.x: 350
                    }

                    EmitBurst3D {
                        id: cloudSmallBurst
                        amount: 15
                    }
                }

                VectorDirection3D {
                    id: cloudDirection
                    direction.z: -20
                    direction.y: 0
                }

                Wander3D {
                    id: cloudWander
                    uniquePace.z: 0.01
                    uniquePace.y: 0.01
                    uniquePace.x: 0.01
                    uniqueAmountVariation: 0.3
                    uniqueAmount.z: 15
                    uniqueAmount.y: 15
                    uniqueAmount.x: 15
                    system: cloudSystem
                    particles: [cloudParticle, cloudSmallParticle, smallCloudEmitter]
                }
            }

            ParticleSystem3D {
                id: heavyRain
                x: 3.522
                y: 94.751
                z: -164.40427
                ParticleEmitter3D {
                    id: heavyRainEmitter
                    velocity: heavyRainDirection
                    shape: heavyRainShape
                    particleScaleVariation: 0.25
                    particleScale: 0.75
                    particle: heavyRainParticle
                    lifeSpan: 500
                    emitRate: 50
                    depthBias: -200
                    VectorDirection3D {
                        id: heavyRainDirection
                        direction.y: -(heavyRain.y * 2)
                    }

                    SpriteParticle3D {
                        id: heavyRainParticle
                        color: "#73e6f4ff"
                        spriteSequence: heavyRainSequence
                        sprite: heavyRainTexture
                        sortMode: Particle3D.SortDistance
                        particleScale: 100
                        offsetY: heavyRainParticle.particleScale / 2
                        maxAmount: 100
                        fadeOutEffect: Particle3D.FadeOpacity
                        fadeOutDuration: 10
                        fadeInDuration: 0
                        Texture {
                            id: heavyRainTexture
                            source: "rain.png"
                        }

                        SpriteSequence3D {
                            id: heavyRainSequence
                            randomStart: true
                            interpolate: true
                            frameCount: 3
                            duration: 15
                            animationDirection: SpriteSequence3D.Normal
                        }
                        billboard: true
                    }
                }

                ParticleShape3D {
                    id: heavyRainShape
                    type: ParticleShape3D.Cube
                    fill: true
                    extents.z: 500
                    extents.y: 0.01
                    extents.x: 500
                }

                TrailEmitter3D {
                    id: heavyRainDropletEmitter
                    velocity: heavyRainDropletDirection
                    particleScaleVariation: 0.2
                    particle: heavyRainDropletParticle
                    lifeSpan: 500
                    follow: heavyRainParticle
                    emitRate: 0
                    emitBursts: heavyRainDropletBurst
                    depthBias: -8
                    SpriteParticle3D {
                        id: heavyRainDropletParticle
                        color: "#5ea6e2ff"
                        sprite: heavyRainDropletTexture
                        sortMode: Particle3D.SortDistance
                        particleScale: 3
                        maxAmount: 300
                        fadeOutEffect: Particle3D.FadeScale
                        fadeOutDuration: 200
                        fadeInEffect: Particle3D.FadeScale
                        fadeInDuration: 100
                        Texture {
                            id: heavyRainDropletTexture
                            source: "blurred_sphere.png"
                        }
                        billboard: true
                    }

                    EmitBurst3D {
                        id: heavyRainDropletBurst
                        time: heavyRainEmitter.lifeSpan
                        duration: 0
                        amount: 1
                    }

                    VectorDirection3D {
                        id: heavyRainDropletDirection
                        directionVariation.z: 150
                        directionVariation.y: 100
                        directionVariation.x: 150
                        direction.z: 0
                        direction.y: 120
                        direction.x: 0
                    }
                }

                Gravity3D {
                    id: heavyRainDropletGravity
                    particles: heavyRainDropletParticle
                    magnitude: 800
                }

                TrailEmitter3D {
                    id: heavyRainPoolEmitter
                    particleScale: 25
                    particleRotation.x: -90
                    particle: heavyRainPoolParticle
                    lifeSpan: 800
                    follow: heavyRainParticle
                    emitRate: 0
                    emitBursts: heavyRainPoolBurst
                    depthBias: -10
                    SpriteParticle3D {
                        id: heavyRainPoolParticle
                        color: "#11ecf9ff"
                        sprite: heavyRainPoolTexture
                        maxAmount: 300
                        fadeOutEffect: Particle3D.FadeOpacity
                        fadeOutDuration: 800
                        fadeInEffect: Particle3D.FadeScale
                        fadeInDuration: 150
                        Texture {
                            id: heavyRainPoolTexture
                            source: "ripple.png"
                        }
                    }

                    EmitBurst3D {
                        id: heavyRainPoolBurst
                        time: heavyRainEmitter.lifeSpan
                        duration: 0
                        amount: 1
                    }
                }

                TrailEmitter3D {
                    id: heavyRainSplashEmitter
                    particleScaleVariation: 15
                    particleScale: 15
                    particleRotation.x: 0
                    particle: heavyRainSplashParticle
                    lifeSpan: 800
                    follow: heavyRainParticle
                    emitRate: 0
                    emitBursts: heavyRainSplashBurst
                    depthBias: -10
                    SpriteParticle3D {
                        id: heavyRainSplashParticle
                        color: "#94c0e7fb"
                        spriteSequence: heavyRainSplashSequence
                        sprite: heavyRainSplashTexture
                        sortMode: Particle3D.SortDistance
                        maxAmount: 1500
                        fadeOutEffect: Particle3D.FadeOpacity
                        fadeOutDuration: 800
                        fadeInEffect: Particle3D.FadeScale
                        fadeInDuration: 450
                        Texture {
                            id: heavyRainSplashTexture
                            source: "splash7.png"
                        }

                        SpriteSequence3D {
                            id: heavyRainSplashSequence
                            frameCount: 6
                            duration: 800
                        }
                        billboard: true
                    }

                    EmitBurst3D {
                        id: heavyRainSplashBurst
                        time: heavyRainEmitter.lifeSpan
                        duration: 0
                        amount: 1
                    }
                }
            }

            PerspectiveCamera {
                id: perspectiveCamera
                z: 500
            }
        }

        SceneEnvironment {
            id: sceneEnvironment
            antialiasingQuality: SceneEnvironment.High
            antialiasingMode: SceneEnvironment.MSAA
        }
    }
}

/*##^##
Designer {
    D{i:0}D{i:6;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}D{i:64;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}
}
##^##*/

