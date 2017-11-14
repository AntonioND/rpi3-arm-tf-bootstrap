/*
 * Copyright (c) 2017, Antonio Niño Díaz <antonio_nd@outlook.com>
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

/*
 * PSCI constants
 */
#define PSCI_CPU_ON_AARCH64		0xC4000003

/*
 * Kernel constants
 */
#define KERNEL_ADDRESS			0x01000000
#define DEVICE_TREE_ADDRESS		0x02000000
/* Each entry is 64-bit wide. */
#define MAILBOX				0x000000D8

/*
 * When this image is called, x0 contains the mpidr of this CPU. Only CPU0
 * should jump here.
 */
.globl _start
_start:
	/* TODO : Turn CPU off if this isn't CPU0. */
	ands	x0, x0, #0x3
	bne	panic

	/* Clear mailbox */
	ldr	x0, =MAILBOX
	mov	x1, #0
	str	x1, [x0, #0x0]
	str	x1, [x0, #0x8]
	str	x1, [x0, #0x10]
	str	x1, [x0, #0x18]

	/* Turn on all secondary CPUs */
	ldr	x0, =PSCI_CPU_ON_AARCH64
	mov	x1, #1
	adr	x2, wait_mailbox
	mov	x3, #0
	smc	#0

	ldr	x0, =PSCI_CPU_ON_AARCH64
	mov	x1, #2
	adr	x2, wait_mailbox
	mov	x3, #0
	smc	#0

	ldr	x0, =PSCI_CPU_ON_AARCH64
	mov	x1, #3
	adr	x2, wait_mailbox
	mov	x3, #0
	smc	#0

	/* Prepare values for primary CPU */
	ldr	x0, =DEVICE_TREE_ADDRESS
	ldr	x4, =KERNEL_ADDRESS
	b	boot_kernel

	/* Waitloop for secondary CPUs */
wait_mailbox:
	mrs	x1, mpidr_el1
	and	x1, x1, #0x3

	ldr	x2, =MAILBOX
mailbox_spin:
	wfe
        /* Load value in x4, which is the register to jump to later */
	ldr	x4, [x2, x1, lsl #3]
	cbz	x4, mailbox_spin
	/* Clear x0 to pass as argument for the kernel */
	mov	x0, #0

boot_kernel:
	/* Arguments for the kernel */
	mov	x1, #0
	mov	x2, #0
	mov	x3, #0

	/* Jump to the kernel */
	br	x4

/*
 * Panic loop
 */
panic:
	wfi
	b	panic
