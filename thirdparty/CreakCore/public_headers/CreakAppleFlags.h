//
//  CreakAppleFlags.h
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/02.
//

#pragma once
#define GL_SILENCE_DEPRECATION
#import <TargetConditionals.h>

#if TARGET_OS_OSX == 1
#define CREAK_USE_OGL
#define CREAK_OGL_MAJOR_VERSION 4
#define CREAK_OGL_MINOR_VERSION 1
#import "CreakOpenGLFlags.h"
// IOS
#else // TARGET_OS_OSX != 1
#define CREAK_USE_OGL_ES
#define CREAK_OGL_ES_MAJOR_VERSION 3
#define CREAK_OGL_ES_MINOR_VERSION 0
#import "CreakOpenGLFlags.h"
#endif
