/*
 * Copyright (c) 2017-2018, Antonio Niño Díaz <antonio_nd@outlook.com>
 *
 * SPDX-License-Identifier: MIT
 */


OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
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
