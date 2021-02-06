//
//  MoireView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-17.
//

import UIKit
import Foundation
/**
 SubViews hierachy:
 - MainView
    - UIButton
    - ControlsView
        - ControlView (n)
    - MoireView (1)
        - DimView (0..1)
        - PatternView (n)
            - MaskView(1) in mask property
 */
class MainView: UIView {
    typealias PatternViewClass = MetalPatternView //CoreAnimPatternView
    private var controlFrames: Array<CGRect> = Constants.UI.defaultControlFrames
    private var moireView: UIView = UIView()
    private var patternViews: Array<PatternView> = []
    private var highlightedViews: Array<PatternView> = []
    private var dimView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initHelper()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initHelper()
    }
    
    func initHelper() {
        self.moireView.backgroundColor = UIColor.white
        self.addSubview(self.moireView)
    }
    
    func setUp(patterns: Array<Pattern>) {
        self.resetMoireView(patterns: patterns)
    }
    
    func numOfPatternViews() -> Int {
        return self.patternViews.count
    }
    
    func resetMoireView(patterns: Array<Pattern>) {
        self.moireView.frame = self.bounds
        for sv in self.moireView.subviews {
            sv.removeFromSuperview() // TODO: reuse the expensive pattern views 
        }
        patternViews = []
        for pattern in patterns {
            let newPatternView: PatternView = PatternViewClass.init(frame: self.moireView.bounds)
            patternViews.append(newPatternView)
            self.moireView.addSubview(newPatternView)
            newPatternView.setUpAndRender(pattern: pattern)
        }
        self.setUpMasks()
    }
    
    func setUpMasks() {
        // TODO: at the moment, these two masks account for 6 of the 25 offscreen textures to render and aobut 30ms of GPU time per frame. Try creating the effect in shaders instead. 
        let maskView1 = MaskView.init(frame: self.moireView.bounds, maskFrame: self.controlFrames[0])
        self.patternViews[1].mask = maskView1
        let maskView2 = MaskView.init(frame: self.moireView.bounds, maskFrame: self.controlFrames[1])
        self.patternViews[0].mask = maskView2
    }
    
    func highlightPatternView(patternViewIndex: Int) {
        let pv = patternViews[patternViewIndex]
        dimView.frame = self.moireView.bounds
        dimView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.moireView.addSubview(dimView)
        highlightedViews.append(pv)
        self.moireView.bringSubviewToFront(pv)
    }
    
    func unhighlightPatternView(patternViewIndex: Int) {
        let pv = patternViews[patternViewIndex]
        if let i = highlightedViews.firstIndex(where: {$0 == pv}) {
            highlightedViews.remove(at: i)
        }
        if highlightedViews.count == 0 {
            dimView.removeFromSuperview()
        }
        self.sendSubviewToBack(pv)
    }
    
    func modifiyPatternView(patternViewIndex: Int, newPattern: Pattern) {
        self.patternViews[patternViewIndex].updatePattern(newPattern: newPattern)
    }
    
    func viewControllerLosingFocus() {
        for pv in patternViews {
            pv.viewControllerLosingFocus()
        }
    }
    
    func takeMoireScreenshot() -> UIImage? {
        // get screenshot for each pattern view
        for pv in patternViews {
            pv.mask?.backgroundColor = UIColor.black
        }
        var imgs: Array<UIImage> = []
        for pv in patternViews {
            guard let r = pv.takeScreenShot() else {return nil}
            imgs.append(r)
        }
        for pv in patternViews {
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
