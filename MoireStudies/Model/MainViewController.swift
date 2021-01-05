//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class MainViewController: UIViewController, PatternStore {
    private var patternsModel: Array<Pattern> = []
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var controlViewControllers: Array<CtrlViewController> = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initPatternModel()
        let mainView = self.view as! MainView
        mainView.setUpMoire(patterns: patternsModel)
        
        assert(controlFrames.count >= patternsModel.count)
        for i in 0..<patternsModel.count {
            var cvc: CtrlViewController?
            switch Settings.interfaceSetting {
            case UISettings.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: patternsModel[i])
            case UISettings.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: patternsModel[i])
            case UISettings.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: patternsModel[i])
            }
            cvc!.delegate = self
            mainView.addSubview(cvc!.view)
            controlViewControllers.append(cvc!)
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
    
    func getCtrlViewControllerId(index: Int) -> Int {
        let id = index
        assert(self.getCtrlViewControllerIndex(id: id) == index, "reverse conversion test failed")
        return id
    }
    
    func getCtrlViewControllerIndex(id: Int) -> Int {
        let index = id
        return index
    }
    
    func findControlViewIndex(controlViewController: CtrlViewController) -> Int? {
        guard let i = controlViewController.id else {
            return nil
        }
        return self.getCtrlViewControllerIndex(id: i)
    }
    
    func getPattern(caller: CtrlViewController) -> Pattern? {
        guard let i = caller.id else {
            return nil
        }
        return self.patternsModel[getCtrlViewControllerIndex(id: i)]
    }
    
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool {
        print("setting speed to: ", speed)
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
        print("setting direction to: ", direction)
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
        print("setting fillRatio to: ", fillRatio)
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
        print("setting zoomRatio to: ", zoomRatio)
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

