//
//  OpenGLPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit
import MetalKit

class MetalPatternView: UIView {
    override class var layerClass: AnyClass {get {return CAMetalLayer.self}}
    private var displayLink: CADisplayLink!
    
    private var vertexBuffer: MTLBuffer!
    private var patternRenderer: MetalPatternRenderer!
    private var recycledStripes: Array<MetalStripe> = []
    private lazy var viewportSize: CGSize = (self.layer as! CAMetalLayer).drawableSize
    private var diagonalOfDrawableTexture: Float { // TODO: diagonal is the max value. Calc this dynamically to save a bit GPU time?
        get {return Float(sqrt(pow(self.viewportSize.width, 2) + pow(self.viewportSize.height, 2)))}
    }
    private var translationRange: ClosedRange<Float> {
        get {return -1 * self.diagonalOfDrawableTexture / 2.0 ... self.diagonalOfDrawableTexture / 2.0}
    }
    private var pattern: Pattern!
    private var speedInPixel: Float {get {return Float(self.pattern.speed * UIScreen.main.scale)}}
    private var directionInRad: Float {get {return Float(self.pattern.direction)}}
    private var blackWidthInPixel: Float {get {return Float(self.pattern.blackWidth * UIScreen.main.scale)}}
    private var whiteWidthInPixel: Float {get {return Float(self.pattern.whiteWidth * UIScreen.main.scale)}}
    
    private func setup() {
        (self.layer as! CAMetalLayer).drawableSize = CGSize.init(width: self.bounds.size.width * UIScreen.main.scale,
                                                                 height: self.bounds.size.height * UIScreen.main.scale)
        self.layer.contentsScale = UIScreen.main.scale
        self.patternRenderer = MetalPatternRenderer()
        self.patternRenderer.initWithMetalLayer(metalLayer: self.layer as! CAMetalLayer)
    }
    
    private func setupDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(render))
        self.displayLink.preferredFramesPerSecond = 30
        self.displayLink.add(to: RunLoop.main, forMode: .default)
    }
    
    private func updateExistingStripes() {
        for t in self.patternRenderer.stripesToRender {
            t.length = self.diagonalOfDrawableTexture
            t.width = self.blackWidthInPixel
            t.orientation = self.directionInRad
        }
    }
    
    private func createStripes() {
        self.patternRenderer.stripesToRender = []
        let numToReserve: Int = Int(ceil(self.diagonalOfDrawableTexture / Float(Constants.Bounds.blackWidthRange.lowerBound + Constants.Bounds.whiteWidthRange.lowerBound))) + 1
        self.patternRenderer.stripesToRender.reserveCapacity(numToReserve)
        
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        let numOfStripes: Int = Int(ceil(self.diagonalOfDrawableTexture / width)) + 1 // use the diagonal length to make sure the stripes reach the corners whatever the orientation
        var nextTranslation = self.diagonalOfDrawableTexture / 2.0
        for _ in 0 ..< numOfStripes {
            let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
            newStripe.translation = nextTranslation
            self.patternRenderer.stripesToRender.append(newStripe)
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
            let lastStripe = self.patternRenderer.stripesToRender.last!
            if lastStripe.translation - self.translationRange.lowerBound >= width {
                let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
                newStripe.translation = lastStripe.translation - width
                self.patternRenderer.stripesToRender.append(newStripe)
                fitMoreStripesToTheEndIfNecessary()
            } else {
                return
            }
        }
        func fitMoreStripesToTheBeginningIfNecessary() {
            let firstStripe = self.patternRenderer.stripesToRender.first!
            if self.translationRange.upperBound - firstStripe.translation >= width {
                let newStripe = self.recycledStripes.popLast() ?? MetalStripe()
                newStripe.translation = firstStripe.translation + width
                self.patternRenderer.stripesToRender.insert(newStripe, at: 0) // note: O(n)
                fitMoreStripesToTheBeginningIfNecessary()
            } else {
                return
            }
        }
        // start by picking the center stripe as the anchor point
        let existingStripeCount = self.patternRenderer.stripesToRender.count
        let middleIndex: Int = (existingStripeCount - 1) / 2 // remember index starts with 0
        // first operate in the ascending direction
        for i in (middleIndex + 1) ..< existingStripeCount {
            self.patternRenderer.stripesToRender[i].translation = self.patternRenderer.stripesToRender[i-1].translation - width
            if !self.translationRange.contains(self.patternRenderer.stripesToRender[i].translation) {
                let rangeToRecycle = i ..< existingStripeCount
                self.recycledStripes.append(contentsOf: self.patternRenderer.stripesToRender[rangeToRecycle])
                self.patternRenderer.stripesToRender.removeSubrange(rangeToRecycle)
                break
            }
        }
        fitMoreStripesToTheEndIfNecessary()
        // then operate in the descending direction
        for i in (0 ..< middleIndex).reversed() {
            self.patternRenderer.stripesToRender[i].translation = self.patternRenderer.stripesToRender[i+1].translation + width
            if !self.translationRange.contains(self.patternRenderer.stripesToRender[i].translation) {
                let rangeToRecycle = 0...i
                self.recycledStripes.append(contentsOf: self.patternRenderer.stripesToRender[rangeToRecycle])
                self.patternRenderer.stripesToRender.removeSubrange(rangeToRecycle)
                break
            }
        }
        fitMoreStripesToTheBeginningIfNecessary()
    }
    
    private func translateStripes() { // always move from negative towards positive
        let stripeCount = self.patternRenderer.stripesToRender.count
        // translate
        for i in (0 ..< stripeCount).reversed() {
            let stripe = self.patternRenderer.stripesToRender[i]
            stripe.translation += Float(Double(self.speedInPixel) * (self.displayLink.targetTimestamp - self.displayLink.timestamp))
        }
        // remove offscreen stripes and append them to the rear
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        repeat {
            let firstT = self.patternRenderer.stripesToRender.first!
            if !self.translationRange.contains(firstT.translation) {
                let offScreenStripe = self.patternRenderer.stripesToRender.removeFirst()
                let lastStripe = self.patternRenderer.stripesToRender.last!
                offScreenStripe.translation = lastStripe.translation - width
                self.patternRenderer.stripesToRender.append(offScreenStripe)
            } else {
                break // all stripes after this should also be within bound
            }
        } while true
    }
    
    @objc private func render() {
        self.translateStripes()
        self.patternRenderer.draw(in: self.layer as! CAMetalLayer, of: self.viewportSize)
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.pattern = pattern
        self.setup()
        self.createStripes()
        self.setupDisplayLink()
        self.backgroundColor = UIColor.clear
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
        self.displayLink.isPaused = true
        self.patternRenderer.screenShotSwitch = true
        (self.layer as! CAMetalLayer).framebufferOnly = false
        
        self.patternRenderer.draw(in: self.layer as! CAMetalLayer, of: self.viewportSize)
        if let texture = self.patternRenderer.screenShot, let ciImg = CIImage.init(mtlTexture: texture, options: nil) {
            out = UIImage.init(ciImage: ciImg)
        } else {
            out = nil
        }
        self.patternRenderer.screenShot = nil
        
        (self.layer as! CAMetalLayer).framebufferOnly = true
        self.patternRenderer.screenShotSwitch = false
        self.displayLink.isPaused = false
        return out
    }
}

