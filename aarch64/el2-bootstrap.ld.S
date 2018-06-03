/*
 * Copyright (c) 2017-2018, Antonio Niño Díaz <antonio_nd@outlook.com>
 *
 * SPDX-License-Identifier: MIT
 */


OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(_start)

SECTIONS
{
	. = ALIGN(8);
	.text : { *(.text*) }

	. = ALIGN(8);
	.rodata : { *(.rodata*) }

	. = ALIGN(8);
	.data : { *(.data*) }
}
