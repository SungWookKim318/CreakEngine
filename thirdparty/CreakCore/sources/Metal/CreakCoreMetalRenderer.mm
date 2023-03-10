//
//  CreakCoreMetalRenderer.mm
//  CreakCore
//
//  Created by SungWook Kim on 2023/03/10.
//

#import <Foundation/Foundation.h>
#import "CreakCoreMetalRenderer.h"

#import <CoreVideo/CoreVideo.h>
#import <MetalKit/MetalKit.h>

namespace TestItem {
    constexpr float vertices[] = {
        0.5f, 0.5f, 0.0f, // top right
        0.5f, -0.5f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f, // bottom left
        -0.5f, 0.5f, 0.0f // top left
    };
    constexpr unsigned short indices[] = {
        // note that we start from 0!
        0, 1, 3, // first Triangle
        1, 2, 3 // second Triangle
    };
}

@implementation CreakCoreMetalRenderer
id<MTLCommandQueue> _queue;
id<MTLLibrary> _defaultLibrary;
id<MTLRenderPipelineState> _renderPipeState;
id<MTLBuffer> _testTriangleVertex;
id<MTLBuffer> _testTriangleIndices;
//CVDisplayLinkRef* _displayLink;


- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view size:(CGSize)size
{
    self = [super init];
    if(self)
    {
        [self setupWithDevice:view.device];
    }
    return self;
}

- (void)setupWithDevice:(id<MTLDevice>)device{
    if(_defaultLibrary == nil) {
//        _defaultLibrary = [device newDefaultLibrary];
        auto path = [[NSBundle bundleForClass:self.class] pathForResource:@"default" ofType:@"metallib"];
        NSError* error;
        _defaultLibrary = [device newLibraryWithFile:path error: &error];
    }
    auto vertexFunction = [_defaultLibrary newFunctionWithName: @"basic_vertex"];
    auto fragFunction = [_defaultLibrary newFunctionWithName:@"basic_fragment"];
    
    // -- setup Render Pipe line state
    MTLRenderPipelineDescriptor* pipelineStateDesc = [[MTLRenderPipelineDescriptor alloc] init];
    [pipelineStateDesc setVertexFunction: vertexFunction];
    [pipelineStateDesc setFragmentFunction: fragFunction];
    pipelineStateDesc.colorAttachments[0].pixelFormat = MTLPixelFormatRGBA16Float;
    
    NSError* error;
    _renderPipeState = [device newRenderPipelineStateWithDescriptor:pipelineStateDesc error:&error];
    // make triagle
    _testTriangleVertex = [device newBufferWithBytes:TestItem::vertices
                                              length:sizeof(TestItem::vertices)
                                             options: MTLResourceStorageModeManaged];
    _testTriangleIndices = [device newBufferWithBytes:TestItem::indices
                                               length:sizeof(TestItem::indices)
                                              options: MTLResourceStorageModeManaged];
}

-(void)renderWithMetalView:(MTKView*) view
{
    CAMetalLayer* metalLayer = (CAMetalLayer*)[view layer];
    if(metalLayer == nil)
    {
        NSLog(@"error, fail to get metalLayer");
        return;
    }
    id<MTLCommandBuffer> buffer = [_queue commandBuffer];
    
    MTLRenderPassDescriptor* renderDesc = view.currentRenderPassDescriptor;
    if (renderDesc == nil)
    {
        NSLog(@"error, fail to get renderDesc");
//        renderDesc.colorAttachments[0]
        return;
    }
    renderDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.1, 0.2, 1.0);
    id<MTLRenderCommandEncoder> renderEnc = [buffer renderCommandEncoderWithDescriptor:renderDesc];
    if(renderEnc == nil) {
        NSLog(@"error, fail to get renderEnc");
        return;
    }
    [renderEnc setRenderPipelineState:_renderPipeState];
    [renderEnc setVertexBuffer:_testTriangleVertex offset:0 atIndex:0];
    [renderEnc drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:6 indexType:MTLIndexTypeUInt16 indexBuffer:_testTriangleIndices indexBufferOffset:0];
    [renderEnc endEncoding];
    
    id<MTLDrawable> nextDrawable = [metalLayer nextDrawable];
    if(nextDrawable == nil)
    {
        NSLog(@"error, fail to get nextDrawable");
        return;
    }
    [buffer presentDrawable: nextDrawable];
    [buffer commit];
    
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    [self renderWithMetalView:view];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    [self renderWithMetalView:view];
    
}
@end
