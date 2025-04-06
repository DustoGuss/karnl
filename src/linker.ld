ENTRY(_start)

SECTIONS {
    /* Comece em 1 MiB, que é comum para kernels */
    . = 1M;

    /* Multiboot Header precisa estar nos primeiros 8 KiB */
    .multiboot :
    {
        KEEP(*(.multiboot))
    }

    .text : ALIGN(4K) {
        *(.text)
    }

    .rodata : ALIGN(4K) {
        *(.rodata)
    }

    .data : ALIGN(4K) {
        *(.data)
    }

    .bss : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}
