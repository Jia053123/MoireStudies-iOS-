//
//  OpenGLPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit
import MetalKit

class MetalPatternView: MTKView {
    private var vertexBuffer: MTLBuffer!
    private var patternRenderer: MetalPatternRenderer!
    private var recycledTiles: Array<MetalTile> = []
    private lazy var viewportSize: CGSize = self.drawableSize
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
    
    private func setUpMetal() {
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {return}
        self.patternRenderer = MetalPatternRenderer()
        self.patternRenderer.initWithMetalKitView(mtkView: self)
        self.delegate = self
        self.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0) // When RGB are pre-multipled by alpha, any RGB component that is > the alpha component is undefined through the hardware’s blending.
    }
    
    private func createTiles() {
        self.patternRenderer.tilesToRender = []
        
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        let numOfTiles: Int = Int(ceil(self.diagonalOfDrawableTexture / width)) + 1 // use the diagonal length to make sure the tiles reach the corners whatever the orientation
        var nextTranslation = self.diagonalOfDrawableTexture / 2.0
        let translationStep = width
        for _ in 0..<numOfTiles {
            let newTile = MetalTile()
            newTile.translation = nextTranslation
            self.patternRenderer.tilesToRender.append(newTile) // TODO: should I reserve array capacity?
            nextTranslation -= translationStep
        }
        self.updateTiles()
    }
    
    private func updateTiles() {
        for t in self.patternRenderer.tilesToRender {
            t.length = self.diagonalOfDrawableTexture
            t.width = self.blackWidthInPixel
            t.orientation = self.directionInRad
        }
    }
    
    private func translateTiles() { // always move from negative towards positive
        let tileCount = self.patternRenderer.tilesToRender.count
        // translate
        for i in (0 ..< tileCount).reversed() {
            let tile = self.patternRenderer.tilesToRender[i]
            tile.translation += self.speedInPixel
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
}

extension MetalPatternView: MTKViewDelegate {
    func draw(in view: MTKView) {
        self.translateTiles()
        self.updateTiles()
        self.patternRenderer.draw(in: view, of: self.viewportSize)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize = size // cache for performance
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.pattern = pattern
        self.setUpMetal()
        self.createTiles()
        self.backgroundColor = UIColor.clear
        
    }
    
    func updatePattern(newPattern: Pattern) {
        self.pattern = newPattern
        self.updateTiles()
    }
    
    func pauseAnimations() {
        print("TODO: pauseRendering")
    }
}

