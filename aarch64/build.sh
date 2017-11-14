#!/bin/bash

set -e
set -x

${CROSS_COMPILE_AARCH64}gcc -c -o el2-bootstrap.o el2-bootstrap.S -march=armv8-a
${CROSS_COMPILE_AARCH64}ld -Bstatic --gc-sections -nostartfiles -nostdlib -o el2-bootstrap.elf -T el2-bootstrap.ld.S el2-bootstrap.o
${CROSS_COMPILE_AARCH64}objcopy -O binary el2-bootstrap.elf el2-bootstrap.bin
