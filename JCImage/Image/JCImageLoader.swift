//
//  JCImageLoader.swift
//  JCImage
//
//  Created by jaycehan on 2023/10/28.
//

import UIKit

class JCImageLoader: NSObject {
    class func image(name: String, downSampling: Bool, size: CGSize) -> UIImage? {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else{
            print("Error image URL for name:%@", name)
            return nil
        }
        print("ImagePath:%@", path)
        // 是否缓存解码后的图片缓存
        let imageSourceptions = [kCGImageSourceShouldCache : false] as CFDictionary
        
        var imageURL: URL?
        if #available(iOS 16.0, *) {
            imageURL = URL.init(filePath: path)
        } else {
            imageURL = URL.init(fileURLWithPath: path)
        }
        guard let imageSource = CGImageSourceCreateWithURL(imageURL! as CFURL, imageSourceptions) else {
            print("Load image source failed:%@", name)
            return nil
        }
        let downSamplingOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,  // 是否从完整图片创建缩略图
                                           kCGImageSourceShouldCacheImmediately: true,  // 是否在图片创建时进行解码和缓存
                                     kCGImageSourceCreateThumbnailWithTransform: true,  // 是否根据完整图像的方向和像素长宽比旋转和缩放缩略图
                                            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),  // 指定缩略图的最大宽度和高度
                                 kCGImageSourceCreateThumbnailFromImageIfAbsent: true,  // 图片源文件不存在缩略图时自动为图像创建缩略图
        ] as CFDictionary
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSamplingOptions) else {
            print("Create thumbnail failed:%@", name)
            return nil
        }
        return UIImage(cgImage: downSampledImage)
    }
}

