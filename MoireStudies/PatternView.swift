//
//  PatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class PatternView : UIView, PatternControlTarget{
    
    func modifyPattern(speed: Double) -> Bool {
        return false
    }
    
    func modifyPattern(direction: Double) -> Bool {
        return false
    }
    
    func modifyPattern(fillRatio: Double) -> Bool {
        return false
    }
    
    func modifyPattern(zoomRatio: Double) -> Bool {
        return false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUp() {
        preconditionFailure("this method must be overridden")
    }
}
