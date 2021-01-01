//
//  ControlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-31.
//

import Foundation
import UIKit

class ControlViewController: UIViewController, PatternControlTarget {
    typealias ControlViewSubclass = SliderControlView
    var delegate: PatternControlTarget?
    private var defaultFrame = CGRect(x: 10, y: 30, width: 150, height: 300)
    
    init(pattern: Pattern?) {
        super.init(nibName: nil, bundle: nil)
        let controlView = ControlViewSubclass.init(frame: defaultFrame)
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
        return delegate?.modifyPattern(speed: speed) ?? false
    }
    
    func modifyPattern(direction: CGFloat) -> Bool {
        return delegate?.modifyPattern(direction: direction) ?? false
    }
    
    func modifyPattern(fillRatio: CGFloat) -> Bool {
        return delegate?.modifyPattern(fillRatio: fillRatio) ?? false
    }
    
    func modifyPattern(zoomRatio: CGFloat) -> Bool {
        return delegate?.modifyPattern(zoomRatio: zoomRatio) ?? false
    }
}

