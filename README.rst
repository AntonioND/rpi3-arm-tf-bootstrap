Linux Bootstrap for Raspberry Pi 3 with Arm Trusted Firmware
============================================================

This is a bootstrap that the `Arm Trusted Firmware`_ needs to use as BL33 in
order to boot a 32-bit Linux kernel like Raspbian.

It is needed because the kernel expects the secondary CPU cores to use a
specific mailbox address to perform a warmboot instead of using PSCI as the
Trusted Firmware would expect.

This bootstrap is a simple piece of AArch32 code that has to be executed in
Hypervisor mode.

To compile it simply do:

.. code:: bash

    export CROSS_COMPILE_AARCH32=arm-linux-gnueabihf-
    ./build.sh

This will generate the file `el2-bootstrap.bin` that can be passed to the Arm
Trusted Firmware build system as `BL33`.

The code assumes the addresses of the device tree block (dtb) and the kernel. If
they don't match the ones you are using, change them to the ones you need.

This bootstrap has been created by imitating the behaviour of the
`default Arm stub`_ used by the VideoCore loader.

.. _Arm Trusted Firmware: https://github.com/ARM-software/arm-trusted-firmware
.. _default Arm stub: https://github.com/raspberrypi/tools/blob/master/armstubs/armstub7.S
