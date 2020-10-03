//
//  LineDrawing.metal
//  MSLExamples
//
//  Created by mani3 on 2020/10/03.
//

#include <metal_stdlib>
using namespace metal;


#include <CoreImage/CoreImage.h>
extern "C" {
  namespace coreimage {

    half4 grayscale(sample_h s) {
      half y = 0.2126 * s.r + 0.7152 * s.g + 0.0722 * s.b;
      return half4(y, y, y, s.a);
    }
    
    half4 difference(sampler_h s, sampler_h t) {
      half4 sc = s.sample(s.coord());
      half4 tc = t.sample(t.coord());
      
      half r = 1 - abs(sc.r - tc.r);
      half g = 1 - abs(sc.g - tc.g);
      half b = 1 - abs(sc.b - tc.b);
      return half4(r, g, b, sc.a);
    }
    
    /// Max pooling: 3 x 3
    half4 max_pooling(sampler_h s) {
      float2 dc = s.coord();
      
      float w = s.size().x;
      float h = s.size().y;
      
      half v1 = s.sample(dc + float2(-1.0 / w, -1.0 / h)).r;
      half v2 = s.sample(dc + float2( 0.0 / w, -1.0 / h)).r;
      half v3 = s.sample(dc + float2( 1.0 / w, -1.0 / h)).r;
      half v4 = s.sample(dc + float2(-1.0 / w,  0.0 / h)).r;
      half v5 = s.sample(dc + float2( 0.0 / w,  0.0 / h)).r;
      half v6 = s.sample(dc + float2( 1.0 / w,  0.0 / h)).r;
      half v7 = s.sample(dc + float2(-1.0 / w,  1.0 / h)).r;
      half v8 = s.sample(dc + float2( 0.0 / w,  1.0 / h)).r;
      half v9 = s.sample(dc + float2( 1.0 / w,  1.0 / h)).r;
      
      half p1 = fmax3(fmax3(v1, v2, v3), fmax3(v4, v5, v6), fmax3(v7, v8, v9));
      return half4(p1, p1, p1, 1);
    }
  }
}
