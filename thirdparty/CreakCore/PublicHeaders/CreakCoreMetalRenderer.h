//
//  CreakCoreMetalRenderer.h
//  CreakCore
//
//  Created by SungWook Kim on 2023/03/10.
//

#ifndef CreakCoreMetalRenderer_h
#define CreakCoreMetalRenderer_h

#import <MetalKit/MetalKit.h>

@interface CreakCoreMetalRenderer: NSObject<MTKViewDelegate>
- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view size:(CGSize)size;
@end

#endif /* CreakCoreMetalRenderer_h */
