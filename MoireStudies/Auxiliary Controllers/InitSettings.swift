//
//  Settings.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

struct InitSettings: Codable { 
    var renderSetting: RenderSettings = RenderSettings.metal
    var interfaceSetting: UISettings = UISettings.controlScheme1Slider
    var controlFrames: Array<CGRect> { // TODO: use a dedicated class to manage the frames
        get {
            switch self.interfaceSetting {
            case UISettings.controlScheme1Slider, UISettings.controlScheme2Slider:
                return Constants.UI.controlFramesDefault
            case UISettings.controlScheme3Slider:
                return Constants.UI.controlFramesTall
            default:
                return Constants.UI.controlFramesDefault
            }
        }
    }
}

enum UISettings: String, Codable {
    case controlScheme1Slider
    case controlScheme1Gesture
    case controlScheme2Slider
    case controlScheme3Slider
}

enum RenderSettings: String, Codable {
    case coreAnimation
    case metal
}
