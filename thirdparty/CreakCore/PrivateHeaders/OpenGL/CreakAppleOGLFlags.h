//
//  CreakAppleOGLFlags.h
//  CreakCore
//
//  Created by SungWook Kim on 2023/03/09.
//
#pragma once

#include <CreakAppleFlags.h>

#if TARGET_OS_OSX == 1
#define CREAK_USE_OGL
#define CREAK_OGL_MAJOR_VERSION 4
#define CREAK_OGL_MINOR_VERSION 1
// IOS
#else // TARGET_OS_OSX != 1
#define CREAK_USE_OGL_ES
#define CREAK_OGL_ES_MAJOR_VERSION 3
#define CREAK_OGL_ES_MINOR_VERSION 0
#endif

