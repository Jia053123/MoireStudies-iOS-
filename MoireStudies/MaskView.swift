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
    private var maskFrame: CGRect
    private var cornerRadius: CGFloat = Constants.UI.maskCornerRadius
    
    init(frame: CGRect, maskFrame: CGRect) {
        self.maskFrame = maskFrame
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        self.maskFrame = CGRect.zero
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.yellow.setFill()
        let mask: UIBezierPath = UIBezierPath.init(rect: self.bounds)
        mask.append(UIBezierPath.init(roundedRect: maskFrame, cornerRadius: cornerRadius))
        mask.usesEvenOddFillRule = true
        mask.fill()
    }
}
