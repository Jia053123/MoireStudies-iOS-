//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class MainViewController: UIViewController, PatternStore {
    //typealias ControlViewSubclass = SliderCtrlViewSch1
    typealias CtrlViewControllerSubclass = CtrlViewControllerSch1
    private var patternsModel: Array<Pattern> = []
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var controlViewControllers: Array<CtrlViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPatternModel()
        let mainView = self.view as! MainView
        mainView.setUpMoire(patterns: patternsModel)
        
        assert(controlFrames.count >= patternsModel.count)
        for i in 0..<patternsModel.count {
            let cvc: CtrlViewController = CtrlViewControllerSubclass.init(id: i, frame: controlFrames[i], pattern: patternsModel[i])
            cvc.delegate = self
            mainView.addSubview(cvc.view)
            controlViewControllers.append(cvc)
            if (i == 0) {
                mainView.setUpMaskOnPatternView(patternIndex: 0, controlViewFrame: controlFrames[1])
            } else if (i == 1) {
                mainView.setUpMaskOnPatternView(patternIndex: 1, controlViewFrame: controlFrames[0])
            }
        }
    }
    
    func initPatternModel() {
        patternsModel.append(Pattern.demoPattern1())
        patternsModel.append(Pattern.demoPattern2())
    }
    
    func findControlViewIndex(controlViewController: CtrlViewController) -> Int? {
        return controlViewController.id
    }
    
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool {
        print("speed is set to: ", speed)
        guard Constants.Bounds.speedRange.contains(speed) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].speed = speed
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(direction: CGFloat, caller: CtrlViewController) -> Bool {
        print("direction is set to: ", direction)
        guard Constants.Bounds.directionRange.contains(direction) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].direction = direction
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(fillRatio: CGFloat, caller: CtrlViewController) -> Bool {
        print("fillRatio is set to: ", fillRatio)
        guard Constants.Bounds.fillRatioRange.contains(fillRatio) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].fillRatio = fillRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(zoomRatio: CGFloat, caller: CtrlViewController) -> Bool {
        print("zoomRatio is set to: ", zoomRatio)
        guard Constants.Bounds.zoomRatioRange.contains(zoomRatio) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].zoomRatio = zoomRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
}

