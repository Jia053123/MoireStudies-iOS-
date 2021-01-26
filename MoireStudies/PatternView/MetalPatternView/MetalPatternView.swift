//
//  OpenGLPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit
import Metal

class MetalPatternView: UIView {
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    let testVertexData: [Float] = [
        0.0, 1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0
    ]
    
    private func setUpMetal() {
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = MTLPixelFormat.bgra8Unorm //bgra10_xr
        metalLayer.framebufferOnly = true
        metalLayer.frame = self.layer.bounds
        metalLayer.backgroundColor = UIColor.clear.cgColor
        self.layer.addSublayer(metalLayer)
        
        let dataSize = testVertexData.count * MemoryLayout.size(ofValue: testVertexData[0])
        vertexBuffer = device.makeBuffer(bytes: testVertexData, length: dataSize, options: [])
        
        let defaultLibrary = device.makeDefaultLibrary()! // compliles all the .metal files
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm // pixel format for the output buffer
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device.makeCommandQueue()
        
        timer = CADisplayLink(target: self, selector: #selector(loop))
        timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    private func render() {
        guard let drawable = metalLayer.nextDrawable() else {return}
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadAction.clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0,
                                                                            green: 104.0/255.0,
                                                                            blue: 55.0/255.0,
                                                                            alpha: 1.0)
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: MTLPrimitiveType.triangle,
                                      vertexStart: 0,
                                      vertexCount: 3, //
                                      instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
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
