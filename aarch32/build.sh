#!/bin/bash
#
# Copyright (c) 2017-2018, Antonio Niño Díaz <antonio_nd@outlook.com>
#
# SPDX-License-Identifier: MIT
#

set -e
set -x

${CROSS_COMPILE_AARCH32}gcc -c -o el2-bootstrap.o el2-bootstrap.S -march=armv8-a
${CROSS_COMPILE_AARCH32}ld -Bstatic --gc-sections -nostartfiles -nostdlib -o el2-bootstrap.elf -T el2-bootstrap.ld.S el2-bootstrap.o
${CROSS_COMPILE_AARCH32}objcopy -O binary el2-bootstrap.elf el2-bootstrap.bin
