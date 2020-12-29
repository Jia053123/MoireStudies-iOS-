//
//  PatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class PatternView : UIView {
    private var _pattern: Pattern?
    var pattern: Pattern {
        get {
            if let p = _pattern {
                return p
            } else {
                return Pattern.defaultPattern()
            }
        }
        set {
            if _pattern != newValue {
                self.patternChanged(from: _pattern, to: newValue)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setUp(pattern: Pattern) {
        preconditionFailure("this method must be overridden")
    }
    
    func patternChanged(from oldPattern: Pattern?, to newPattern: Pattern) {
        preconditionFailure("this method must be overridden")
    }
}
