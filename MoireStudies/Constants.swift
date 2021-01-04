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
        static let tileHeight: CGFloat = 8.0 // the less the height, the more the num of strips rendered on screen
        static let defaultControlFrames: Array<CGRect> = [CGRect(x: 10, y: 10, width: 150, height: 200),
                                                          CGRect(x: 170, y: 10, width: 150, height: 200)]
    }
    
    struct Bounds {
        static let speedRange: ClosedRange<CGFloat> = 10.0...50.0
        static let directionRange: ClosedRange<CGFloat> = -1*CGFloat.infinity...CGFloat.infinity
        static let fillRatioRange: ClosedRange<CGFloat> = 0.05...0.95
        static let zoomRatioRange: ClosedRange<CGFloat> = 1.0...20.0
    }
}
