//
//  CreakOpenGLFlags.h
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/05.
//

#pragma once
#if defined(CREAK_USE_OGL)
    #define GL_SILENCE_DEPRECATION
    #include <OpenGL/gl3.h>
#elif defined(CREAK_USE_OGL_ES) //&& !CREAK_USE_OGL
    #define GL_SILENCE_DEPRECATION
    #include <OpenGLES/ES3/gl.h>
    #include <OpenGLES/ES3/glext.h>

    #define glBindVertexArray glBindVertexArrayOES
    #define glGenVertexArrays glGenVertexArraysOES
    #define glDeleteVertexArrays glDeleteVertexArraysOES
#else // !CREAK_USE_OGL_ES && !CREAK_USE_OGL
    #warning not setup openGL Versions, if use openGL, maybe happen unprediect behavior(etc. crush, freeze).
#endif // CREAK_USE_OGL

// Convert later Cpp TMP
static inline const char* getGLErrorCString(GLenum glerror)
{
    const char* str;

    switch (glerror) {
    case GL_NO_ERROR:
        str = "GL_NO_ERROR";
        break;

    case GL_INVALID_ENUM:
        str = "GL_INVALID_ENUM";
        break;

    case GL_INVALID_VALUE:
        str = "GL_INVALID_VALUE";
        break;

    case GL_INVALID_OPERATION:
        str = "GL_INVALID_OPERATION";
        break;

#if defined __gl_h_ || defined __gl3_h_
    case GL_OUT_OF_MEMORY:
        str = "GL_OUT_OF_MEMORY";
        break;

    case GL_INVALID_FRAMEBUFFER_OPERATION:
        str = "GL_INVALID_FRAMEBUFFER_OPERATION";
        break;

#endif
#if defined __gl_h_
    case GL_STACK_OVERFLOW:
        str = "GL_STACK_OVERFLOW";
        break;

    case GL_STACK_UNDERFLOW:
        str = "GL_STACK_UNDERFLOW";
        break;

    case GL_TABLE_TOO_LARGE:
        str = "GL_TABLE_TOO_LARGE";
        break;

#endif
    default:
        str = "(ERROR: Unknown Error Enum)";
        break;
    }
    return str;
}
