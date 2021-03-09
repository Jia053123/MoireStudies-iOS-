//
//  MetalPatternRenderer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-27.
//

import Foundation
import MetalKit

/**
 Summary: responsible for rendering the stripes assigned by MetalPatternView
 */
class MetalPatternRenderer: NSObject {
    private var device: MTLDevice!
    private var renderPassDescriptor: MTLRenderPassDescriptor!
    private var pipelineState: MTLRenderPipelineState!
    private var commandQueue: MTLCommandQueue!
    
    private let MultiSamplingCount: Int = 4
    private var inFlightSemaphore: DispatchSemaphore!
    private let MaxFramesInFlight: Int = 3
    private var vertexBuffers: Array<MTLBuffer> = []
    private var currentBufferIndex: Int = 0
    
    private var viewportSize: packed_float2 = [0.0, 0.0] // unit: pixel
    
    var screenShotSwitch: Bool = false
    var screenShot: MTLTexture?
    
    func initWithMetalLayer(metalLayer: CAMetalLayer, initBufferSizeInBytes: Int) {
        self.device = MTLCreateSystemDefaultDevice()
        metalLayer.device = self.device
        
        self.renderPassDescriptor = MTLRenderPassDescriptor.init()
        self.renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadAction.clear
        self.renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreAction.storeAndMultisampleResolve
        self.renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0.0) // When RGB are pre-multipled by alpha, any RGB component that is > the alpha component is undefined through the hardware’s blending.
        
        let textureDescriptor = MTLTextureDescriptor.init()
        textureDescriptor.sampleCount = self.MultiSamplingCount
        textureDescriptor.pixelFormat = metalLayer.pixelFormat
        textureDescriptor.width = Int(ceil(metalLayer.drawableSize.width))
        textureDescriptor.height = Int(ceil(metalLayer.drawableSize.height))
        textureDescriptor.usage = MTLTextureUsage.renderTarget
        textureDescriptor.textureType = MTLTextureType.type2DMultisample
        textureDescriptor.storageMode = MTLStorageMode.private // can't use memoryless because my iPad is not new enough
        let multiSampleTexture = self.device.makeTexture(descriptor: textureDescriptor) // I don't think I need MaxFramesInFlight# of this becasuse it holds the GPU output which is always behind of CPU
        self.renderPassDescriptor.colorAttachments[0].texture = multiSampleTexture
        
        let defaultLibrary = self.device!.makeDefaultLibrary()!
        let vertexFunction = defaultLibrary.makeFunction(name: "vertexShader")
        let fragmentFunction = defaultLibrary.makeFunction(name: "fragmentShader")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat // pixel format for the output buffer
        pipelineStateDescriptor.vertexBuffers[Int(VertexInputIndexVertices.rawValue)].mutability = MTLMutability.immutable
        pipelineStateDescriptor.sampleCount = self.MultiSamplingCount
        
        self.pipelineState = try! self.device!.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        self.commandQueue = self.device!.makeCommandQueue()
        
        self.initVertexBuffers(dataSize: initBufferSizeInBytes)
        
        self.inFlightSemaphore = DispatchSemaphore.init(value: MaxFramesInFlight)
    }

    private func calcTotalVertexCount(stripes: Array<MetalStripe>)  -> Int{
        return stripes.count * stripes.first!.vertexCount
    }
    
    private func initVertexBuffers(dataSize: Int) {
        self.vertexBuffers = []
        for _ in 0 ..< self.MaxFramesInFlight {
            let vb = device.makeBuffer(length: dataSize, options: [])!
            self.vertexBuffers.append(vb)
        }
    }
    
    private func updateBuffer(stripesToRender: Array<MetalStripe>) {
        precondition(!self.vertexBuffers.isEmpty)
        let vertexBuffer = self.vertexBuffers[currentBufferIndex]
        // make sure the vertex buffer is large enough
        let necessarySize = self.calcTotalVertexCount(stripes: stripesToRender) * MemoryLayout.size(ofValue: MetalStripe.defaultVertices[0])
        if vertexBuffer.length < necessarySize {
            print("MetalPatternRenderer: re-initializing vertex buffer to expand capacity")
            self.initVertexBuffers(dataSize: Int(Double(necessarySize) * 1.25))
        }
        
        let vBufferContents = vertexBuffer.contents().bindMemory(to: packed_float2.self, capacity: vertexBuffer.length / MemoryLayout.size(ofValue: MetalStripe.defaultVertices[0]))

        for i in 0 ..< stripesToRender.count {
            let t = stripesToRender[i]
            for j in 0 ..< t.vertexCount {
                vBufferContents[i*t.vertexCount + j] = t.calcVertexAt(index: j)
            }
        }
    }
    /**
     Summary: to be called for each frame to render the stripes
     */
    func draw(stripesToRender: Array<MetalStripe>, in metalLayer: CAMetalLayer, of viewportSize: CGSize) { // TODO: autorelease pool
        guard !stripesToRender.isEmpty else {return}
        
        self.viewportSize.x = Float(viewportSize.width)
        self.viewportSize.y = Float(viewportSize.height)
        
        _ = self.inFlightSemaphore.wait(timeout: .distantFuture)
        
        self.currentBufferIndex = (self.currentBufferIndex + 1) % MaxFramesInFlight
        self.updateBuffer(stripesToRender: stripesToRender) // buffers must be initialized before this
        
        guard let commandBuffer = self.commandQueue.makeCommandBuffer() else {return}
        commandBuffer.label = "CommandBuffer"
        
        guard let currentDrawable = metalLayer.nextDrawable() else {return}
        self.renderPassDescriptor.colorAttachments[0].resolveTexture = currentDrawable.texture
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: self.renderPassDescriptor)!
        renderEncoder.label = "RenderEncoder"
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
                                     vertexCount: self.calcTotalVertexCount(stripes: stripesToRender))
        renderEncoder.endEncoding()
        
        commandBuffer.present(currentDrawable)
        
        commandBuffer.addCompletedHandler({_ in self.inFlightSemaphore.signal()})
        
        if self.screenShotSwitch {
            print("renderer taking a screen shot")
            self.screenShot = currentDrawable.texture
            self.screenShotSwitch = false
        }

        commandBuffer.commit()
    }
}
