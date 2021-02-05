//
//  MetalPatternViewShader.metal
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-24.
//

#include <metal_stdlib>
#include "ShaderConstants.h"
using namespace metal;

struct RasterizerData {
    // The [[position]] attribute of this member indicates that this value is the clip space position of the vertex when this structure is returned from the vertex function.
    float4 position [[position]]; // cannot use packed_float4 because it's not supported
};

vertex RasterizerData
basic_vertex(unsigned int vertexID [[ vertex_id ]],
             const device packed_float2 *vertices [[ buffer(VertexInputIndexVertices) ]],
             const device packed_float2 *viewportSizePointer [[ buffer(VertexInputIndexViewportSize)]]) {
    RasterizerData out;
    // Index into the array of positions to get the current vertex. The positions are specified in pixel dimensions
    float2 pixelSpacePosition = vertices[vertexID].xy;
    packed_float2 viewportSize = *viewportSizePointer;
    // To convert from positions in pixel space to positions in clip-space, divide the pixel coordinates by half the size of the viewport.
    out.position = float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);

    return out;
}

fragment half4 basic_fragment(RasterizerData inData [[stage_in]]) {
    return half4(0.0, 0.0, 0.0, 1.0); // always in black at least for now
}
