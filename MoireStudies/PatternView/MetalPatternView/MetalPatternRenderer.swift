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
    
    private var inFlightSemaphore: DispatchSemaphore!
    private let MaxFramesInFlight: Int = 3
    private var vertexBuffers: Array<MTLBuffer> = []
    private var currentBufferIndex: Int = 0
    
    private var viewportSize: packed_float2 = [0.0, 0.0]
    var tilesToRender: Array<MetalTile>! // sorted: the first element always has the most positive translation value
    private var totalVertexCount: Int {get {return self.tilesToRender.count * self.tilesToRender.first!.vertexCount}}
    
    func initWithMetalKitView(mtkView: MTKView) {
        self.device = mtkView.device
        let defaultLibrary = self.device!.makeDefaultLibrary()!
        let fragmentFunction = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexFunction = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat // pixel format for the output buffer
        self.pipelineState = try! self.device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        self.commandQueue = self.device!.makeCommandQueue()
        
        self.inFlightSemaphore = DispatchSemaphore.init(value: MaxFramesInFlight)
    }

    private func initVertexBuffers() {
        let dataSize = self.totalVertexCount * MemoryLayout.size(ofValue: MetalTile.defaultVertices[0])
        for _ in 0 ..< self.MaxFramesInFlight {
            let vb = device.makeBuffer(length: dataSize, options: [])!
            self.vertexBuffers.append(vb)
        }
    }
    
    func updateBuffer() {
        if self.vertexBuffers.isEmpty {
            self.initVertexBuffers()
        }
        let vertexBuffer = self.vertexBuffers[currentBufferIndex]
        
        let vBufferContents = vertexBuffer.contents().bindMemory(to: packed_float2.self, capacity: vertexBuffer.length / MemoryLayout.size(ofValue: MetalTile.defaultVertices[0]))

        for i in 0 ..< self.tilesToRender.count {
            let t = self.tilesToRender[i]
            for j in 0 ..< t.vertexCount {
                vBufferContents[i*t.vertexCount + j] = t.calcVertexAt(index: j)
            }
        }
    }
    
    /**
     Summary: to be called for each frame to render the tiles
     */
    func draw(in view: MTKView, of viewportSize: CGSize) {
        self.viewportSize.x = Float(viewportSize.width)
        self.viewportSize.y = Float(viewportSize.height)
        
        _ = self.inFlightSemaphore.wait(timeout: .distantFuture)
        self.currentBufferIndex = (self.currentBufferIndex + 1) % MaxFramesInFlight
        self.updateBuffer() // buffers must be setup before this
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        commandBuffer.label = "MyCommand"
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.label = "MyRenderEncoder"
        renderEncoder.setViewport(MTLViewport.init(originX: 0.0, originY: 0.0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: 0.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(self.pipelineState)
        renderEncoder.setVertexBuffer(self.vertexBuffers[currentBufferIndex],
                                      offset: 0,
                                      index: Int(VertexInputIndexVertices.rawValue))
        renderEncoder.setVertexBytes(&self.viewportSize,
                                     length: MemoryLayout.size(ofValue:self.viewportSize),
                                     index: Int(VertexInputIndexViewportSize.rawValue))
        renderEncoder.drawPrimitives(type: MTLPrimitiveType.triangle,
                                     vertexStart: 0,
                                     vertexCount: self.totalVertexCount)
        renderEncoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.addCompletedHandler({_ in self.inFlightSemaphore.signal()})
        
        commandBuffer.commit()
    }
}
