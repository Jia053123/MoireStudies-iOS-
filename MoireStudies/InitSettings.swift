//
//  Settings.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation

struct InitSettings {
    var renderSetting: RenderSettings = RenderSettings.coreAnimation
    var interfaceSetting: UISettings = UISettings.controlScheme1Slider
    var resetMoire: Bool = false
}

enum RenderSettings {
    case coreAnimation
    case OpenGL
}

enum UISettings {
    case controlScheme1Slider
    case controlScheme1Gesture
    case controlScheme2Slider
}
