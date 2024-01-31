//
//  JCCommonUnit.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/26.
//

import UIKit

@objcMembers class JCCommonUnit: NSObject {
    public static func mainWindow() -> UIWindow {
        let scenes = UIApplication.shared.connectedScenes;
        let windowScene: UIWindowScene = scenes.first as! UIWindowScene
        if #available(iOS 15.0, *) {
            let sceneDelegate = windowScene.delegate as! SceneDelegate
            return sceneDelegate.window!
        } else {
            return UIApplication.shared.windows.first!
        }
    }
    
    public static func swiftStaticFunc(log: NSString) {
        print(log);
    }
}

extension String {
    public static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            var num = isLetter ? arc4random_uniform(58) + 65:arc4random_uniform(75) + 48
            if num > 57 && num < 65 && isLetter == false {
                num = num % 57 + 48
            } else if num > 90 && num < 97 {
                num = num%90+65
            }
            ch[index] = CChar(num)
        }
        return String(cString: ch)
    }
}
