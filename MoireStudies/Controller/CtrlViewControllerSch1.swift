//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class CtrlViewControllerSch1: UIViewController, CtrlViewController, PatternCtrlSch1Target {
    var id: Int?
    weak var delegate: PatternStore?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        let controlView: ControlViewSch1 = SliderCtrlViewSch1.init(frame: frame)
        controlView.target = self
        if let p = pattern {
            controlView.matchControlsWithModel(pattern: p)
        }
        self.view = controlView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func modifyPattern(speed: CGFloat) -> Bool {
        return delegate?.modifyPattern(speed: speed, caller: self) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction, caller: self) ?? false
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        return delegate?.modifyPattern(fillRatio: fillRatio, caller: self) ?? false
    }
    
    func modifyPattern(zoomRatio: CGFloat) -> Bool {
        return delegate?.modifyPattern(zoomRatio: zoomRatio, caller: self) ?? false
    }
}

