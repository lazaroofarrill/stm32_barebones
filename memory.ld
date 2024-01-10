MEMORY {
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
}

ENTRY(main);
__reset_stack_pointer = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS {
    .text : {
        /* Set initial address to 0 */
        .0;
        LONG(__reset_stack_pointer);
        LONG(main | 1);
        /* Skip interrupt table TODO(confirm this value is correct) */
        .+ = 332;
        /* Here goes the rest of the code */
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH /* put this in the flash memory region */

    .ARM.exidx : {
        *(.ARM.exidx*)
        . = ALIGN(4);
    } > FLASH
}
