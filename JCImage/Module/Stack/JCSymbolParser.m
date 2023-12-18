//
//  JCSymbolParser.m
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import "JCSymbolParser.h"

@implementation JCSymbolParser

+ (void)run {
    run();
}

void run(void) {
    const uint32_t image_count = _dyld_image_count();
    for (uint32_t index = 0; index < _dyld_image_count(); index ++) {
        const char *image_name = (char *)_dyld_get_image_name(index);
        const struct mach_header *mach_header = _dyld_get_image_header(index);
        intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(index);
        
        struct segment_command_64 *cur_seg_cmd = NULL;
        struct symtab_command *symtab_cmd = NULL;
        struct dysymtab_command *dysymtab_cmd = NULL;
        uintptr_t cur_add = (uintptr_t)mach_header + sizeof(mach_header);
        for (uint32_t cmd_index = 0; cmd_index < mach_header->ncmds; cmd_index ++) {
            cur_seg_cmd = (struct segment_command_64 *)cur_add;
            if (cur_seg_cmd->cmd == LC_SYMTAB) {
                symtab_cmd = (struct symtab_command *)cur_seg_cmd;
            } else if (cur_seg_cmd->cmd == LC_DYSYMTAB) {
                dysymtab_cmd = (struct dysymtab_command *)cur_seg_cmd;
            }
        }
        
        
        printf("Image name %s at address 0x%llx and ASLR slide 0x%lx.\n", image_name, (mach_vm_address_t)mach_header, vmaddr_slide);
    }
}


@end
