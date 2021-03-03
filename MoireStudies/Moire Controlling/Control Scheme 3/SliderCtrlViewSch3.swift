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
    @IBOutlet weak var directionSlider: UISlider! // TODO: subclass to allow finer control
    @IBOutlet weak var blackWidthSlider: UISlider!
    @IBOutlet weak var whiteWidthSlider: UISlider!
    @IBOutlet weak var fillRatioSlider: UISlider!
    @IBOutlet weak var scaleFactorSlider: UISlider!
    @IBOutlet weak var highlightButton: UIButton!
    @IBOutlet weak var dimButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
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
        scaleFactorSlider.maximumValue = 10.0
        
        let delete = UIAction(title: "Delete Layer", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.destructive, state: UIMenuElement.State.off, handler: {_ in self.deletePattern()})
        let duplicate = UIAction(title: "Duplicate Layer", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: UIMenuElement.State.off, handler: {_ in self.duplicatePattern()})
        let patternMenu = UIMenu(title: "Pattern Options", image: nil, identifier: nil, options: [], children: [duplicate, delete])
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = patternMenu
    }
    
    @IBAction func startEditing(_ sender: Any) {
        self.target?.highlightPattern()
    }
    
    @IBAction func finishedEditing(_ sender: Any) {
        self.target?.unhighlightPattern()
    }
    
    @IBAction func speedChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(speed: CGFloat(speedSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func directionChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(direction: CGFloat(directionSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func blackWidthChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(blackWidth: CGFloat(blackWidthSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func whiteWidthChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(whiteWidth: CGFloat(whiteWidthSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func fillRatioChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(fillRatio: CGFloat(fillRatioSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func scaleFactorChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(scaleFactor: CGFloat(scaleFactorSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func highlightButtonHeld(_ sender: Any) {
        self.target?.highlightPattern()
    }
    
    @IBAction func highlightButtonReleased(_ sender: Any) {
        self.target?.unhighlightPattern()
    }
    
    @IBAction func dimButtonHeld(_ sender: Any) {
        self.target?.dimPattern()
    }
    
    @IBAction func dimButtonReleased(_ sender: Any) {
        self.target?.undimPattern()
    }
}

extension SliderCtrlViewSch3 {
    @objc func deletePattern() {
        self.target?.deletePattern()
    }
    
    @objc func duplicatePattern() {
        self.target?.duplicatePattern()
    }
}

extension SliderCtrlViewSch3: ControlViewSch3 {
    func matchControlsWithValues(speed: CGFloat?, direction: CGFloat?, blackWidth: CGFloat?, whiteWidth: CGFloat?, fillRatio: CGFloat?, scaleFactor: CGFloat?) {
        if let s = speed {
            self.speedSlider.value = Float(s)
        }
        if let d = direction {
            self.directionSlider.value = Float(d)
        }
        if let b = blackWidth {
            self.blackWidthSlider.value = Float(b)
        }
        if let w = whiteWidth {
            self.whiteWidthSlider.value = Float(w)
        }
        if let f = fillRatio {
            self.fillRatioSlider.value = Float(f)
        }
        if let s = scaleFactor {
            self.scaleFactorSlider.value = Float(s)
        }
    }
}


