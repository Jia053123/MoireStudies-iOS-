//
//  SliderControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class SliderCtrlViewSch2 : UIView { // TODO: make the outlets private
    weak var target: BasicCtrlViewController?
    @IBOutlet weak var speedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var directionSlider: UISlider!
    @IBOutlet weak var blackSlider: UISlider!
    @IBOutlet weak var whiteSlider: UISlider!
    @IBOutlet weak var checkButton: UIButton!
    
    private var _isSelected: Bool = false
    private(set) var isSelected: Bool {
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
        let nib = UINib(nibName: "SliderCtrlViewSch2", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        directionSlider.minimumValue = 0.0
        directionSlider.maximumValue = 2 * Float.pi
        blackSlider.minimumValue = Float(Constants.UI.tileHeight / 2)
        blackSlider.maximumValue = 20.0
        whiteSlider.minimumValue = Float(Constants.UI.tileHeight / 2)
        whiteSlider.maximumValue = 20.0
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
    
    @IBAction func blackWidthChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(blackWidth: CGFloat(blackSlider.value))
        } else {
            print("target for SliderControlView not set")
        }
    }
    
    @IBAction func whiteWidthChanged(_ sender: Any) {
        if let t = self.target {
            _ = t.modifyPattern(whiteWidth: CGFloat(whiteSlider.value))
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
    
    func matchControlsWithValues(speed: CGFloat, direction: CGFloat, blackWidth: CGFloat, whiteWidth: CGFloat) {
        self.speedSegmentedControl.selectedSegmentIndex = self.calcSegmentIndex(speed: speed)
        self.directionSlider.value = Float(direction)
        self.blackSlider.value = Float(blackWidth)
        self.whiteSlider.value = Float(whiteWidth)
    }
    
    func enterSelectionMode() {
        self.isSelected = false
        self.checkButton.isHidden = false
        
        self.speedSegmentedControl.isEnabled = false
        self.directionSlider.isEnabled = false
        self.blackSlider.isEnabled = false
        self.whiteSlider.isEnabled = false
    }
    
    func exitSelectionMode() {
        self.isSelected = false
        self.checkButton.isHidden = true
        
        self.speedSegmentedControl.isEnabled = true
        self.directionSlider.isEnabled = true
        self.blackSlider.isEnabled = true
        self.whiteSlider.isEnabled = true
    }
}
