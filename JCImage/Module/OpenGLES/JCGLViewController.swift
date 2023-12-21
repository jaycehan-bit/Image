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
}

