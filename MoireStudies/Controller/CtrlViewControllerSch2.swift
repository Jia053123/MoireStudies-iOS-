//
//  CtrlViewControllerSch2.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-03.
//

import Foundation
import UIKit

class CtrlViewControllerSch2: UIViewController, CtrlViewController, PatternCtrlSch2Target {
    var id: Int?
    weak var delegate: PatternStore?
    
    init(frame: CGRect, pattern: Pattern?) {
        super.init(nibName: nil, bundle: nil)
        let controlView: ControlViewSch2 = SliderCtrlViewSch2.init(frame: frame)
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
    
    func modifyPattern(blackWidth: CGFloat) -> Bool {
//        return delegate?.modifyPattern(fillRatio: fillRatio, caller: self) ?? false
        return false
    }
    
    func modifyPattern(whiteWidth: CGFloat) -> Bool {
//        return delegate?.modifyPattern(zoomRatio: zoomRatio, caller: self) ?? false
        return false
    }
}

