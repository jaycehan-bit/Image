//
//  JCEAGLView.m
//  JCImage
//
//  Created by jaycehan on 2023/12/24.
//

#import <OpenGLES/ES3/gl.h>
#import "JCEAGLView.h"
#import "JCProgramArena.h"

@interface JCEAGLView ()

@property (nonatomic, strong) dispatch_queue_t renderQueue;

@property (nonatomic, strong) EAGLContext *context;

@property (nonatomic, assign) GLuint frameBuffer;

@property (nonatomic, assign) GLuint renderBuffer;

@property (nonatomic, assign) GLint backingWidth;

@property (nonatomic, assign) GLint backingHeight;

@property (nonatomic, strong) JCProgramArena *programArena;

@end

@implementation JCEAGLView

+ (Class)layerClass {
    return CAEAGLLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
        layer.opaque = YES;
        layer.drawableProperties = @{
            kEAGLDrawablePropertyRetainedBacking: @(NO),
            kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8,
        };
    }
    return self;
}

- (void)dealloc {
    [self.programArena destory];
}

- (void)configRenderBuffer {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.context];
    // 创建帧缓冲区
    glGenFramebuffers(1, &_frameBuffer);
    // 创建绘制缓冲区
    glGenRenderbuffers(1, &_renderBuffer);
    // 绑定帧缓冲区到渲染管线
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 绑定绘制缓冲区到渲染管线
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    // 为绘制缓冲区分配存储器（即使用EAGLLayer的绘制缓冲区）PS:此时需要layer.size
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    // 绑定绘制缓冲区到帧缓冲区
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Buffer config success");
    } else {
        NSLog(@"Buffer config failed");
    }
    GLenum glError = glGetError();
    if (glError == GL_NO_ERROR) {
        NSLog(@"SetupBuffer success");
    } else {
        NSLog(@"SetupBuffer failed:%x", glError);
    }
}

#pragma mark - Interface

- (void)renderImageWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) {
        return;
    }
    CGSize size = image.size;
    dispatch_sync(self.renderQueue, ^{
        [self configRenderBuffer];
        [self.programArena perpare];
    });
    dispatch_async(self.renderQueue, ^{
        [EAGLContext setCurrentContext:self.context];
        CGImageRef imageRef = image.CGImage;
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
        uint8_t *pixel = (uint8_t *)CFDataGetBytePtr(dataRef);
        glViewport(0, 0, self.backingWidth, self.backingHeight);
        [self.programArena renderForFrame:pixel size:size];
        glBindRenderbuffer(GL_RENDERBUFFER, self->_renderBuffer);
        [self.context presentRenderbuffer:GL_RENDERBUFFER];
    });
}

#pragma mark - init

- (JCProgramArena *)programArena {
    if (!_programArena) {
        _programArena = [[JCProgramArena alloc] init];
    }
    return _programArena;
}

- (dispatch_queue_t)renderQueue {
    if (!_renderQueue) {
        _renderQueue = dispatch_queue_create("com.Image.jaycehan.EAGLRenderQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _renderQueue;
}

@end
