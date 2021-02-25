//
//  SliderCtrlViewSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

class SliderCtrlViewSch3: UIView {
    weak var target: CtrlViewControllerSch3?
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var directionSlider: UISlider!
    @IBOutlet weak var blackWidthSlider: UISlider!
    @IBOutlet weak var whiteWidthSlider: UISlider!
    @IBOutlet weak var fillRatioSlider: UISlider!
    @IBOutlet weak var scaleFactorSlider: UISlider!
    @IBOutlet weak var highlightButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    private func setUp() {
        let nib = UINib(nibName: "SliderCtrlViewSch3", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        speedSlider.minimumValue = Float(Constants.Bounds.speedRange.lowerBound)
        speedSlider.maximumValue = 45.0
        directionSlider.minimumValue = 0.0
        directionSlider.maximumValue = 2 * Float.pi
        blackWidthSlider.minimumValue = Float(Constants.UI.tileHeight / 2)
        blackWidthSlider.maximumValue = 20.0
        whiteWidthSlider.minimumValue = Float(Constants.UI.tileHeight / 2)
        whiteWidthSlider.maximumValue = 20.0
        fillRatioSlider.minimumValue = 0.1
        fillRatioSlider.maximumValue = 0.9
        scaleFactorSlider.minimumValue = 1.0
        scaleFactorSlider.maximumValue = 5.0
    }
}

extension SliderCtrlViewSch3: ControlViewSch3 {
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, blackWidth: CGFloat, whiteWidth: CGFloat, fillRatio: CGFloat, scaleFactor: CGFloat) {
        self.speedSlider.value = Float(speed)
        self.directionSlider.value = Float(direction)
        self.blackWidthSlider.value = Float(blackWidth)
        self.whiteWidthSlider.value = Float(whiteWidth)
        self.fillRatioSlider.value = Float(fillRatio)
        self.scaleFactorSlider.value = Float(scaleFactor)
    }
}


