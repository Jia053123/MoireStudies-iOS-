//
//  MetalPatternViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-07.
//

import Foundation
import UIKit

class MetalPatternViewController: UIViewController {
    private var pattern: Pattern!
    private var speedInPixel: Float {get {return Float(self.pattern.speed * UIScreen.main.scale)}}
    private var directionInRad: Float {get {return Float(self.pattern.direction)}}
    private var blackWidthInPixel: Float {get {return Float(self.pattern.blackWidth * UIScreen.main.scale)}}
    private var whiteWidthInPixel: Float {get {return Float(self.pattern.whiteWidth * UIScreen.main.scale)}}
    
    private var patternRenderer: MetalPatternRenderer!
    private var patternStripes: Array<MetalStripe>! // sorted: the first element always has the most positive translation value
    private var recycledStripes: Array<MetalStripe> = []
    
    private lazy var viewportSizePixel: CGSize = (self.view.layer as! CAMetalLayer).drawableSize
    private var diagonalOfDrawableTexture: Float { // TODO: diagonal is the max value. Calc this dynamically to save a bit GPU time?
        get {return Float(sqrt(pow(self.viewportSizePixel.width, 2) + pow(self.viewportSizePixel.height, 2)))}
    }
    private var translationRange: ClosedRange<Float> {
        get {return -1 * self.diagonalOfDrawableTexture / 2.0 ... self.diagonalOfDrawableTexture / 2.0}
    }
    
    override func loadView() {
        self.view = MetalPatternView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (self.view as! MetalPatternView).invalidateDisplayLink()
    }
    
    private func updateStripe(stripe: MetalStripe) {
        stripe.length = self.diagonalOfDrawableTexture
        stripe.width = self.blackWidthInPixel
        stripe.orientation = self.directionInRad
    }
    
    private func updateExistingStripes() {
        for s in self.patternStripes {
            self.updateStripe(stripe: s)
        }
    }
    
    private func createStripes() {
        self.patternStripes = []
        let numToReserve: Int = Int(ceil(self.diagonalOfDrawableTexture / Float(Constants.Bounds.blackWidthRange.lowerBound + Constants.Bounds.whiteWidthRange.lowerBound))) + 1
        self.patternStripes.reserveCapacity(numToReserve)
        
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        let numOfStripes: Int = Int(ceil(self.diagonalOfDrawableTexture / width)) + 1 // use the diagonal length to make sure the stripes reach the corners whatever the orientation
        var nextTranslation = self.diagonalOfDrawableTexture / 2.0
        for _ in 0 ..< numOfStripes {
            let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
            newStripe.translation = nextTranslation
            self.patternStripes.append(newStripe)
            nextTranslation -= width
        }
        self.updateExistingStripes()
    }
    /**
     Summary: make sure all stripes are spaced corrently and cover the whole translation range, adding or removing stripes when necessary
     */
    private func tileView() {
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        func fitMoreStripesToTheEndIfNecessary() {
            let lastStripe = self.patternStripes.last!
            if lastStripe.translation - self.translationRange.lowerBound >= width {
                let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
                newStripe.translation = lastStripe.translation - width
                print("fit new stripe with translation: ", newStripe.translation)
//                self.updateStripe(stripe: newStripe)
                
                self.patternStripes.append(newStripe)
                fitMoreStripesToTheEndIfNecessary()
            } else {
                return
            }
        }
        func fitMoreStripesToTheBeginningIfNecessary() {
            let firstStripe = self.patternStripes.first!
            if self.translationRange.upperBound - firstStripe.translation >= width {
                let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
                newStripe.translation = firstStripe.translation + width
                
//                self.updateStripe(stripe: newStripe)
                
                self.patternStripes.insert(newStripe, at: 0) // note: O(n)
                fitMoreStripesToTheBeginningIfNecessary()
            } else {
                return
            }
        }
        // start by picking the center stripe as the anchor point
        let existingStripeCount = self.patternStripes.count
        let middleIndex: Int = (existingStripeCount - 1) / 2 // remember index starts with 0
        // first operate in the ascending direction
        for i in (middleIndex + 1) ..< existingStripeCount {
            self.patternStripes[i].translation = self.patternStripes[i-1].translation - width
            if !self.translationRange.contains(self.patternStripes[i].translation) {
                let rangeToRecycle = i ..< existingStripeCount
                self.recycledStripes.append(contentsOf: self.patternStripes[rangeToRecycle])
                self.patternStripes.removeSubrange(rangeToRecycle)
                break
            }
        }
        fitMoreStripesToTheEndIfNecessary()
        // then operate in the descending direction
        for i in (0 ..< middleIndex).reversed() {
            self.patternStripes[i].translation = self.patternStripes[i+1].translation + width
            if !self.translationRange.contains(self.patternStripes[i].translation) {
                let rangeToRecycle = 0...i
                self.recycledStripes.append(contentsOf: self.patternStripes[rangeToRecycle])
                self.patternStripes.removeSubrange(rangeToRecycle)
                break
            }
        }
        fitMoreStripesToTheBeginningIfNecessary()
    }
    
