//
//  ShaderConstants.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-28.
//

#ifndef ShaderConstants_h
#define ShaderConstants_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match Metal API buffer set calls.
typedef enum VertexInputIndex
{
    VertexInputIndexVertices     = 0,
    VertexInputIndexViewportSize = 1,
} VertexInputIndex;

#endif /* ShaderConstants_h */
