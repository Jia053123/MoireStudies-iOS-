//
//  MetalPatternRenderer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-27.
//

import Foundation
import MetalKit

class MetalPatternRenderer: NSObject {
    var device: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var viewportSize: packed_float2 = [0.0, 0.0]
    var vertexBuffer: MTLBuffer!
    var tile: MetalTile = MetalTile()
    
    func initWithMetalKitView(mtkView: MTKView) {
        self.device = mtkView.device
        let defaultLibrary = self.device!.makeDefaultLibrary()! // compliles all the .metal files
        let fragmentFunction = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexFunction = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat // pixel format for the output buffer
        self.pipelineState = try! self.device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        self.commandQueue = self.device!.makeCommandQueue()
        
        let dataSize = self.tile.vertexCount * MemoryLayout.size(ofValue: self.tile.vertices[0])
        vertexBuffer = device.makeBuffer(bytes: self.tile.vertices, length: dataSize, options: [])
//        vertexBuffer = device.makeBuffer(length: dataSize, options: MTLResourceOptions.storageModeShared)
    }
    
    func updateTiles() {
        let speed: Float = 1
        tile.position.x += speed
        
        let vBufferContents = vertexBuffer.contents().bindMemory(to: packed_float2.self, capacity: vertexBuffer.length / MemoryLayout.size(ofValue: self.tile.vertices[0]))
        for i in 0..<tile.vertexCount {
            vBufferContents[i] = tile.vertices[i] + tile.position
        }
    }
}

extension MetalPatternRenderer: MTKViewDelegate {
    /// Called whenever the view needs to render a frame.
    func draw(in view: MTKView) {
        // setup buffers before this
        self.updateTiles()
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        commandBuffer.label = "MyCommand"
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.label = "MyRenderEncoder"
        renderEncoder.setViewport(MTLViewport.init(originX: 0.0, originY: 0.0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: 0.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(self.pipelineState)
        renderEncoder.setVertexBuffer(self.vertexBuffer,
                                      offset: 0,
                                      index: Int(VertexInputIndexVertices.rawValue))
        // don't need to use a buffer here because the data size is small
        renderEncoder.setVertexBytes(&self.viewportSize,
                                     length: MemoryLayout.size(ofValue:self.viewportSize),
                                     index: Int(VertexInputIndexViewportSize.rawValue))
        renderEncoder.drawPrimitives(type: MTLPrimitiveType.triangleStrip,
                                     vertexStart: 0,
                                     vertexCount: self.tile.vertexCount)
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    /// Called whenever view changes orientation or is resized
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize.x = Float(size.width)
        self.viewportSize.y = Float(size.height)
    }
}
