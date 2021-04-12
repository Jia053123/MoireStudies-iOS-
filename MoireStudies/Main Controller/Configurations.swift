//
//  Settings.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

struct Configurations: Codable, Equatable {
    var renderSetting: RenderSettings = RenderSettings.metal
    var ctrlSchemeSetting: CtrlSchemeSettings = CtrlSchemeSettings.controlScheme3Slider
    var controlFrames: Array<CGRect> { // TODO: use a dedicated class to manage the frames
        get {
            switch self.ctrlSchemeSetting {
            case CtrlSchemeSettings.controlScheme1Slider, CtrlSchemeSettings.controlScheme2Slider:
                return Constants.UI.controlFramesDefault
            case CtrlSchemeSettings.controlScheme3Slider:
                return Constants.UI.controlFramesTall
            default:
                return Constants.UI.controlFramesDefault
            }
        }
    }
}

enum CtrlSchemeSettings: String, Codable {
    case controlScheme1Slider
    case controlScheme1Gesture
    case controlScheme2Slider
    case controlScheme3Slider
}

enum RenderSettings: String, Codable {
    case coreAnimation
    case metal
}
