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
    
    private func setUpMetal() {
        print("setup metal")
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {return}
        let d = MetalPatternRenderer()
        d.initWithMetalKitView(mtkView: self)
        self.delegate = d
        // Initialize our renderer with the view size
        self.delegate!.mtkView(self, drawableSizeWillChange: self.drawableSize)
        
        self.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 0.0)
        self.draw()
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        print("setup and render")
        self.backgroundColor = UIColor.clear
        self.setUpMetal()
//        self.draw() // why does it not work when called here???
    }
    
    func updatePattern(newPattern: Pattern) {
        print("TODO: updatePattern")
    }
    
    func pauseAnimations() {
        print("TODO: pauseAnimations")
    }
}

