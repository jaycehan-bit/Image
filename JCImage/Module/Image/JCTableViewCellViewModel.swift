//
//  JCTableViewCellViewModel.swift
//  JCImage
//
//  Created by jaycehan on 2023/10/30.
//

import Foundation
import UIKit

class JCTableViewCellViewModel : NSObject {
    var title: String?
    var subTitle: String?
    var contentImage: UIImage?
    private var imageName: String?
    init(title: String?, subTitle: String?, imageName: String?) {
        super.init()
        self.title = title
        self.subTitle = subTitle
        self.imageName = imageName
    }
}


