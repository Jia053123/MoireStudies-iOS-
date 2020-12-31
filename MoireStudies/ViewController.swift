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
        controlViews.append(controlView)
        self.matchControlViewsWithPatterns()
    }
    
    func matchControlViewsWithPatterns() {
        assert(patternsModel.count == controlViews.count)
        for i in 0..<patternsModel.count {
            controlViews[i].matchControls(pattern: patternsModel[i])
        }
    }
    
    func modifyPattern(speed: Double) -> Bool {
        print("speed is set to: ", speed)
        var newPattern = patternsModel.first!
        newPattern.speed = speed
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: 0, newPattern: newPattern)
        return true
    }
    
    func modifyPattern(direction: Double) -> Bool {
        print("direction is set to: ", direction)
        var newPattern = patternsModel.first!
        newPattern.direction = direction
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: 0, newPattern: newPattern)
        return true
    }
    
    func modifyPattern(fillRatio: Double) -> Bool {
        print("fillRatio is set to: ", fillRatio)
        var newPattern = patternsModel.first!
        newPattern.fillRatio = fillRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: 0, newPattern: newPattern)
        return true
    }
    
    func modifyPattern(zoomRatio: Double) -> Bool {
        print("zoomRatio is set to: ", zoomRatio)
        var newPattern = patternsModel.first!
        newPattern.zoomRatio = zoomRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: 0, newPattern: newPattern)
        return true
    }
}

