//
//  JCStackFrameCatcher.m
//  JCImage
//
//  Created by jaycehan on 2023/12/6.
//

#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/mach_init.h>
#import <mach/task.h>
#import <mach/thread_act.h>
#import <mach/thread_info.h>
#import <mach/vm_map.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <pthread/pthread.h>
#import <sys/sysctl.h>
#import <dlfcn.h>
#import "JCStackFrameCatcher.h"
#import "JCStackFrameDefine.h"
#import "JCSymbolParser.h"

static const NSInteger gJCStackFrameMaxCount = 30;

typedef struct StackFrameEntry{
    const struct StackFrameEntry *const previous;  // 前一个栈帧地址
    const uintptr_t return_address;                // 栈帧的函数返回地址
} StackFrameEntry;

@implementation JCStackFrameCatcher

+ (void)run {
    // 获取线程个数和线程地址
    //    thread_act_array_t threads;
    //    mach_msg_type_number_t thread_count = 0;
    //    task_threads(mach_task_self(), &threads, &thread_count);
    
    _STRUCT_MCONTEXT machineContext;
    mach_msg_type_number_t state_count = JC_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(mach_thread_self(), JC_THREAD_STATE, (thread_state_t)&machineContext.__ss, &state_count);
    if (kr != KERN_SUCCESS) {
        NSLog(@"获取线程信息失败");
        return;
    }
    StackFrameEntry node = {0};
    kern_return_t result = jc_mach_overwrite((void *)(&machineContext)->__ss.JC_FRAME_POINTER, &node, sizeof(node));
    if (result != KERN_SUCCESS) {
        NSLog(@"获取线程栈顶失败");
        return;
    }
    uintptr_t buffer[gJCStackFrameMaxCount] = {0};
    uint32_t stack_depth = gJCStackFrameMaxCount;
    for (int index = 0; index < gJCStackFrameMaxCount; index ++) {
        buffer[index] = node.return_address;
        kern_return_t result = jc_mach_overwrite((void *)node.previous,  &node, sizeof(node));
        if (result != KERN_SUCCESS) {
            stack_depth = index;
            break;
        }
    }
    Dl_info symbolicated[gJCStackFrameMaxCount] = {0};
    parse(buffer, symbolicated, stack_depth);
    
    for (uint32_t index = 0; index < gJCStackFrameMaxCount; index ++) {
        Dl_info info = symbolicated[index];
        printf("%s\n", info.dli_sname);
    }
    
    NSLog(@"%p", buffer);
}

kern_return_t jc_mach_overwrite(const void *const src, void *const dst, const size_t num_bytes) {
    vm_size_t bytesCopied = 0;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)src, (vm_size_t)num_bytes, (vm_address_t)dst, &bytesCopied);
}

cpu_type_t cpu_type(void) {
    size_t size;
    cpu_type_t type;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    return hostInfo.cpu_type;
}

@end
