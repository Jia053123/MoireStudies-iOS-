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
        static let controlFramesDefault: Array<CGRect> = [CGRect(x: 10, y: 10, width: 150, height: 200),
                                                          CGRect(x: 170, y: 10, width: 150, height: 200)]
        static let controlFramesTall: Array<CGRect> = [CGRect(x: 10, y: 10, width: 150, height: 300),
                                                       CGRect(x: 170, y: 10, width: 150, height: 300)]
    }
    
    struct Bounds {
        static let speedRange: ClosedRange<CGFloat> = 10.0...50.0
        static let directionRange: ClosedRange<CGFloat> = -1*CGFloat.infinity...CGFloat.infinity
        static let blackWidthRange: ClosedRange<CGFloat> = 2.0...50.0
        static let whiteWidthRange: ClosedRange<CGFloat> = 2.0...50.0
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
