//
//  Constants.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

struct Constants {
    struct Text {
        static let highDegreeControlCreationInstruction = "Creating a new batch control panel: Please select the patterns to be edited together"
    }
    struct UI {
        static let maskCornerRadius: CGFloat = 8.0
        static let tileHeight: CGFloat = BoundsManager.blackWidthRange.lowerBound + BoundsManager.whiteWidthRange.lowerBound /// For CoreAnimPatternView only: the less the height, the more the num of strips rendered on screen, the thinner the minimum black/white width
        
        static private let controlFramesTopMargin: CGFloat = {
#if targetEnvironment(macCatalyst)
return 45.0
#else
return 15.0
#endif
        }()
        static private let frameDefaultSize: CGSize = CGSize(width: 150, height: 200)
        static let controlFramesDefault: Array<CGRect> = {() -> Array<CGRect> in
            var frames: Array<CGRect> = []
            for i in 0...(Constants.Constrains.numOfPatternsPerMoire.upperBound - 1) {
                let origin = CGPoint(x: CGFloat(i * Int(frameDefaultSize.width + 15)) + 15, y: controlFramesTopMargin)
                frames.append(CGRect(origin: origin, size: frameDefaultSize))
            }
            return frames
        }()
        
        static private let frameTallSize: CGSize = CGSize(width: 150, height: 300)
        static let controlFramesTall: Array<CGRect> = {() -> Array<CGRect> in
            var frames: Array<CGRect> = []
            for i in 0..<Constants.Constrains.numOfPatternsPerMoire.upperBound {
                let origin = CGPoint(x: CGFloat(i * Int(frameTallSize.width + 15) + 15), y: controlFramesTopMargin)
                frames.append(CGRect(origin: origin, size: frameTallSize))
            }
            return frames
        }()
        
        static let highDegreeControlFrames: Array<CGRect> = {() -> Array<CGRect> in
            let frameSize = CGSize.init(width: 150, height: 300)
            var frames: Array<CGRect> = []
            for i in 0..<Constants.Constrains.maxNumOfHighDegreeControl {
                let origin = CGPoint(x: CGFloat(i * Int(frameSize.width + 15) + 15), y: controlFramesTopMargin + frameTallSize.height + 15)
                frames.append(CGRect(origin: origin, size: frameSize))
            }
            return frames
        }()
    }
    
    struct Constrains {
        static let numOfPatternsPerMoire: ClosedRange<Int> = 1...5
        static let maxNumOfHighDegreeControl: Int = 6
    }
    
    struct Data {
        static var previewImageSize: CGSize {
            get {
                let minDim = 500.0
                let aspectRatio: Double = Double(UIScreen.main.bounds.width / UIScreen.main.bounds.height)
                if aspectRatio > 1 {
                    return CGSize.init(width: minDim * aspectRatio, height: minDim)
                } else {
                    return CGSize.init(width: minDim, height: minDim / aspectRatio)
                }
            }
        }
    }
    
    struct SettingsClassesDictionary {
        static let highDegControllerClasses: Dictionary<HighDegCtrlSchemeSetting, HighDegCtrlViewController.Type> = [
            .testScheme: MockHighDegCtrlViewController.self,
            .basicScheme: HighDegCtrlViewControllerBatchEditing.self
        ]
    }
}
