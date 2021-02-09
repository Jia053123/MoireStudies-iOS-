//
//  Settings.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation

struct InitSettings: Codable { 
    var renderSetting: RenderSettings = RenderSettings.metal
    var interfaceSetting: UISettings = UISettings.controlScheme1Slider
}

enum UISettings: String, Codable {
    case controlScheme1Slider
    case controlScheme1Gesture
    case controlScheme2Slider
}

enum RenderSettings: String, Codable {
    case coreAnimation
    case metal
}
