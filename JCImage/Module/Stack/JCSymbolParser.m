//
//  JCSymbolParser.m
//  JCImage
//
//  Created by jaycehan on 2023/12/11.
//

#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import "JCStackFrameDefine.h"
#import "JCSymbolParser.h"

@implementation JCSymbolParser

+ (void)run {
    run();
}

void run(void) {
//    const uint32_t image_count = _dyld_image_count();
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

void parse(uintptr_t *symbol, Dl_info *symbolicated, uint32_t symbol_count) {
    for (uint32_t index = 0; index < symbol_count; index ++) {
        symbolicated_address(symbol[index], &symbolicated[index]);
    }
}

void symbolicated_address(const uintptr_t address, Dl_info *const info) {
    info->dli_fname = NULL;
    info->dli_fbase = NULL;
    info->dli_sname = NULL;
    info->dli_saddr = NULL;
    // 符号所在Image
    const uint32_t header_index = image_index_for_address(address);
    if (header_index == UINT_MAX) {
        return;
    }
    // 符号所在Image的header
    const struct mach_header *mach_header = _dyld_get_image_header(header_index);
    info->dli_fname = _dyld_get_image_name(header_index);
    info->dli_fbase = (void *)mach_header;
    // Image偏移地址ALSR
    const uintptr_t image_slide = (uintptr_t)_dyld_get_image_vmaddr_slide(header_index);
    // 符号虚拟地址 = 函数地址 - slide偏移值
    const uintptr_t virtual_address = address - image_slide;
    // 基址
    const uintptr_t base_address = base_address_of_image_index(header_index);
    
    uintptr_t command_ptr = (uintptr_t)(((jc_mach_header *)mach_header) + 1);
    for (uint32_t command_index = 0; command_index < mach_header->ncmds; command_index ++) {
        const struct load_command *load_command = (struct load_command *)command_ptr;
        command_ptr += load_command->cmdsize;
        if (load_command->cmd != LC_SYMTAB) {
            continue;
        }
        const struct symtab_command *symtab_command = (struct symtab_command *)load_command;
        const jc_nlist *symbol_table = (jc_nlist *)(base_address + symtab_command->symoff);
        const uintptr_t string_table = base_address + symtab_command->stroff;
        // 所处符号表
        const jc_nlist *symbol = nil;
        // 最小的偏移
        intptr_t min_offset = UINT_MAX;
        for (uint32_t table_index = 0; table_index < symtab_command->nsyms; table_index ++) {
            if (symbol_table[table_index].n_value == 0) {
                continue;
            }
            uintptr_t symbol_base = symbol_table[table_index].n_value;
            if (virtual_address >= symbol_base && min_offset > virtual_address - symbol_base) {
                symbol = symbol_table + table_index;
                min_offset = virtual_address - symbol_base;
            }
        }
        if (symbol) {
            info->dli_saddr = (void *)(symbol->n_value + image_slide);
            info->dli_sname = (char *)((intptr_t)string_table + (intptr_t)symbol->n_un.n_strx);
//            if (*info->dli_sname == '_') {
//                info->dli_sname++;
//            }
//            if (info->dli_saddr == info->dli_fbase && symbol->n_type == 3) {
//                    info->dli_sname = NULL;
//            }
            break;
        }
        
    }
}

uint32_t image_index_for_address(const uintptr_t address) {
    const struct mach_header *machHeader = 0;
    // 遍历Image
    for (uint32_t index = 0; index < _dyld_image_count(); index ++) {
        machHeader = _dyld_get_image_header(index);
        if (machHeader == NULL) {
            break;
        }
        uintptr_t offset_address = address - (uintptr_t)_dyld_get_image_vmaddr_slide(index);
        uintptr_t cmdPointer = command_pointer_from_mach_header(machHeader);
        if (cmdPointer == 0) {
            continue;;
        }
        // 遍历load_command,判断地址是否处于其中；需判断32/64位
        for (uint32_t cmd_index = 0; cmd_index < machHeader->ncmds; cmd_index ++) {
            const struct load_command *load_command = (struct load_command *)cmdPointer;
            if (load_command->cmd == LC_SEGMENT) {
                const struct segment_command *segment_command = (struct segment_command *)cmdPointer;
                if (offset_address >= segment_command->vmaddr && offset_address < segment_command->vmaddr + segment_command->vmsize) {
                    return index;
                }
            } else if(load_command->cmd == LC_SEGMENT_64){
                const struct segment_command_64 *segment_command = (struct segment_command_64 *)cmdPointer;
                if (offset_address >= segment_command->vmaddr && offset_address < segment_command->vmaddr + segment_command->vmsize) {
                    return index;
                }
            }
            cmdPointer += load_command->cmdsize;
        }
    }
    return UINT_MAX;
}

// load_command起始地址，即第一个segment_command地址
uintptr_t command_pointer_from_mach_header(const struct mach_header * const machHeader) {
    switch (machHeader->magic) {
        case MH_MAGIC:
        case MH_CIGAM:
        case MH_MAGIC_64:
        case MH_CIGAM_64:
            return (uintptr_t)(((jc_mach_header *)machHeader) + 1);
        default:
            return 0; // Header 不合法
    }
}

// LINKEDIT segment地址
uintptr_t segment_address_of_image_index(const uint32_t index) {
    const struct mach_header *mach_header = _dyld_get_image_header(index);
    uintptr_t command_ptr = command_pointer_from_mach_header(mach_header);
    if (command_ptr == 0) {
        return 0;
    }
    for (uint32_t command_index = 0; command_index < mach_header->ncmds;  command_index ++) {
        const jc_segment_comand *segment_command = (jc_segment_comand *)command_ptr;
        if (strcmp(segment_command->segname, SEG_LINKEDIT) == 0) {
            return (uintptr_t)(segment_command->vmaddr - segment_command->fileoff);
        }
        command_ptr += segment_command->cmdsize;
    }
    return 0;
}

// LINKEDIT段的虚拟地址
uintptr_t linkedit_segment_address_of_image_index(const uint32_t image_index) {
    const struct mach_header *mach_header = _dyld_get_image_header(image_index);
    uintptr_t load_command_address = (uintptr_t)(((jc_mach_header *)mach_header) + 1);
    if (load_command_address ==0) {
        return 0;
    }
    for (uint32_t load_command_index = 0; load_command_index < mach_header->ncmds; load_command_index ++) {
        const jc_segment_comand *segment_command = (jc_segment_comand *)load_command_address;
        if (segment_command->cmd == JC_LC_SEGMENT) {
            if (strcmp(segment_command->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)segment_command->vmaddr;
            }
        }
        load_command_address += segment_command->cmdsize;
    }
    return 0;
}

uintptr_t base_address_of_image_index(__const uint32_t image_index) {
    const struct mach_header *mach_header = _dyld_get_image_header(image_index);
    uintptr_t load_command_address = (uintptr_t)(((jc_mach_header *)mach_header) + 1);
    if (load_command_address == 0) {
        return 0;
    }
    for (uint32_t load_command_index = 0; load_command_index < mach_header->ncmds; load_command_index ++) {
        const jc_segment_comand *segment_command = (jc_segment_comand *)load_command_address;
        if (segment_command->cmd == JC_LC_SEGMENT) {
            if (strcmp(segment_command->segname, SEG_LINKEDIT) == 0) {
                return (uintptr_t)(segment_command->vmaddr - segment_command->fileoff + (uintptr_t)_dyld_get_image_vmaddr_slide(image_index));
            }
        }
        load_command_address += segment_command->cmdsize;
    }
    return 0;
}

@end

/*
 Header
 ------------------
 Load commands
 Segment command 1 -------------|
 Segment command 2              |
 ------------------             |
 Data                           |
 Section 1 data |segment 1 <----|
 Section 2 data |          <----|
 Section 3 data |          <----|
 Section 4 data |segment 2
 Section 5 data |
 ...            |
 Section n data |
 */
