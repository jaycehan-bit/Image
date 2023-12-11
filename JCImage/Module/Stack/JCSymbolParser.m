//
//  JCSymbolParser.m
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

#import <mach-o/dyld.h>
#import "JCSymbolParser.h"

@implementation JCSymbolParser

+ (void)run {
    run();
}

void run(void) {
    for (uint32_t index = 0; index < _dyld_image_count(); index ++) {
        const char *image_name = (char *)_dyld_get_image_name(index);
        const struct mach_header *mach_header = _dyld_get_image_header(index);
        intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(index);
        printf("Image name %s at address 0x%llx and ASLR slide 0x%lx.\n",
                       image_name, (mach_vm_address_t)mach_header, vmaddr_slide);
    }
}


@end
