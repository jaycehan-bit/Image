//
//  JCView.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/25.
//

import UIKit
import OpenGLES.ES3

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
    
    public func renderImage() {
        // 创建一个纹理对象
        var texture_id: GLuint = GLuint()
        glGenTextures(1, &texture_id)
        // 绑定句柄
        glBindTexture(GLenum(GL_TEXTURE_2D), texture_id)
        // 设置过滤方式（缩放规则）为双线性过滤
        // GL_LINEAR（双线性过滤）：四个相邻的纹理元素之间使用线性插值
        // GL_NEAREST（最邻近过滤）：每个片段选择最近的纹理元素填充
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        // 设置超出坐标轴的纹理处理规则
        // GL_CLAMP_TO_EDGE：超出1的部分使用1这个点的像素来填充，小于0的部分使用0点来填充
        // GL_REPEAT：超出1的部分会从0再渲染一遍
        // GL_MIRRORED_REPEAT：镜像平铺
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glActiveTexture(GLenum(GL_TEXTURE0))
        
        // 纹理上传和下载
        // TODO:RGBA数组
        var pixels: [UInt32] = Array()
        // 将图片的RGBA数据上传到纹理
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, 100, 100, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), pixels)
        
        // 坐标系转换
        // OpenGL中X轴从左到右为[-1，1]，Y轴从下到上是[-1, 1]，中心点为[0, 0]
        // TODO
        
        let vertexShader: GLuint = shader(GL_VERTEX_SHADER, JCEAGLView.VertexShaderFilePath())
        let fragShader: GLuint = shader(GL_VERTEX_SHADER, JCEAGLView.FragShaderFilePath())
        let program: GLuint = program(vertexShader, fragShader)
        glViewport(0, 0, 100, 100)
    }
}


extension JCEAGLView {
    
    static func VertexShaderFilePath() -> String {
        return Bundle.main.path(forResource: "VertexShader", ofType: "vsh")
    }
    
    static func FragShaderFilePath() -> String {
        return Bundle.main.path(forResource: "FragShader", ofType: "fsh")
    }
}
