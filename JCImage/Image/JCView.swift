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
