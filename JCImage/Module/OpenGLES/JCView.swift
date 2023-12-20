//
//  JCView.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/25.
//

import UIKit

class JCView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.35)
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(imageView)
//        imageView.image = UIImage.init(named: "泡面")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageView.frame = CGRect(x: 100, y: 150, width: self.bounds.size.width - 200, height: self.bounds.size.width - 200)
    }
}


class JCEAGLView: UIView {
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layer: CAEAGLLayer = self.layer as! CAEAGLLayer
        layer.isOpaque = true
        layer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                        kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGB565,]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configBuffer() -> Bool {
        let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
        EAGLContext.setCurrent(context)
        // 创建帧缓冲区
        var framebuffer = GLuint()
        glGenFramebuffers(1, &framebuffer)
        // 创建绘制缓冲区
        var renderbuffer = GLuint()
        glGenRenderbuffers(1, &renderbuffer)
        // 绑定帧缓冲区到渲染管线
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer)
        // 绑定渲染缓冲区到渲染管线
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderbuffer)
        // 为绘制缓冲区分配存储区（使用layer的绘制存储区）
        context?.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.layer as? EAGLDrawable)
        // 获取绘制缓冲区的宽高
        var backingWidth = GLint()
        var backingHeight = GLint()
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &backingWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &backingHeight)
        // 绑定绘制缓冲区到帧缓冲区
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), renderbuffer)
        
        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
        if (status == GL_FRAMEBUFFER_COMPLETE) {
//            context!.presentRenderbuffer(Int(GL_RENDERBUFFER))
            return true
        } else {
            // 配置失败
            return false
        }
    }
}
