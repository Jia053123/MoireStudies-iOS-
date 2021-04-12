//
//  Settings.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

struct Configurations: Codable, Equatable {
    var renderSetting: RenderSetting = RenderSetting.metal
    var ctrlSchemeSetting: CtrlSchemeSetting = CtrlSchemeSetting.controlScheme3Slider
    var controlFrames: Array<CGRect> { // TODO: use a dedicated class to manage the frames
        get {
            switch self.ctrlSchemeSetting {
            case CtrlSchemeSetting.controlScheme1Slider, CtrlSchemeSetting.controlScheme2Slider:
                return Constants.UI.controlFramesDefault
            case CtrlSchemeSetting.controlScheme3Slider:
                return Constants.UI.controlFramesTall
            default:
                return Constants.UI.controlFramesDefault
            }
        }
    }
    var highDegreeControlCount: Int {get {return self.highDegreeControlSettings.count}}
    var highDegreeControlSettings: Array<HighDegreeControlSettings> = []
}

struct HighDegreeControlSettings: Codable, Equatable {
    var highDegCtrlSchemeSetting: HighDegCtrlSchemeSetting = .basicScheme
    var indexesOfPatternControlled: Set<Int>
}

enum CtrlSchemeSetting: String, Codable {
    case controlScheme1Slider
    case controlScheme1Gesture
    case controlScheme2Slider
    case controlScheme3Slider
}

enum HighDegCtrlSchemeSetting: String, Codable {
    case basicScheme
}

enum RenderSetting: String, Codable {
    case coreAnimation
    case metal
}
