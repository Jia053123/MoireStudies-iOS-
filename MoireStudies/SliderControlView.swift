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
    @IBOutlet weak var speed: UISegmentedControl!
    @IBOutlet weak var direction: UISlider!
    @IBOutlet weak var fillRatio: UISlider!
    @IBOutlet weak var zoomRatio: UISlider!
    
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
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        if let t = self.target {
            t.modifyPattern(speed: self.calcSpeed(speedSegmentIndex: speed.selectedSegmentIndex))
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
        self.speed.selectedSegmentIndex = self.calcSegmentIndex(speed: pattern.speed)
    }
}
