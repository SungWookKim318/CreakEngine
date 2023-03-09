//
//  NSOpenGLView+CreakNSOGLView.m
//  CreakInitial
//
//  Created by 김성욱 on 2022/08/27.
//
#import <Foundation/Foundation.h>

#import <CoreVideo/CoreVideo.h>

#import "CreakNSOGLView.h"
#import "CreakOGLRenderer.hpp"

#include <memory>

@interface CreakOglNSView () {
    // MARK: Private Member Variables
    std::unique_ptr<Creak::CreakOGLRenderer> _renderer;
}
@end

@implementation CreakOglNSView : NSOpenGLView

- (CVReturn)getFrameForTime:(const CVTimeStamp *)outputTime
{
    @autoreleasepool {
    }
    return kCVReturnSuccess;
}

static CVReturn DisplayLinkCallback(CVDisplayLinkRef displayLink,
    const CVTimeStamp *now,
    const CVTimeStamp *outputTime,
    CVOptionFlags flagsIn,
    CVOptionFlags *flagsOut,
    void *displayLinkContext)
{
    if (CreakOglNSView *nsglView = (__bridge CreakOglNSView *)displayLinkContext; nsglView) {
        return [nsglView getFrameForTime:outputTime];
    } else {
        return kCVReturnError;
    }
}
- (void)setupPixelFormat
{
    NSOpenGLPixelFormatAttribute nsglAttrs[] = {
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAOpenGLProfile,
        NSOpenGLProfileVersion4_1Core,
        0
    };

    NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:nsglAttrs];
    if (!pf) {
        NSLog(@"No OpenGL pixel format");
    }
    NSOpenGLContext *glContext = [[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil];

#if DEBUG
    CGLEnable([glContext CGLContextObj], kCGLCECrashOnRemovedFunctions);
#endif

    [self setPixelFormat:pf];
    [self setOpenGLContext:glContext];

    [self setWantsBestResolutionOpenGLSurface:_useHiDPI];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupPixelFormat];
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];

    if ([self pixelFormat] == nil) {
        [self setupPixelFormat];
        return;
    }

    [self setupOpenGL];

    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
    __weak __typeof__(self) weakSelf = self;
    CVDisplayLinkSetOutputHandler(displayLink, ^CVReturn(CVDisplayLinkRef _Nonnull displayLink, const CVTimeStamp *_Nonnull inNow, const CVTimeStamp *_Nonnull inOutputTime, CVOptionFlags flagsIn, CVOptionFlags *_Nonnull flagsOut) {
        return [weakSelf getFrameForTime:inOutputTime];
    });

    CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglpixelFormat = [[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglpixelFormat);

    CVDisplayLinkStart(displayLink);

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(windowWillClose:)
               name:NSWindowWillCloseNotification
             object:[self window]];
}
- (NSString *)loadFileWithBundleFileName:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (BOOL)setupOpenGL
{
    [[self openGLContext] makeCurrentContext];

    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLContextParameterSwapInterval];

    _renderer = std::make_unique<Creak::CreakOGLRenderer>(0);
    _renderer->setup();
    NSBundle *coreBundle = [NSBundle bundleForClass:[self class]];
    NSString *vertexPath = [coreBundle pathForResource:@"basic" ofType:@"vert"];
    NSString *fragPath = [coreBundle pathForResource:@"basic" ofType:@"frag"];
    _renderer->createTestShader([[self loadFileWithBundleFileName:vertexPath] cStringUsingEncoding:NSASCIIStringEncoding], [[self loadFileWithBundleFileName:fragPath] cStringUsingEncoding:NSASCIIStringEncoding]);
    return TRUE;
}

- (void)reshape
{
    [super reshape];

    CGLLockContext([[self openGLContext] CGLContextObj]);

    NSRect pixelRect;
    if (_useHiDPI) {
        pixelRect = [self convertRectToBacking:[self bounds]];
    } else {
        pixelRect = [self bounds];
    }

    //    [_renderer resizeWithWidth:viewRectPixels.size.width
    //                     AndHeight:viewRectPixels.size.height];
    if (_renderer) {
        _renderer->resize(pixelRect.size.width, pixelRect.size.height);
    }
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void)drawRect:(NSRect)rect
{
    [self refreshView];
}

- (void)refreshView
{
    [[self openGLContext] makeCurrentContext];
    CGLLockContext([[self openGLContext] CGLContextObj]);
    _renderer->render();
    CGLFlushDrawable([[self openGLContext] CGLContextObj]);
    CGLUnlockContext([[self openGLContext] CGLContextObj]);
}

- (void)windowWillClose:(NSNotification *)notification
{
    CVDisplayLinkStop(displayLink);
}

- (void)dealloc
{
    _renderer.reset();
    CVDisplayLinkStop(displayLink);
    CVDisplayLinkRelease(displayLink);
}
@end
