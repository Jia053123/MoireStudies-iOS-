//
//  SliderHighDegreeCtrlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-03.
//

import Foundation
import UIKit

class SliderHighDegreeCtrlView: UIView {
    var target: HighDegCtrlViewControllerBatchEditing!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var convergenceSlider: UISlider!
    @IBOutlet weak var fillSlider: UISlider!
    @IBOutlet weak var scaleSlider: UISlider!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    private func setUp() {
        let nib = UINib(nibName: "SliderHighDegreeCtrlView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        
        self.speedSlider.minimumValue = 0.5
        self.speedSlider.maximumValue = 1.5
        self.speedSlider.value = 1.0
        
        self.convergenceSlider.minimumValue = 0.1
        self.convergenceSlider.maximumValue = 2.0
        self.convergenceSlider.value = 1.0
        
        self.fillSlider.minimumValue = 0.5
        self.fillSlider.maximumValue = 1.5
        self.fillSlider.value = 1.0
        
        self.scaleSlider.minimumValue = -2.0
        self.scaleSlider.maximumValue = 2.0
        self.scaleSlider.value = 0.0
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        self.target.matchControlsWithUpdatedModel()
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        self.target.modifyAllSpeed(netMultiplier: CGFloat(self.speedSlider.value))
    }
    
    @IBAction func convergenceChanged(_ sender: Any) {
        self.target.modifyAllDirection(convergenceFactor: CGFloat(self.convergenceSlider.value))
    }
    
    @IBAction func fillChanged(_ sender: Any) {
        self.target.modifyAllFillRatio(netMultiplier: CGFloat(self.fillSlider.value))
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        self.target.modifyAllScale(netAdjustment: CGFloat(self.scaleSlider.value))
    }
    
    func resetSpeedControl(range: ClosedRange<CGFloat>, value: CGFloat?) {
        self.speedSlider.minimumValue = Float(range.lowerBound)
        self.speedSlider.maximumValue = Float(range.upperBound)
        if let v = value {
            self.speedSlider.value = Float(v)
        }
    }

    func resetConvergenceControl(range: ClosedRange<CGFloat>, value: CGFloat?) {
        self.convergenceSlider.minimumValue = Float(range.lowerBound)
        self.convergenceSlider.maximumValue = Float(range.upperBound)
        if let v = value {
            self.convergenceSlider.value = Float(v)
        }
    }

    func resetFillRatioControl(range: ClosedRange<CGFloat>, value: CGFloat?) {
        self.fillSlider.minimumValue = Float(range.lowerBound)
        self.fillSlider.maximumValue = Float(range.upperBound)
        if let v = value {
            self.fillSlider.value = Float(v)
        }
    }

    func resetScaleFactorControl(range: ClosedRange<CGFloat>, value: CGFloat?) {
        self.scaleSlider.minimumValue = Float(range.lowerBound)
        self.scaleSlider.maximumValue = Float(range.upperBound)
        if let v = value {
            self.scaleSlider.value = Float(v)
        }
    }
}

extension SliderHighDegreeCtrlView: HighDegreeCtrlView {
    
}
