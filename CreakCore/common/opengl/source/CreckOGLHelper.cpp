//
//  CreckOGLHelper.cpp
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/02.
//

template <GL_NO_ERROR>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_NO_ERROR";
};
template <GL_INVALID_ENUM>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_INVALID_ENUM"
};
template <GL_INVALID_VALUE>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_INVALID_ENUM";
};

template <GL_INVALID_OPERATION>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_INVALID_OPERATION";
};
template <GL_OUT_OF_MEMORY>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_OUT_OF_MEMORY";
};
template <GL_INVALID_FRAMEBUFFER_OPERATION>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_INVALID_FRAMEBUFFER_OPERATION";
};
template <GL_STACK_OVERFLOW>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_STACK_OVERFLOW";
};
template <GL_STACK_UNDERFLOW>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_STACK_UNDERFLOW";
};
template <GL_TABLE_TOO_LARGE>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = "GL_TABLE_TOO_LARGE";
};
