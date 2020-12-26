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
            _pattern = newValue
            self.resetView()
        }
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
    
    func resetView() {
        preconditionFailure("this method must be overridden")
    }
}
