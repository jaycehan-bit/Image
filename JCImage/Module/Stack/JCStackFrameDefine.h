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

#ifdef __LP64__
typedef struct mach_header_64     jc_mach_header;
typedef struct segment_command_64 jc_segment_comand;
//typedef struct section_64         sectionByCPU;
typedef struct nlist_64           jc_nlist;
#define JC_LC_SEGMENT LC_SEGMENT_64
#else
typedef struct mach_header        jc_mach_header;
typedef struct segment_command    jc_segment_comand;
//typedef struct section            sectionByCPU;
typedef struct nlist              jc_nlist;
#define JC_LC_SEGMENT LC_SEGMENT
#endif

/**
 SP寄存器：stack pointer，堆栈寄存器，存放栈当前位置
 SS寄存器：存放栈的段地址
 BP寄存器：base pointer基数指针寄存器
 FP寄存器：栈顶指针，指向一个栈帧的顶部。函数跳转时会记录当前栈的起始地址
 */



#endif /* JCStackFrameDefine_h */