    private func translateStripes(frameDuration: CFTimeInterval) { // always move from negative towards positive
        let stripeCount = self.patternStripes.count
        // translate
        for i in (0 ..< stripeCount).reversed() {
            let stripe = self.patternStripes[i]
            stripe.translation += Float(Double(self.speedInPixel) * frameDuration) //(self.displayLink!.targetTimestamp - self.displayLink!.timestamp))
        }
        // remove offscreen stripes and append them to the rear
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        repeat {
            let firstT = self.patternStripes.first!
            if !self.translationRange.contains(firstT.translation) {
                let offScreenStripe = self.patternStripes.removeFirst()
                let lastStripe = self.patternStripes.last!
                offScreenStripe.translation = lastStripe.translation - width
                self.patternStripes.append(offScreenStripe)
            } else {
                break // all stripes after this should also be within bound
            }
        } while true
    }
    
    func render(frameDuration: CFTimeInterval) {
        self.translateStripes(frameDuration: frameDuration)
        self.patternRenderer.draw(stripesToRender: self.patternStripes, in: self.view.layer as! CAMetalLayer, of: self.viewportSizePixel)
    }
}

extension MetalPatternViewController: PatternViewController {
    func setUpAndRender(pattern: Pattern) {
        self.pattern = pattern
        
        (self.view as! MetalPatternView).setup(delegate: self)
        self.patternRenderer = MetalPatternRenderer()
        self.patternRenderer.initWithMetalLayer(metalLayer: self.view.layer as! CAMetalLayer)
        
        self.createStripes() // must have the renderer ready before this
    }
    
    func updatePattern(newPattern: Pattern) {
        if self.pattern != newPattern {
            let oldPattern = self.pattern!
            self.pattern = newPattern
            if oldPattern.blackWidth != self.pattern.blackWidth || oldPattern.whiteWidth != self.pattern.whiteWidth {
                self.tileView()
            }
            self.updateExistingStripes()
        }
    }
    
    func viewControllerLosingFocus() {
        // nothing necessary
    }
    
    func takeScreenShot() -> UIImage? {
        let out: UIImage?
        (self.view as! MetalPatternView).pauseDisplayLink()
        self.patternRenderer.screenShotSwitch = true
        (self.view.layer as! CAMetalLayer).framebufferOnly = false
        
        self.patternRenderer.draw(stripesToRender: self.patternStripes, in: self.view.layer as! CAMetalLayer, of: self.viewportSizePixel)
        if let texture = self.patternRenderer.screenShot, let ciImg = CIImage.init(mtlTexture: texture, options: nil) {
            out = UIImage.init(ciImage: ciImg)
        } else {
            out = nil
        }
        self.patternRenderer.screenShot = nil
        
        (self.view.layer as! CAMetalLayer).framebufferOnly = true
        self.patternRenderer.screenShotSwitch = false
        (self.view as! MetalPatternView).resumeDisplayLink()
        return out
    }
}
