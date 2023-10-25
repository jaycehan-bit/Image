//
//  JCCommonUnit.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/26.
//

import UIKit

class JCCommonUnit: NSObject {
    static func mainWindow() -> UIWindow {
        let scenes = UIApplication.shared.connectedScenes;
        let windowScene: UIWindowScene = scenes.first as! UIWindowScene
        if #available(iOS 15.0, *) {
            let sceneDelegate = windowScene.delegate as! SceneDelegate
            return sceneDelegate.window!
        } else {
            return UIApplication.shared.windows.first!
        }
    }
}
