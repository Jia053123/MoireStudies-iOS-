//
//  ShaderConstants.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-27.
//

import Foundation

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs
// match Metal API buffer set calls.
enum AAPLVertexInputIndex: Int {
    case AAPLVertexInputIndexVertices = 0
    case AAPLVertexInputIndexViewportSize = 1
}
