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
    private var tiles: Array<MetalTile>!
    private var diagonalOfDrawableTexture: Float {
        get {return Float(sqrt(pow(self.drawableSize.width, 2) + pow(self.drawableSize.height, 2)))}
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
        // Initialize our renderer with the view size
        self.patternRenderer.mtkView(self, drawableSizeWillChange: self.drawableSize)
        self.delegate = patternRenderer
        self.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 0.0)
    }
    
    private func createTiles() {
        let width = self.blackWidthInPixel + self.whiteWidthInPixel
        let numOfTiles: Int = Int(ceil(self.diagonalOfDrawableTexture / width)) + 1 // use the diagonal length to make sure the tiles reach the corners whatever the orientation
        self.tiles = []
        for _ in 0..<numOfTiles {
            let newTile = MetalTile()
            self.tiles.append(newTile)
        }
        self.updateTiles()
    }
    
    private func updateTiles() {
        for t in self.tiles {
            t.length = self.diagonalOfDrawableTexture
            t.width = self.blackWidthInPixel
            t.orientation = self.directionInRad
            // do the translation
        }
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
        // assign the tiles to the renderer
    }
     
    
    func pauseAnimations() {
        self.patternRenderer.pauseRendering()
    }
}

