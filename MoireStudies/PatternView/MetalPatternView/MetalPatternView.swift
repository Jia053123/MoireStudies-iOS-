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
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {return}
        let d = MetalPatternRenderer()
        d.initWithMetalKitView(mtkView: self)
        self.delegate = d
        // Initialize our renderer with the view size
        self.delegate!.mtkView(self, drawableSizeWillChange: self.drawableSize)
        
        self.draw() // is this necessary?
    
//     ***   timer = CADisplayLink(target: self, selector: #selector(loop))
//     ***   timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    private func render() {
//     *** renderPassDescriptor.colorAttachments[0].texture = drawable.texture
//     *** renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadAction.clear
//     *** renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0,
//                                                                            green: 104.0/255.0,
//                                                                            blue: 55.0/255.0,
//                                                                            alpha: 1.0)
    }
    
    @objc private func loop() {
        autoreleasepool {
            self.render()
        }
    }
}

extension MetalPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.backgroundColor = UIColor.clear
        self.setUpMetal()
        self.render()
    }
    
    func updatePattern(newPattern: Pattern) {
        print("TODO: updatePattern")
    }
    
    func pauseAnimations() {
        print("TODO: pauseAnimations")
    }
}
