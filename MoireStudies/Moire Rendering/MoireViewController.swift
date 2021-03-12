//
//  MainViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

class MoireViewController: UIViewController { // TODO: remove the core animation implementation and render all patterns in a single metal layer and benchmark? (currently the memory usage is quite high with more patterns per moire)
    private weak var dimView: UIView? // TODO: implement this properly by changing color in renderer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "MoireView"
        self.view.backgroundColor = UIColor.white
        
        let dv: UIView = UIView()
        dv.frame = self.view.bounds
        dv.backgroundColor = UIColor(white: 1, alpha: 0.5)
        dv.isHidden = true
        self.view.addSubview(dv)
        self.dimView = dv
    }
    
    func setUp(patterns: Array<Pattern>, settings: InitSettings) {
        self.resetMoireView(patterns: patterns, settings: settings)
    }
    
    func numOfPatternViews() -> Int {
        return self.children.count
    }
    
    func resetMoireView(patterns: Array<Pattern>, settings: InitSettings) {
        for c in self.children {
            c.willMove(toParent: nil)
            c.view.removeFromSuperview() // TODO: reuse the expensive pattern views
            c.removeFromParent()
        }
        
        for pattern in patterns {
            var pvc: PatternViewController
            switch settings.renderSetting {
            case RenderSettings.coreAnimation:
                pvc = CoreAnimPatternViewController()
            case RenderSettings.metal:
                pvc = MetalPatternViewController()
            }
            self.addChild(pvc)
            pvc.view.frame = self.view.bounds
            self.view.addSubview(pvc.view)
            pvc.didMove(toParent: self)
            pvc.setUpAndRender(pattern: pattern)
        }
        self.setUpMasks(with: settings.controlFrames)
    }
    
    func setUpMasks(with frames: Array<CGRect>) {
        // TODO: (with two patterns) at the moment, these two masks account for 6 of the 25 offscreen textures to render and aobut 30ms of GPU time per frame. Try creating the effect in shaders instead.
        guard self.children.count > 0 else {return}
        assert(frames.count >= self.children.count)
        for i in 0...(self.children.count - 1) {
            var maskFrames: Array<CGRect> = []
            for j in 0...(self.children.count - 1) {
                if j != i {
                    maskFrames.append(frames[j])
                }
            }
            let maskView = MaskView.init(frame: self.view.bounds, maskFrames: maskFrames)
            self.children[i].view.mask = maskView
        }
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        self.view.bringSubviewToFront(self.dimView!)
        self.dimView!.isHidden = false
        self.view.bringSubviewToFront(pvc.view)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        self.view.sendSubviewToBack(self.dimView!)
        self.dimView!.isHidden = true
        self.view.sendSubviewToBack(pvc.view)
    }
    
    func dimPatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        self.view.sendSubviewToBack(self.dimView!)
        self.dimView!.isHidden = false
        self.view.sendSubviewToBack(pvc.view)
    }
    
    func undimPatternViews() { // TODO: add parameter to enable multiple highlights/dims
        self.view.sendSubviewToBack(self.dimView!)
        self.dimView!.isHidden = true
    }
    
    func hidePatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        pvc.view.isHidden = true
    }
    
    func unhidePatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        pvc.view.isHidden = false
    }
    
    func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        (self.children[patternViewIndex] as! PatternViewController).updatePattern(newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        for c in self.children {
            (c as! PatternViewController).viewControllerLosingFocus()
        }
    }
    
    func takeMoireScreenshot() -> UIImage? {
        // get screenshot for each pattern view
        var imgs: Array<UIImage> = []
        for c in self.children {
            let patternView = (c as! PatternViewController).view!
            patternView.mask?.backgroundColor = UIColor.black
            
            guard let r = (c as! PatternViewController).takeScreenShot() else {return nil}
            imgs.append(r)
            
            patternView.mask?.backgroundColor = UIColor.clear
        }
        // overlay them together
        let size = Constants.Data.previewImageSize
        UIGraphicsBeginImageContext(size)
        for img in imgs {
            img.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        }
        let overlayedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return overlayedImg
    }
}
