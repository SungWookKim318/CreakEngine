//
//  CreakOGLRenderer.hpp
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/05.
//
#pragma once

#include <memory>
#include <optional>

namespace Creak {
class CreakOGLRenderer {
public:
    CreakOGLRenderer(std::optional<unsigned> outputFrameBuffer);
    virtual ~CreakOGLRenderer();

public:
    void setup();
    void resize(unsigned width, unsigned height);
    void render();

    bool createTestShader(const char* const vertexSource, const char* const fragmentSource);

private:
    std::optional<unsigned> m_outputFrameBuffer;
    std::optional<unsigned> m_defaultShaderProgram;
    std::optional<unsigned> m_vertexArrayBuffer;
    std::optional<unsigned> m_vertexBuffer;
    std::optional<unsigned> m_elementBuffer;
};
} // namespace Creak
