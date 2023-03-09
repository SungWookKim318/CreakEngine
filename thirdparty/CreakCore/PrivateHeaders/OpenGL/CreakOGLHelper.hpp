//
//  CreakOGLHelper.hpp
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/02.
//

#pragma once

#include "CreakAppleFlags.h"

#include <string>
template <GLenum glEnum>
struct CreakGLEnumValue {
    constexpr static GLenum val = glEnum;
    constexpr static char* str = CreakGLEnumValue<glEnum>::str;
};

#include "../source/CreakOGLHelper.cpp"
