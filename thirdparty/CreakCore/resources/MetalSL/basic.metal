//
//  basic.metal
//  CreakCore
//
//  Created by SungWook Kim on 2023/03/10.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 basic_vertex(const device packed_float3* vertexArray [[buffer(0)]],
                           unsigned vid [[vertex_id]])
{
    return float4(vertexArray[vid], 1.0);
}

fragment half4 basic_fragment() {
    return half4(1.0, 0.5, 0.2, 1.0);
}
