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
    @IBOutlet weak var directionSlider: UISlider!
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
        
        self.directionSlider.minimumValue = -1 * Float.pi
        self.directionSlider.maximumValue = Float.pi
        self.directionSlider.value = 0.0
        
        self.fillSlider.minimumValue = 0.5
        self.fillSlider.maximumValue = 1.5
        self.fillSlider.value = 1.0
        
        self.scaleSlider.minimumValue = -2.0
        self.scaleSlider.maximumValue = 2.0
        self.scaleSlider.value = 0.0
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        self.target.adjustRelativeSpeed(netMultiplier: CGFloat(self.speedSlider.value))
    }
    
    @IBAction func directionChanged(_ sender: Any) {
        self.target.adjustAllDirection(netAdjustment: CGFloat(self.directionSlider.value))
    }
    
    @IBAction func fillChanged(_ sender: Any) {
        self.target.adjustAllFillRatio(netMultiplier: CGFloat(self.fillSlider.value))
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        self.target.adjustAllScale(netAdjustment: CGFloat(self.scaleSlider.value))
    }
    
    func matchControlsWithBounds(speedRange: ClosedRange<CGFloat>?, fillRatioRange: ClosedRange<CGFloat>?, scaleRange: ClosedRange<CGFloat>?) {
        
    }
}

extension SliderHighDegreeCtrlView: HighDegreeCtrlView {
    
}
