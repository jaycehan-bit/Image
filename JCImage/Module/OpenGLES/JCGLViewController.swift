//
//  JCGLViewController.swift
//  JCImage
//
//  Created by jaycehan on 2023/11/28.
//

import UIKit
import Dispatch

class JCGLViewController: UIViewController {
    
    lazy var EAGLView: JCEAGLView = {
        return JCEAGLView.init(frame: CGRect.zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(EAGLView)
        EAGLView.frame = view.bounds
        self.startRenderImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        EAGLView.frame = view.bounds
    }
    
    deinit {
//        EAGLView.d
    }
    
    func startRenderImage() {
        let deadline = DispatchTime.now() + .milliseconds(300)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.EAGLView.renderImage(withName: "Seraphine.jpg")
        }
    }
}

