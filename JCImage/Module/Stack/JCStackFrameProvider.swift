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
            sleep(1)
            topStackFrame()
        }
    }
    
    class func stackFrameFunction(topStackFrame: @escaping () -> Void) {
        self.anotherStackFrame {
            sleep(1)
            topStackFrame()
        }
    }
    
    class func anotherStackFrame(topStackFrame: @escaping () -> Void) {
        sleep(1)
        topStackFrame()
    }
    
}
