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
    typealias PatternViewControllerClass = MetalPatternViewController
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private weak var highlightedPatternViewController: PatternViewController?
    private var dimView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimView.frame = self.view.bounds
        dimView.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    func setUp(patterns: Array<Pattern>) {
        self.view.backgroundColor = UIColor.white // TODO: move to viewDidLoad()
        self.resetMoireView(patterns: patterns)
    }
    
    func numOfPatternViews() -> Int {
        return self.children.count
    }
    
    func resetMoireView(patterns: Array<Pattern>) {
        for sv in self.view.subviews {
            sv.removeFromSuperview() // TODO: reuse the expensive pattern views
        }
        for c in self.children {
            c.removeFromParent()
        }
        
        for pattern in patterns {
            let pvc: PatternViewController = PatternViewControllerClass()
            self.addChild(pvc)
            pvc.view.frame = self.view.bounds
            self.view.addSubview(pvc.view)
            pvc.setUpAndRender(pattern: pattern)
        }
        self.setUpMasks()
    }
    
    func setUpMasks() {
        // TODO: at the moment, these two masks account for 6 of the 25 offscreen textures to render and aobut 30ms of GPU time per frame. Try creating the effect in shaders instead.
        let maskView1 = MaskView.init(frame: self.view.bounds, maskFrame: self.controlFrames[0])
        self.children[1].view.mask = maskView1
        
        let maskView2 = MaskView.init(frame: self.view.bounds, maskFrame: self.controlFrames[1])
        self.children[0].view.mask = maskView2
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        self.view.addSubview(self.dimView)
        self.highlightedPatternViewController = (pvc as! PatternViewController)
        self.view.bringSubviewToFront(pvc.view)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        let pvc = self.children[patternViewIndex]
        self.highlightedPatternViewController = nil
        self.dimView.removeFromSuperview()
        self.view.sendSubviewToBack(pvc.view)
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
