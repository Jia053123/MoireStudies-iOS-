//
//  SliderControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class SliderControlView : UIView, ControlView {
    var target: PatternControlTarget?
    @IBOutlet weak var speedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var directionSlider: UISlider!
    @IBOutlet weak var fillRatioSlider: UISlider!
    @IBOutlet weak var zoomRatioSlider: UISlider!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    private func setUp() {
        let nib = UINib(nibName: "SliderControlView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        directionSlider.minimumValue = 0.0
        directionSlider.maximumValue = 2 * Float.pi
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(speed: self.calcSpeed(speedSegmentIndex: speedSegmentedControl.selectedSegmentIndex))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func directionChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(direction: Double(directionSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func fillRatioChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(fillRatio: Double(fillRatioSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func zoomRatioChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(zoomRatio: Double(zoomRatioSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    private func calcSpeed(speedSegmentIndex: Int) -> Double {
        return Double((speedSegmentIndex + 1) * 8 + 10)
    }
    
    private func calcSegmentIndex(speed: Double) -> Int {
        switch speed {
        case 0.0...18.0:
            return 0
        case 18.0.nextUp...26.0:
            return 1
        case 26.0.nextUp...Double.infinity:
            return 2
        default:
            return 0
        }
    }
    
    func matchControls(pattern: Pattern) {
        self.speedSegmentedControl.selectedSegmentIndex = self.calcSegmentIndex(speed: pattern.speed)
    }
}
