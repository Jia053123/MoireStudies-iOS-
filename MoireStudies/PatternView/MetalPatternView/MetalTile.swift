//
//  MetalTile.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-28.
//

import Foundation
import MetalKit

class MetalTile: NSObject {
    var length: Float = 2048 // 13 inch iPad pro 2020 resolution
    private var halfLength: Float {get {return self.length / 2.0}}
    var width: Float = 20.0
    private var halfWidth: Float {get {return self.width / 2.0}}
    var orientation: Float = 0.0
    var translation: packed_float2 = [0.0, 0.0]
    
    static let defaultVertices: [packed_float2]
        = [[1.0, 1.0], [1.0, -1.0], [-1.0, 1.0], [-1.0, -1.0]]
    
    private var _vertexCount: Int = MetalTile.defaultVertices.count
    var vertexCount: Int {get {return _vertexCount}}
    
    static func makeRotationMatrix(angleRad: Float) -> float2x2 {
        return float2x2([[cos(angleRad), sin(angleRad)],
                         [-1 * sin(angleRad), cos(angleRad)]])
    }
    
    func calcVertexAt(index: Int) -> packed_float2 {
        var vertex: packed_float2
        vertex = MetalTile.defaultVertices[index]
        vertex.x = vertex.x * self.halfLength // stretch to fit the screen
        vertex.y = vertex.y * self.halfWidth // set the width of the strip
        vertex = vertex + self.translation // perform translation
        vertex = vertex * MetalTile.makeRotationMatrix(angleRad: self.orientation)
        return vertex
    }
}
