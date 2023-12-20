//
//  JCGLViewController.swift
//  JCImage
//
//  Created by jaycehan on 2023/11/28.
//

import UIKit

class JCGLViewController: UIViewController {
    
    lazy var EAGLView: JCEAGLView = {
        return JCEAGLView.init(frame: CGRect.zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(EAGLView)
        EAGLView.frame = view.bounds
        var result = EAGLView.configBuffer()
        print(result)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        EAGLView.frame = view.bounds
    }
    
    
    private func renderImage() {
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
    }
}

