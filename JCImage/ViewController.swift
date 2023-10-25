//
//  ViewController.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/25.
//

import UIKit

class ViewController: UIViewController {
    var imageView = UIImageView(frame: CGRect.zero)
    override func loadView() {
        let window = JCCommonUnit.mainWindow()
        self.view = JCView(frame: window.bounds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.imageView)
    }
}

