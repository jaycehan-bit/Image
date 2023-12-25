//
//  JCProgramProvider.m
//  JCImage
//
//  Created by 智杰韩 on 2023/12/21.
//

#import <OpenGLES/ES3/gl.h>
#import "JCProgramProvider.h"

static char *COMMON_VERTEX_SHADER =
      "attribute vec4 position;                   \n"
      "attribute vec2 texcoord;                   \n"
      "varying vec2 v_texcoord;                   \n"
      "                                            \n"
      "void main(void)                              \n"
      "{                                              \n"
      "   gl_Position = position;                 \n"
      "   v_texcoord = texcoord;                  \n"
      "}                                              \n";

static char* COMMON_FRAG_SHADER =
      "precision highp float;                                       \n"
      "varying highp vec2 v_texcoord;                               \n"
      "uniform sampler2D texSampler;                                \n"
      "                                                               \n"
      "void main() {                                                 \n"
      "    gl_FragColor = texture2D(texSampler, v_texcoord);      \n"
      "}                                                                                                                                       \n";

@implementation JCProgramProvider

+ (void)shader:(GLuint *)shader type:(GLenum)type filePath:(NSString *)filePath {
    *shader = glCreateShader(type);
    NSString *shaderContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    const char *content = [shaderContent UTF8String];
    glShaderSource(*shader, 1, &content, NULL);
    glCompileShader(*shader);
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == GL_FALSE) {
        char error_msg[512];
        glGetShaderInfoLog(*shader, sizeof(error_msg), NULL, error_msg);
        NSLog(@"%@", [NSString stringWithUTF8String:error_msg]);
    }
}

+ (void)program:(GLuint *)program vertexShader:(GLuint)vertexShader fragSharder:(GLuint)fragShader {
    *program = glCreateProgram();
    if (vertexShader) {
        glAttachShader(*program, vertexShader);
    }
    if (fragShader) {
        glAttachShader(*program, fragShader);
    }
    GLint status;
    glGetProgramiv(*program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        char message[512];
        glGetProgramInfoLog(*program, sizeof(message), NULL, message);
        NSLog(@"%@", [NSString stringWithUTF8String:message]);
    }
}

@end
