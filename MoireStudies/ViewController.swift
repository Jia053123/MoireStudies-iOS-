//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class ViewController: UIViewController, PatternControlTarget {
    typealias ControlViewSubclass = SliderControlView
    
    private var patternsModel: Array<Pattern> = []
    private var controlFrame1 = CGRect(x: 10, y: 30, width: 150, height: 300)
    private var controlViews: Array<ControlViewSubclass> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainView = self.view as! MainView
        
        patternsModel.append(Pattern.randomPattern())
        mainView.setUpMoire(patterns: patternsModel)
        let controlView = ControlViewSubclass.init(frame: controlFrame1)
        controlView.target = self
        mainView.addSubview(controlView)
        self.controlViews.append(controlView)
    }
    
    func modifyPattern(speed: Double) -> Bool {
        print("speed is set to: ", speed)
        return true
    }
    
    func modifyPattern(direction: Double) -> Bool {
        return true
    }
    
    func modifyPattern(fillRatio: Double) -> Bool {
        return true
    }
    
    func modifyPattern(zoomRatio: Double) -> Bool {
        return true
    }
}

