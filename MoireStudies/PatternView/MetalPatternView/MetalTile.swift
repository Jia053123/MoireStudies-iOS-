//
//  MetalTile.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-28.
//

import Foundation
import MetalKit

class MetalTile: NSObject {
    var translation: packed_float2 = [0.0, 0.0]
    var length: Float = 2048
    private var halfLength: Float {
        get {return self.length / 2}
    }
    static let defaultVertices: [packed_float2] = [[1.0, 10.0],
                                                   [1.0, -10.0],
                                                   [-1.0, 10.0],
                                                   [-1.0, -10.0]]
    private var _vertexCount: Int = MetalTile.defaultVertices.count
    var vertexCount: Int {get {return _vertexCount}}
    
    func calcVertexAt(index: Int) -> packed_float2 {
        var vertex: packed_float2
        vertex = MetalTile.defaultVertices[index]
        vertex.x *= self.halfLength // set length potentially to fit the screen
        vertex += self.translation // perform translation
        return vertex
    }
}
