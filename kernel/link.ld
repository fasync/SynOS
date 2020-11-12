ENTRY(_start)

SECTIONS {
    . = 1M;  /* Tells GRUB to load the kernel starting at the 1MiB mark */

    .text ALIGN(4K) :
    {
    /* Ensure that the multiboot header is at the beginning */
	*(.multiboot)
        *(.text)
    }

    .rodata ALIGN(4K) :
    {
	*(.rodata)
    }

    .data ALIGN(4K) :
    {
	*(.data)
    }

    .bss ALIGN(4K) :
    {
	*(COMMON)
	*(.bss)
    }
}
