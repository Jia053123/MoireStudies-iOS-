//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class MainViewController: UIViewController, PatternDataSource {
    @IBOutlet weak var exitButton: UIButton!
    var initSettings: InitSettings?
    private var moireModel: MoireModel?
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var controlViewControllers: Array<CtrlViewController> = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initModel()
        let mainView = self.view as! MainView
        mainView.setUpMoire(patterns: moireModel!.model)
        // set up control views
        assert(controlFrames.count >= moireModel!.model.count)
        for i in 0..<moireModel!.model.count {
            var cvc: CtrlViewController?
            switch self.initSettings!.interfaceSetting {
            case UISettings.controlScheme1Slider:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: moireModel!.model[i])
            case UISettings.controlScheme2Slider:
                cvc = CtrlViewControllerSch2.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: moireModel!.model[i])
            case UISettings.controlScheme1Gesture:
                cvc = CtrlViewControllerSch1.init(id: self.getCtrlViewControllerId(index: i),
                                                      frame: controlFrames[i],
                                                      pattern: moireModel!.model[i])
            }
            cvc!.delegate = self
            mainView.addSubview(cvc!.view)
            controlViewControllers.append(cvc!)
            // set up mask for each of the control view
            if (i == 0) {
                mainView.setUpMaskOnPatternView(patternIndex: 0, controlViewFrame: controlFrames[1])
            } else if (i == 1) {
                mainView.setUpMaskOnPatternView(patternIndex: 1, controlViewFrame: controlFrames[0])
            }
        }
    }
    
    func initModel() {
        do {
            guard let data = UserDefaults.standard.value(forKey: "Moire") as? Data else {throw NSError()}
            self.moireModel = try PropertyListDecoder().decode(MoireModel.self, from: data)
        } catch {
            print("problem loading saved moire; loading the default")
            self.moireModel = MoireModel()
            self.moireModel?.reset()
        }
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
        return self.moireModel!.model[getCtrlViewControllerIndex(id: i)]
    }
    
    func modifyPattern(speed: CGFloat, caller: CtrlViewController) -> Bool {
        print("setting speed to: ", speed)
        guard Constants.Bounds.speedRange.contains(speed) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        moireModel!.model[index].speed = speed
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: moireModel!.model[index])
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
        moireModel!.model[index].direction = direction
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: moireModel!.model[index])
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
        moireModel!.model[index].fillRatio = fillRatio
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: moireModel!.model[index])
        return true
    }
    
    func modifyPattern(scaleFactor: CGFloat, caller: CtrlViewController) -> Bool {
        print("setting scaleFactor to: ", scaleFactor)
        guard Constants.Bounds.scaleFactorRange.contains(scaleFactor) else {
            return false
        }
        guard let index = self.findControlViewIndex(controlViewController: caller) else {
            return false
        }
        moireModel!.model[index].scaleFactor = scaleFactor
        let mainView = self.view as! MainView
        mainView.modifiyPatternView(patternViewIndex: index, newPattern: moireModel!.model[index])
        return true
    }
    
    func saveMoire() -> Bool {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(self.moireModel), forKey: "Moire")
            return true
        } catch {
            print("problem saving the moire")
            return false
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        _ = self.saveMoire()
        performSegue(withIdentifier: "showSettingsView", sender: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

