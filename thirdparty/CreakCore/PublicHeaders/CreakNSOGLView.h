//
//  NSOpenGLView+CreakNSOGLView.h
//  CreakInitial
//
//  Created by 김성욱 on 2022/08/27.
//

#import "CreakAppleFlags.h"
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreakOglNSView : NSOpenGLView {
    /// display link
    CVDisplayLinkRef displayLink;
    /// Retina display 대응 여부
}
@property BOOL useHiDPI;
@end

NS_ASSUME_NONNULL_END
