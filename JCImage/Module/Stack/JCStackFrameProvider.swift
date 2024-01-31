//
//  JCStackFrameProvider.swift
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

import Foundation

class JCStackFrameProvider: NSObject {
    
    class func provideStackFrame(topStackFrame: @escaping () -> Void) {
        self.stackFrameFunction {
            sleep(10)
            topStackFrame()
        }
    }
    
    class func stackFrameFunction(topStackFrame: @escaping () -> Void) {
        self.anotherStackFrame {
            for i in (0..<100000) {
                autoreleasepool {
                    let str = String.init(format: "%d", i)
                    
                }
            }
            topStackFrame()
        }
    }
    
    class func anotherStackFrame(topStackFrame: @escaping () -> Void) {
        topStackFrame()
    }
    
}
