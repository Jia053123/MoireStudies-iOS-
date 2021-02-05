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
    var displayLink: CADisplayLink!
    
    private var vertexBuffer: MTLBuffer!
    private var patternRenderer: MetalPatternRenderer!
    private var recycledTiles: Array<MetalTile> = []
    private lazy var viewportSize: CGSize = (self.layer as! CAMetalLayer).drawableSize
    private var diagonalOfDrawableTexture: Float {
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
        self.displayLink.add(to: RunLoop.main, forMode: .default)
    }
    
    private func updateExistingTiles() {
        for t in self.patternRenderer.tilesToRender {
            t.length = self.diagonalOfDrawableTexture
            t.width = self.blackWidthInPixel
            t.orientation = self.directionInRad
        }
    }
    
    private func createTiles() {
        self.patternRenderer.tilesToRender = []
        
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        let numOfTiles: Int = Int(ceil(self.diagonalOfDrawableTexture / width)) + 1 // use the diagonal length to make sure the tiles reach the corners whatever the orientation
        var nextTranslation = self.diagonalOfDrawableTexture / 2.0
        for _ in 0 ..< numOfTiles {
            let newTile = MetalTile()
            newTile.translation = nextTranslation
            self.patternRenderer.tilesToRender.append(newTile) // TODO: should I reserve array capacity?
            nextTranslation -= width
        }
        self.updateExistingTiles()
    }
    
    /**
     Summary: make sure all tiles are spaced corrently and cover the whole translation range, adding or removing tiles when necessary
     */
    private func tileView() {
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        
        func fitMoreTilesToTheEndIfNecessary() {
            let lastTile = self.patternRenderer.tilesToRender.last!
            if lastTile.translation - self.translationRange.lowerBound >= width {
                let newTile = MetalTile()
                newTile.translation = lastTile.translation - width
                self.patternRenderer.tilesToRender.append(newTile)
                fitMoreTilesToTheEndIfNecessary()
            } else {
                return
            }
        }
        func fitMoreTilesToTheBeginningIfNecessary() {
            let firstTile = self.patternRenderer.tilesToRender.first!
            if self.translationRange.upperBound - firstTile.translation >= width {
                let newTile = MetalTile()
                newTile.translation = firstTile.translation + width
                self.patternRenderer.tilesToRender.insert(newTile, at: 0) // note: O(n)
                fitMoreTilesToTheBeginningIfNecessary()
            } else {
                return
            }
        }
        // start by picking the center tile as the anchor point
        let existingTileCount = self.patternRenderer.tilesToRender.count
        let middleIndex: Int = (existingTileCount - 1) / 2 // remember index starts with 0
        // first operate in the ascending direction
        for i in (middleIndex + 1) ..< existingTileCount {
            self.patternRenderer.tilesToRender[i].translation = self.patternRenderer.tilesToRender[i-1].translation - width
            if !self.translationRange.contains(self.patternRenderer.tilesToRender[i].translation) {
                self.patternRenderer.tilesToRender.removeSubrange(i..<existingTileCount) // TODO: use recycled tiles
                break
            }
        }
        fitMoreTilesToTheEndIfNecessary()
        // then operate in the descending direction
        for i in (0 ..< middleIndex).reversed() {
            self.patternRenderer.tilesToRender[i].translation = self.patternRenderer.tilesToRender[i+1].translation + width
            if !self.translationRange.contains(self.patternRenderer.tilesToRender[i].translation) {
                self.patternRenderer.tilesToRender.removeSubrange(0...i) // TODO: use recycled tiles
                break
            }
        }
        fitMoreTilesToTheBeginningIfNecessary()
    }
    
    private func translateTiles() { // always move from negative towards positive
        let tileCount = self.patternRenderer.tilesToRender.count
        print("speed: ", self.speedInPixel)
        // translate
        for i in (0 ..< tileCount).reversed() {
            let tile = self.patternRenderer.tilesToRender[i]
            tile.translation += self.speedInPixel * Float(self.displayLink.duration)
        }
        // remove offscreen tiles
        repeat {
            let firstT = self.patternRenderer.tilesToRender.first!
            if !self.translationRange.contains(firstT.translation) {
                self.recycledTiles.append(self.patternRenderer.tilesToRender.removeFirst())
            } else {
                break // all tiles after this should also be within bound
            }
        } while true
        // append removed tiles to the end
        let step = self.blackWidthInPixel + self.whiteWidthInPixel // TODO: verify correctness
        let recycledTileCount = self.recycledTiles.count
        for _ in (0 ..< recycledTileCount).reversed() {
            let lastTile = self.patternRenderer.tilesToRender.last!
            let newT = self.recycledTiles.removeLast()
            newT.translation = lastTile.translation - step
            self.patternRenderer.tilesToRender.append(newT)
        }
    }
    
    @objc private func render() {
        self.tileView()
        self.updateExistingTiles()
        self.translateTiles()
        self.patternRenderer.draw(in: self.layer as! CAMetalLayer, of: self.viewportSize)
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.pattern = pattern
        self.setup()
        self.createTiles()
        self.setupDisplayLink()
        self.backgroundColor = UIColor.clear
    }
    
    func updatePattern(newPattern: Pattern) {
        self.pattern = newPattern
        self.updateExistingTiles()
    }
    
    func pauseAnimations() {
        print("TODO: pauseRendering")
    }
}

