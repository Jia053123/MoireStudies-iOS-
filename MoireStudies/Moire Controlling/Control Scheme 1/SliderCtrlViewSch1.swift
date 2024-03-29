//
//  SliderControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class SliderCtrlViewSch1 : UIView { // TODO: make the outlets private
    weak var target: AbstractCtrlViewController?
    @IBOutlet weak var speedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var directionSlider: UISlider!
    @IBOutlet weak var fillRatioSlider: UISlider!
    @IBOutlet weak var scaleFactorSlider: UISlider!
    @IBOutlet weak var checkButton: UIButton!
    
    private var _isSelected: Bool = false
    var isSelected: Bool {
        get {return self._isSelected}
        set {
            if newValue {
                var selectedIcon = UIImage.init(systemName: "checkmark.circle.fill")
                selectedIcon = selectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
                selectedIcon = selectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
                self.checkButton.setImage(selectedIcon, for: UIControl.State.normal)
            } else {
                var unselectedIcon = UIImage.init(systemName: "checkmark.circle")
                unselectedIcon = unselectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
                unselectedIcon = unselectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .black))
                self.checkButton.setImage(unselectedIcon, for: UIControl.State.normal)
            }
            self._isSelected = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    private func setUp() {
        let nib = UINib(nibName: "SliderCtrlViewSch1", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        directionSlider.minimumValue = 0.0
        directionSlider.maximumValue = 2 * Float.pi
        fillRatioSlider.minimumValue = 0.1
        fillRatioSlider.maximumValue = 0.9
        scaleFactorSlider.minimumValue = 1.0
        scaleFactorSlider.maximumValue = 10.0
        let attri = [NSAttributedString.Key.foregroundColor: UIColor.white]
        speedSegmentedControl.setTitleTextAttributes(attri, for: UIControl.State.normal)
    }
    
    @IBAction func patternEditing(_ sender: Any) {
        self.target?.highlightPattern()
    }
    
    @IBAction func patternEdited(_ sender: Any) {
        self.target?.unhighlightPattern()
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
            _ = t.modifyPattern(direction: CGFloat(directionSlider.value))
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
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        self.isSelected = !self.isSelected
    }
    
    private func calcSpeed(speedSegmentIndex: Int) -> CGFloat { // TODO: move to controller? 
        return (CGFloat(speedSegmentIndex) + 1.0) * 8.0 + 10.0
    }
    
    private func calcSegmentIndex(speed: CGFloat) -> Int {
        switch speed {
        case 0.0...18.0:
            return 0
        case CGFloat(18.0).nextUp...26.0:
            return 1
        case CGFloat(26.0).nextUp...CGFloat.infinity:
            return 2
        default:
            return 0
        }
    }
    
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, fillRatio: CGFloat, scaleFactor: CGFloat) {
        self.speedSegmentedControl.selectedSegmentIndex = self.calcSegmentIndex(speed: speed)
        self.directionSlider.value = Float(direction)
        self.fillRatioSlider.value = Float(fillRatio)
        self.scaleFactorSlider.value = Float(scaleFactor)
    }
    
    func enterSelectionMode() {
        self.isSelected = false
        self.checkButton.isHidden = false
        
        self.speedSegmentedControl.isEnabled = false
        self.directionSlider.isEnabled = false
        self.fillRatioSlider.isEnabled = false
        self.scaleFactorSlider.isEnabled = false
    }
    
    func exitSelectionMode() {
        self.isSelected = false
        self.checkButton.isHidden = true
        
        self.speedSegmentedControl.isEnabled = true
        self.directionSlider.isEnabled = true
        self.fillRatioSlider.isEnabled = true
        self.scaleFactorSlider.isEnabled = true
    }
}
