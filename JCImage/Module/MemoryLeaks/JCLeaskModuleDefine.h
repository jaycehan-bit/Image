//
//  JCLeaskModuleDefine.h
//  JCImage
//
//  Created by jaycehan on 2024/1/4.
//

#ifndef JCLeaskModuleDefine_h
#define JCLeaskModuleDefine_h

//#define weakify(x) \\
//_Pragma("clang diagnostic push") \\
//_Pragma("clang diagnostic ignored \"-Weverything\"") \\
//autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \\
//_Pragma("clang diagnostic pop")


#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;


#endif /* JCLeaskModuleDefine_h */
