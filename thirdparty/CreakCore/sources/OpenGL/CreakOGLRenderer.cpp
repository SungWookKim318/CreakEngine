//
//  CreakOGLRenderer.cpp
//  CreakInitial
//
//  Created by 김성욱 on 2022/09/05.
//

#include <CreakOGLRenderer.hpp>
#include <CreakFlags.h>
#include <CreakOpenGLFlags.h>
#include <iostream>
namespace Creak {
namespace ShaderHelper {
    constexpr unsigned sizeOfInfo = 512;
    static char info[sizeOfInfo];
    std::optional<GLuint> compileShader(const GLenum type, const char* const source)
    {
        GLuint shader = glCreateShader(type);
        glShaderSource(shader, 1, &source, NULL);
        glCompileShader(shader);
        int isSuccess;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &isSuccess);
        if (!isSuccess) {
            glGetShaderInfoLog(shader, sizeOfInfo, NULL, info);
            std::cerr << "[FAIL][Compile Shader] " << info;
            glDeleteShader(shader);
            return {};
        }
        return shader;
    }
} // namespace ShaderHelper
namespace BufferHelepr {
    constexpr float vertices[] = {
        0.5f, 0.5f, 0.0f, // top right
        0.5f, -0.5f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f, // bottom left
        -0.5f, 0.5f, 0.0f // top left
    };
    constexpr unsigned int indices[] = {
        // note that we start from 0!
        0, 1, 3, // first Triangle
        1, 2, 3 // second Triangle
    };
}
} // namespace Creak

namespace Creak {
CreakOGLRenderer::CreakOGLRenderer(std::optional<unsigned> outputFrameBuffer)
    : m_outputFrameBuffer(outputFrameBuffer)
    , m_defaultShaderProgram(std::nullopt)
    , m_vertexArrayBuffer(std::nullopt)
    , m_vertexBuffer(std::nullopt)
    , m_elementBuffer(std::nullopt)
{
}

CreakOGLRenderer::~CreakOGLRenderer()
{
    if (m_defaultShaderProgram.has_value()) {
        glDeleteProgram(static_cast<GLuint>(m_defaultShaderProgram.value()));
    }
    if (m_vertexArrayBuffer.has_value()) {
        auto arrayBuffferObj = static_cast<GLuint>(m_vertexArrayBuffer.value());
        glDeleteVertexArrays(1, &arrayBuffferObj);
    }
    if (m_vertexBuffer.has_value()) {
        auto vertexBufferObj = static_cast<GLuint>(m_vertexBuffer.value());
        glDeleteBuffers(1, &vertexBufferObj);
    }
    if (m_elementBuffer.has_value()) {
        auto elementBuffer = static_cast<GLuint>(m_elementBuffer.value());
        glDeleteBuffers(1, &elementBuffer);
    }

    m_outputFrameBuffer.reset();
    m_defaultShaderProgram.reset();
    m_vertexArrayBuffer.reset();
    m_vertexBuffer.reset();
    m_elementBuffer.reset();
}

void CreakOGLRenderer::setup()
{
    GLuint vertexBuffer, vertexArrayObj, elementBuffer;
    glGenVertexArrays(1, &vertexArrayObj);
    glGenBuffers(1, &vertexBuffer);
    glGenBuffers(1, &elementBuffer);

    glBindVertexArray(vertexArrayObj);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BufferHelepr::vertices), BufferHelepr::vertices, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, elementBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(BufferHelepr::indices), BufferHelepr::indices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    m_vertexBuffer = vertexBuffer;
    m_vertexArrayBuffer = vertexArrayObj;
    m_elementBuffer = elementBuffer;
}

void CreakOGLRenderer::resize(unsigned int width, unsigned int height)
{
    glViewport(0, 0, width, height);
}

void CreakOGLRenderer::render()
{
    if (m_outputFrameBuffer) {
        glBindFramebuffer(GL_FRAMEBUFFER, m_outputFrameBuffer.value());
    } else {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
    }

    glClearColor(0.2, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    if (m_defaultShaderProgram) {
        glUseProgram(m_defaultShaderProgram.value());
    }
    if (m_vertexArrayBuffer) {
        glBindVertexArray(m_vertexArrayBuffer.value());
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    }
}

bool CreakOGLRenderer::createTestShader(const char* const vertexSource, const char* const fragmentSource)
{
    GLuint vertexShader;
    if (auto shader = ShaderHelper::compileShader(GL_VERTEX_SHADER, vertexSource); shader) {
        vertexShader = shader.value();
    } else {
        return false;
    }

    GLuint fragmentShader;
    if (auto shader = ShaderHelper::compileShader(GL_FRAGMENT_SHADER, fragmentSource); shader) {
        fragmentShader = shader.value();
    } else {
        return false;
    }

    unsigned program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    glLinkProgram(program);

    GLint success;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(program, ShaderHelper::sizeOfInfo, NULL, ShaderHelper::info);
        std::cerr << "[FAIL][Linking Shader] " << ShaderHelper::sizeOfInfo;
        glDeleteProgram(program);
        return false;
    }
    m_defaultShaderProgram = program;
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return true;
}
} // namespace Creak
