//
//  JCProgramProvider.h
//  JCImage
//
//  Created by 智杰韩 on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/gltypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCProgramProvider : NSObject

GLuint sharder(GLenum type, NSString *filePath);

GLuint program(GLuint vertexShader, GLuint fragShader);

@end

NS_ASSUME_NONNULL_END
