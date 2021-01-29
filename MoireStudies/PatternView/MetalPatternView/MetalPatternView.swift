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
    var vertexBuffer: MTLBuffer!
    var timer: CADisplayLink!
    var renderer: MetalPatternRenderer!
    
    private func setUpMetal() {
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {return}
        self.renderer = MetalPatternRenderer()
        self.renderer.initWithMetalKitView(mtkView: self)
        // Initialize our renderer with the view size
        self.renderer.mtkView(self, drawableSizeWillChange: self.drawableSize)
        self.delegate = renderer
        self.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 0.0)
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.backgroundColor = UIColor.clear
        self.setUpMetal()
    }
    
    func updatePattern(newPattern: Pattern) {
        print("TODO: updatePattern")
    }
    
    func pauseAnimations() {
        print("TODO: pauseAnimations")
    }
}

