//
//  MainViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

class MoireViewController: UIViewController {
    typealias PatternViewClass = MetalPatternView //CoreAnimPatternView
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var patternViewContainers: Array<WeakPatternViewContainer> = []
    private var highlightedViewContainers: Array<WeakPatternViewContainer> = []
    private var dimView: UIView = UIView()
    
    func setUp(patterns: Array<Pattern>) {
        self.view.backgroundColor = UIColor.white
        self.resetMoireView(patterns: patterns)
    }
    
    func numOfPatternViews() -> Int {
        return self.patternViewContainers.count
    }
    
    func resetMoireView(patterns: Array<Pattern>) {
        for sv in self.view.subviews {
            sv.removeFromSuperview() // TODO: reuse the expensive pattern views
        }
        self.patternViewContainers = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.view.bounds)
            self.patternViewContainers.append(WeakPatternViewContainer.init(content: newPatternView))
            self.view.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
        self.setUpMasks()
    }
    
    func setUpMasks() {
        // TODO: at the moment, these two masks account for 6 of the 25 offscreen textures to render and aobut 30ms of GPU time per frame. Try creating the effect in shaders instead.
        let maskView1 = MaskView.init(frame: self.view.bounds, maskFrame: self.controlFrames[0])
        self.patternViewContainers[1].content!.mask = maskView1
        
        let maskView2 = MaskView.init(frame: self.view.bounds, maskFrame: self.controlFrames[1])
        self.patternViewContainers[0].content!.mask = maskView2
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        let pvc = patternViewContainers[patternViewIndex]
        let pv = pvc.content!
        dimView.frame = self.view.bounds
        dimView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.view.addSubview(dimView)
        highlightedViewContainers.append(pvc)
        self.view.bringSubviewToFront(pv)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        let pvc = patternViewContainers[patternViewIndex]
        let pv = pvc.content!
        if let i = highlightedViewContainers.firstIndex(where: {$0 == pvc}) {
            highlightedViewContainers.remove(at: i)
        }
        if highlightedViewContainers.count == 0 {
            dimView.removeFromSuperview()
        }
        self.view.sendSubviewToBack(pv)
    }
    
    func modifyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.patternViewContainers[patternViewIndex].content!.updatePattern(newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        for pvc in patternViewContainers {
            pvc.content!.viewControllerLosingFocus()
        }
    }
    
    func takeMoireScreenshot() -> UIImage? {
        // get screenshot for each pattern view
        var imgs: Array<UIImage> = []
        for pvc in patternViewContainers {
            let pv = pvc.content!
            pv.mask?.backgroundColor = UIColor.black
            
            guard let r = pv.takeScreenShot() else {return nil}
            imgs.append(r)
            
            pv.mask?.backgroundColor = UIColor.clear
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
