/*
 * Copyright (c) 2017, Antonio Niño Díaz <antonio_nd@outlook.com>
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

/*
 * PSCI constants
 */
#define PSCI_CPU_ON_AARCH32		0x84000003

/*
 * Kernel constants
 */
#define MACHID				3138
#define KERNEL_ADDRESS			0x01000000
#define DEVICE_TREE_ADDRESS		0x02000000

/*
 * Mailbox addresses
 */
#define CORE0_MBOX3_RDCLR		0x400000CC
#define CORE1_MBOX3_RDCLR		0x400000DC
#define CORE2_MBOX3_RDCLR		0x400000EC
#define CORE3_MBOX3_RDCLR		0x400000FC

/*
 * When this image is called, r0 contains the mpidr of this CPU. Save it to a
 * register that is calee-saved according to AAPCS. Only CPU0 should jump here.
 */
.globl _start
_start:
	/* TODO : CPU OFF if not CPU0 */
	ands	r0, r6, #0x3
	bne	panic

	/* Clear kernel mailbox */
	mov	r2, #0xFFFFFFFF
        /* Writing ones clears the bits. */
	ldr	r0, =CORE0_MBOX3_RDCLR
	str	r2, [r0, #0x0]
	str	r2, [r0, #0x10]
	str	r2, [r0, #0x20]
	str	r2, [r0, #0x30]

	/* Turn on all secondary CPUs */
	ldr	r0, =PSCI_CPU_ON_AARCH32
	mov	r1, #1
	adr	r2, wait_mailbox
	mov	r3, #0
	smc	#0

	ldr	r0, =PSCI_CPU_ON_AARCH32
	mov	r1, #2
	adr	r2, wait_mailbox
	mov	r3, #0
	smc	#0

	ldr	r0, =PSCI_CPU_ON_AARCH32
	mov	r1, #3
	adr	r2, wait_mailbox
	mov	r3, #0
	smc	#0

	/* Arguments for the kernel */
	mov	r0, #0
	ldr	r1, =MACHID
	ldr	r2, =DEVICE_TREE_ADDRESS

	/* Jump to the kernel */
	ldr	r10, =KERNEL_ADDRESS
	bx	r10

/*
 * Wait until the mailbox gets the message from the kernel
 */
wait_mailbox:
	/* Get address of the mailbox */
	ldr	r0, =CORE0_MBOX3_RDCLR
	mrc	p15, #0, r1, c0, c0, #5 /* Read MPIDR */
	lsl	r1, r1, #4
	add	r0, r0, r1

	/* Wait until it is non zero */
wait_loop:
	ldr	r1, [r0]
	cmp	r1, #0
	bne	wait_end
	wfe
	b	wait_loop
wait_end:

	/* Clear mailbox */
	mov	r2, #0xFFFFFFFF
	str	r2, [r0]
	/* Jump to the provided address */
	bx	r1

/*
 * Panic loop
 */
panic:
	wfi
	b	panic
