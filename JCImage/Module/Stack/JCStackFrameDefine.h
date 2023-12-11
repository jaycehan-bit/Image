//
//  JCStackFrameDefine.h
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

#ifndef JCStackFrameDefine_h
#define JCStackFrameDefine_h

#if defined(__arm64__)
    #define JC_THREAD_STATE_COUNT ARM_THREAD_STATE64_COUNT
    #define JC_THREAD_STATE ARM_THREAD_STATE64
    #define JC_FRAME_POINTER __fp
    #define JC_STACK_POINTER __sp
    #define JC_INSTRUCTION_ADDRESS __pc
#elif defined(__arm__)
    #define JC_THREAD_STATE_COUNT ARM_THREAD_STATE_COUNT
    #define JC_THREAD_STATE ARM_THREAD_STATE
    #define JC_FRAME_POINTER __r[7]
    #define JC_STACK_POINTER __sp
    #define JC_INSTRUCTION_ADDRESS __pc
#elif defined(__x86_64__)
    #define JC_THREAD_STATE_COUNT x86_THREAD_STATE64_COUNT
    #define JC_THREAD_STATE x86_THREAD_STATE64
    #define JC_FRAME_POINTER __rbp
    #define JC_STACK_POINTER __rsp
    #define JC_INSTRUCTION_ADDRESS __rip
#elif defined(__i386__)
    #define JC_THREAD_STATE_COUNT x86_THREAD_STATE32_COUNT
    #define JC_THREAD_STATE x86_THREAD_STATE32
    #define JC_FRAME_POINTER __ebp
    #define JC_STACK_POINTER __esp
    #define JC_INSTRUCTION_ADDRESS __eip
#endif


#endif /* JCStackFrameDefine_h */
