//
//  JCPlayerRenderView.m
//  JCImage
//
//  Created by jaycehan on 2024/2/5.
//

#import <OpenGLES/ES3/gl.h>
#import "JCPlayerRenderView.h"
#import "JCProgramArena.h"
#import "JCProgramProvider.h"

static const GLfloat JCPlayerImageVertices[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
};

static const GLfloat JCPlayerTextureCoordinates[] = {
    0.0f, 1.0f,
    1.0f, 1.0f,
    0.0f, 0.0f,
    1.0f, 0.0f,
};

@interface JCPlayerRenderView ()

@property (nonatomic, strong) NSOperationQueue *renderQueue;

@property (nonatomic, strong) EAGLContext *EAGLContext;

@property (nonatomic, assign) GLuint program;

@property (nonatomic, assign) int renderWidth;

@property (nonatomic, assign) int renderHeight;

@property (nonatomic, strong) JCProgramArena *programProvider;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation JCPlayerRenderView

+ (Class)layerClass {
    return CAEAGLLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.backgroundColor = UIColor.blackColor.CGColor;
    layer.opaque = YES;
    layer.drawableProperties = @{
        kEAGLDrawablePropertyRetainedBacking : @(NO),
        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
    };
    return self;
}

#pragma mark - Render

- (void)renderVideoFrame:(id<JCVideoFrame>)videoFrame {
    if (!videoFrame) {
        return;
    }
    [EAGLContext setCurrentContext:self.EAGLContext];
    [self configRenderContext];
    [self compileProgramIfNeeded];
    
//    UIImage *image = [UIImage imageNamed:videoFrame.imageName];
//    UIImage *image = nil;
//    GLuint textureID = [self generateTextureForImage:image];
    GLuint textureID = [self.class generateTextureForVideoFrame:videoFrame];
    CGFloat height = videoFrame.height / videoFrame.width * self.renderWidth;
    glViewport(0, 0, self.renderWidth, height);
    
    glClearColor(0.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    
    int position = glGetAttribLocation(self.program, "position");
    int texcoord = glGetAttribLocation(self.program, "texcoord");
    int textureLocation = glGetUniformLocation(self.program, "texSampler");
    
    glVertexAttribPointer(position, 2, GL_FLOAT, 0, 0, JCPlayerImageVertices);
    glEnableVertexAttribArray(position);
    glVertexAttribPointer(texcoord, 2, GL_FLOAT, 0, 0, JCPlayerTextureCoordinates);
    glEnableVertexAttribArray(texcoord);
    
    glActiveTexture(GL_TEXTURE0);
    glUniform1i(textureLocation, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [self.EAGLContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - Texture

- (GLuint)generateTextureForImage:(UIImage *)image {
    if (image == NULL) {
        return 0;
    }
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    uint8_t *pixel = (uint8_t *)CFDataGetBytePtr(dataRef);
    
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)image.size.width, (GLsizei)image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixel);
    glBindTexture(GL_TEXTURE_2D, 0);
    if (textureID == 0) {
        NSLog(@"❌❌❌ Fail to gen texture");
    } else {
        NSLog(@"✅✅✅ Texture gen success");
    }
    return textureID;
}

+ (GLuint)generateTextureForVideoFrame:(id<JCVideoFrame>)videoFrame {
    if (videoFrame.data == NULL) {
//        return 0;
    }
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)videoFrame.width, (GLsizei)videoFrame.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, videoFrame.avFrame->data);
    glBindTexture(GL_TEXTURE_2D, 0);
    if (textureID == 0) {
        NSLog(@"❌❌❌ Fail to gen texture");
    } else {
        NSLog(@"✅✅✅ Texture gen success");
    }
    return textureID;
}

#pragma mark - RenderBuffer

- (void)configRenderContext {
    static GLuint framebuffers;
    static GLuint renderbuffers;
    
    glDeleteFramebuffers(1, &framebuffers);
    glDeleteRenderbuffers(1, &renderbuffers);
    
    glGenFramebuffers(1, &framebuffers);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffers);
    
    glGenRenderbuffers(1, &renderbuffers);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffers);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffers);
    
    [self.EAGLContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_renderWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_renderHeight);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"✅✅✅ Framebuffer config success");
    } else {
        GLenum glError = glGetError();
        NSLog(@"❌❌❌ Fail to config framebuffer with error:%x", glError);
    }
}

- (void)compileProgramIfNeeded {
    if (self.program != 0) {
        return;
    }
    GLuint vertexShader;
    [JCProgramProvider shader:&vertexShader type:GL_VERTEX_SHADER filePath:[NSBundle.mainBundle pathForResource:@"VertexShader" ofType:@"vsh"]];
    GLuint fragShader;
    [JCProgramProvider shader:&fragShader type:GL_FRAGMENT_SHADER filePath:[NSBundle.mainBundle pathForResource:@"FragShader" ofType:@"fsh"]];

    [JCProgramProvider program:&_program vertexShader:vertexShader fragSharder:fragShader];

    glLinkProgram(self.program);
    glDeleteShader(vertexShader);
    glDeleteShader(fragShader);

    GLint status;
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE) {
        NSLog(@"❌❌❌ Fail to compile program");
    } else {
        NSLog(@"✅✅✅ Program complie success");
        glUseProgram(self.program);
    }
}

#pragma mark - Initialize

- (NSOperationQueue *)renderQueue {
    if (!_renderQueue) {
        _renderQueue = [[NSOperationQueue alloc] init];
        _renderQueue.maxConcurrentOperationCount = 1;
    }
    return _renderQueue;
}

- (JCProgramArena *)programProvider {
    if (!_programProvider) {
        _programProvider = [[JCProgramArena alloc] init];
    }
    return _programProvider;
}

- (EAGLContext *)EAGLContext {
    if (!_EAGLContext) {
        _EAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    }
    return _EAGLContext;
}

@end
