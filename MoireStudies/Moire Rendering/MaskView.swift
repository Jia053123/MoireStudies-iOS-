//
//  MaskView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-01.
//

import Foundation
import UIKit
import QuartzCore

class MaskView: UIView {
    private var maskFrames: Array<CGRect>
    private var cornerRadius: CGFloat = Constants.UI.maskCornerRadius
    
    init(frame: CGRect, maskFrames: Array<CGRect>) {
        self.maskFrames = maskFrames
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        self.maskFrames = []
        super.init(coder: coder)
        self.setUp()
    }
    
    func setUp() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.yellow.setFill()
        let mask: UIBezierPath = UIBezierPath.init(rect: self.bounds)
        for frame in self.maskFrames {
            mask.append(UIBezierPath.init(roundedRect: frame, cornerRadius: cornerRadius))
        }
        mask.usesEvenOddFillRule = true
        mask.fill()
    }
}
