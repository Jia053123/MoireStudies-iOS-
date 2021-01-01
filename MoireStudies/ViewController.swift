//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    typealias ControlViewSubclass = SliderControlView
    private var patternsModel: Array<Pattern> = []
    private var controlFrames: Array<CGRect> = [CGRect(x: 10, y: 30, width: 150, height: 300),
                                                CGRect(x: 200, y: 30, width: 150, height: 300)]
    private var controlViewControllers: Array<ControlViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patternsModel.append(Pattern.demoPattern1())
        patternsModel.append(Pattern.demoPattern2())
        let mainView = self.view as! MainView
        mainView.setUpMoire(patterns: patternsModel)
        
        assert(controlFrames.count >= patternsModel.count)
        for i in 0..<patternsModel.count {
            let cvc = ControlViewController.init(frame: controlFrames[i], pattern: patternsModel[i])
            cvc.delegate = self
            self.view.addSubview(cvc.view)
            controlViewControllers.append(cvc)
        }
    }
    
    func findControlViewIndex(controlViewController: ControlViewController) -> Int? {
        return controlViewControllers.firstIndex(of: controlViewController)
    }
    
    func modifyPattern(speed: CGFloat, caller: ControlViewController) -> Bool {
        print("speed is set to: ", speed)
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].speed = speed
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(direction: CGFloat, caller: ControlViewController) -> Bool {
        print("direction is set to: ", direction)
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].direction = direction
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(fillRatio: CGFloat, caller: ControlViewController) -> Bool {
        print("fillRatio is set to: ", fillRatio)
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].fillRatio = fillRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
    
    func modifyPattern(zoomRatio: CGFloat, caller: ControlViewController) -> Bool {
        print("zoomRatio is set to: ", zoomRatio)
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        patternsModel[index].zoomRatio = zoomRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: patternsModel[index])
        return true
    }
}

