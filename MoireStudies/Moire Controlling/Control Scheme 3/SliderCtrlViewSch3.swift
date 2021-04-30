//
//  SliderCtrlViewSch3.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-24.
//

import Foundation
import UIKit

class SliderCtrlViewSch3: UIView { // TODO: make the outlets private
    weak var target: BasicCtrlViewController?
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var directionSlider: UISlider! // TODO: subclass to allow finer control
    @IBOutlet weak var blackWidthSlider: UISlider!
    @IBOutlet weak var whiteWidthSlider: UISlider!
    @IBOutlet weak var fillRatioSlider: UISlider!
    @IBOutlet weak var scaleFactorSlider: UISlider!
    @IBOutlet weak var highlightButton: UIButton!
    @IBOutlet weak var dimButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    private var _isSelected: Bool = false
    var isSelected: Bool {
        get {return self._isSelected}
        set {
            if newValue {
                self.checkButton.tintColor = UIColor.systemGreen
                var selectedIcon = UIImage.init(systemName: "checkmark.circle.fill")
                selectedIcon = selectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large))
                selectedIcon = selectedIcon!.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .bold))
                self.checkButton.setImage(selectedIcon, for: UIControl.State.normal)
            } else {
                self.checkButton.tintColor = UIColor.systemGreen
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
        let nib = UINib(nibName: "SliderCtrlViewSch3", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        speedSlider.minimumValue = Float(BoundsManager.speedRange.lowerBound)
        speedSlider.maximumValue = Float(BoundsManager.speedRange.upperBound)
        directionSlider.minimumValue = Float(BoundsManager.directionRange.lowerBound)
        directionSlider.maximumValue = Float(BoundsManager.directionRange.upperBound)
        blackWidthSlider.minimumValue = Float(BoundsManager.blackWidthRange.lowerBound)
        blackWidthSlider.maximumValue = Float(BoundsManager.blackWidthRange.upperBound)
        whiteWidthSlider.minimumValue = Float(BoundsManager.whiteWidthRange.lowerBound)
        whiteWidthSlider.maximumValue = Float(BoundsManager.whiteWidthRange.upperBound)
        fillRatioSlider.minimumValue = 0.1
        fillRatioSlider.maximumValue = 0.9
        scaleFactorSlider.minimumValue = 1.0
        scaleFactorSlider.maximumValue = 10.0
        
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = self.makeMenu(isHidden: false)
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
//        self.target?.dimPattern()
        _ = self.target?.hidePattern()
    }
    
    @IBAction func dimButtonReleased(_ sender: Any) {
//        self.target?.undimPattern()
        self.target?.unhidePattern()
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        self.isSelected = !self.isSelected
    }
}

extension SliderCtrlViewSch3 {
    private func makeMenu(isHidden: Bool) -> UIMenu {
        let hide = UIAction(title: "Hide Pattern", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: UIMenuElement.State.off, handler: {_ in self.hidePattern()})
        
        let unhide = UIAction(title: "Unhide Pattern", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: UIMenuElement.State.off, handler: {_ in self.unhidePattern()})
        
        let duplicate = UIAction(title: "Duplicate Pattern", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: [], state: UIMenuElement.State.off, handler: {_ in self.duplicatePattern()})
        
        let delete = UIAction(title: "Delete Pattern", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: UIMenuElement.Attributes.destructive, state: UIMenuElement.State.off, handler: {_ in self.deletePattern()})
        
        if isHidden {
            return UIMenu(title: "Pattern Options", image: nil, identifier: nil, options: [], children: [unhide, duplicate, delete])
        } else {
            return UIMenu(title: "Pattern Options", image: nil, identifier: nil, options: [], children: [hide, duplicate, delete])
        }
    }
    
    @objc func hidePattern() {
        let success = self.target!.hidePattern()
        if success {
            menuButton.menu = self.makeMenu(isHidden: true)
        }
    }
    
    @objc func unhidePattern() {
        self.target?.unhidePattern()
        menuButton.menu = self.makeMenu(isHidden: false)
    }
    
    @objc func deletePattern() {
        self.target?.deletePattern()
    }
    
    @objc func duplicatePattern() {
        self.target?.duplicatePattern()
    }
}

extension SliderCtrlViewSch3 {
    func matchControlsWithBounds(fillRatioRange: ClosedRange<CGFloat>, scaleFactorRange: ClosedRange<CGFloat>) {
        if fillRatioRange.upperBound - fillRatioRange.lowerBound < 0.001 {
            self.fillRatioSlider.isEnabled = false
        } else {
            self.fillRatioSlider.isEnabled = true
            self.fillRatioSlider.minimumValue = Float(fillRatioRange.lowerBound)
            self.fillRatioSlider.maximumValue = Float(fillRatioRange.upperBound)
        }
        
        if scaleFactorRange.upperBound - scaleFactorRange.lowerBound < 0.001 {
            self.scaleFactorSlider.isEnabled = false
        } else {
            self.scaleFactorSlider.isEnabled = true
            self.scaleFactorSlider.minimumValue = Float(scaleFactorRange.lowerBound)
            self.scaleFactorSlider.maximumValue = Float(scaleFactorRange.upperBound)
        }
    }
    
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

extension SliderCtrlViewSch3 {
    func enterSelectionMode() {
        self.isSelected = false
        self.menuButton.isHidden = true
        self.checkButton.isHidden = false
        
        self.speedSlider.isEnabled = false
        self.directionSlider.isEnabled = false
        self.fillRatioSlider.isEnabled = false
        self.blackWidthSlider.isEnabled = false
        self.whiteWidthSlider.isEnabled = false
        self.fillRatioSlider.isEnabled = false
        self.scaleFactorSlider.isEnabled = false
    }
    
    func exitSelectionMode() {
        self.isSelected = false
        self.checkButton.isHidden = true
        self.menuButton.isHidden = false
        
        self.speedSlider.isEnabled = true
        self.directionSlider.isEnabled = true
        self.fillRatioSlider.isEnabled = true
        self.blackWidthSlider.isEnabled = true
        self.whiteWidthSlider.isEnabled = true
        self.fillRatioSlider.isEnabled = true
        self.scaleFactorSlider.isEnabled = true
    }
}
