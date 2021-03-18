//
//  Constants.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

struct Constants {
    struct UI {
        static let maskCornerRadius: CGFloat = 12.0
        static let tileHeight: CGFloat = Constants.Bounds.blackWidthRange.lowerBound + Constants.Bounds.whiteWidthRange.lowerBound // for CoreAnimPatternView only: the less the height, the more the num of strips rendered on screen, the thinner the minimum black/white width
        static private let frameDefaultSize: CGSize = CGSize(width: 150, height: 200)
        static let controlFramesDefault: Array<CGRect> = {() -> Array<CGRect> in
            var frames: Array<CGRect> = []
            for i in 0...(Constants.Bounds.numOfPatternsPerMoire.upperBound - 1) {
                let origin = CGPoint(x: i * Int(frameDefaultSize.width + 15) + 15, y: 15)
                frames.append(CGRect(origin: origin, size: frameDefaultSize))
            }
            return frames
        }()
        
        static private let frameTallSize: CGSize = CGSize(width: 150, height: 300)
        static let controlFramesTall: Array<CGRect> = {() -> Array<CGRect> in
            var frames: Array<CGRect> = []
            for i in 0...(Constants.Bounds.numOfPatternsPerMoire.upperBound - 1) {
                let origin = CGPoint(x: i * Int(frameTallSize.width + 15) + 15, y: 15)
                frames.append(CGRect(origin: origin, size: frameTallSize))
            }
            return frames
        }()
    }
    
    struct Bounds {
        static let speedRange: ClosedRange<CGFloat> = -50.0...50.0
        static let directionRange: ClosedRange<CGFloat> = 0.0...CGFloat.pi*2
        static let blackWidthRange: ClosedRange<CGFloat> = 2.0...100.0
        static let whiteWidthRange: ClosedRange<CGFloat> = 2.0...100.0
        
        static let numOfPatternsPerMoire: ClosedRange<Int> = 1...5
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
}
