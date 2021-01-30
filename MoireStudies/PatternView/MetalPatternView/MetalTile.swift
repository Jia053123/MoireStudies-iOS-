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
    static let defaultVertices: [packed_float2] = [[10.0, 250.0],
                                                   [10.0, -250.0],
                                                   [-10.0, 250.0],
                                                   [-10.0, -250.0]]
    private var _vertexCount: Int = MetalTile.defaultVertices.count
    var vertexCount: Int {get {return _vertexCount}}
    
    func calcVertexAt(index: Int) -> packed_float2 {
        return MetalTile.defaultVertices[index] + self.translation // perform translation
    }
}
