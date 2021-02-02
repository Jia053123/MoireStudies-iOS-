//
//  MetalPatternRenderer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-27.
//

import Foundation
import MetalKit

/**
 Summary: responsible for rendering the tiles assigned by MetalPatternView
 */
class MetalPatternRenderer: NSObject {
    private var device: MTLDevice!
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    private var viewportSize: packed_float2 = [0.0, 0.0]
    private var vertexBuffer: MTLBuffer!
    private var tile: MetalTile = MetalTile()
    var tiles: Array<MetalTile> = []
    var tileSpeed: Float = -1.0
    
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
        
        let dataSize = self.tile.vertexCount * MemoryLayout.size(ofValue: MetalTile.defaultVertices[0])
        vertexBuffer = device.makeBuffer(bytes: MetalTile.defaultVertices, length: dataSize, options: [])
    }
    
    func pauseRendering() {
        print("TODO: pauseRendering")
    }
    
    func resumeRendering() {
        print("TODO: resumeRendering")
    }
}

extension MetalPatternRenderer: MTKViewDelegate {

    func updateTiles() {
        tile.translation.y += self.tileSpeed
        
        let vBufferContents = vertexBuffer.contents().bindMemory(to: packed_float2.self, capacity: vertexBuffer.length / MemoryLayout.size(ofValue: MetalTile.defaultVertices[0]))
        for i in 0..<tile.vertexCount {
            vBufferContents[i] = self.tile.calcVertexAt(index: i)
        }
    }
    
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
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize.x = Float(size.width)
        self.viewportSize.y = Float(size.height)
    }
}
