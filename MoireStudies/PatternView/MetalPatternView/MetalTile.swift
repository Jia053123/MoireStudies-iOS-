//
//  MetalTile.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-28.
//

import Foundation
import MetalKit

class MetalTile: NSObject {
    var position: packed_float2 = [0.0, 0.0]
    let vertices: [packed_float2] = [[150.0, 250.0],
                                     [150.0, -250.0],
                                     [-150.0, 250.0],
                                     [-150.0, -250.0]]
}
