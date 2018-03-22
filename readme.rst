Linux Bootstrap for Raspberry Pi 3 with Trusted Firmware-A
==========================================================

This repository contains bootstraps that the `Trusted Firmware-A`_ needs to use
as BL33 images in order to boot the Linux kernel.

It is needed to use a specific bootstrap because the kernel expects the
secondary CPU cores to use a specific mailbox address to perform a warmboot
instead of using PSCI as the Trusted Firmware would expect. Note that this
mailbox is different depending on the architecture. Ultimately, it depends on
the Device Tree, the bootstrap scripts have been created considering the same
addresses used in the upstream kernel.

The kernel also needs to get the address of the DTB in a specific register. This
last part could be done by the `Trusted Firmware-A`_, but it is better left for
the bootstrap.

The bootstraps are simple pieces of code that have to be executed in AArch32
Hypervisor mode or EL2 in AArch64.

Depending on the architecture the kernel was compiled for, you'll need to use
the code in folder **aarch32** or **aarch64**. For a default instalation of
Raspbian, go to the folder **aarch32** and do:

.. code:: bash

    export CROSS_COMPILE_AARCH32=arm-linux-gnueabihf-
    ./build.sh

If the kernel was compiled for 64 bits, go to folder **aarch64** and do:

.. code:: bash

    export CROSS_COMPILE_AARCH64=aarch64-linux-gnu-
    ./build.sh

This will generate the file **el2-bootstrap.bin** that can be passed to the
`Trusted Firmware-A`_ build system as **BL33**.

The code assumes the addresses of the device tree block (DTB) and the kernel. If
they don't match the ones you are using, change them to the ones you need.

This bootstrap has been created by imitating the behaviour of the default
`AArch32 stub`_ and `AArch64 stub`_ used by the VideoCore loader.

.. _Trusted Firmware-A: https://github.com/ARM-software/arm-trusted-firmware
.. _AArch32 stub: https://github.com/raspberrypi/tools/blob/master/armstubs/armstub7.S
.. _AArch64 stub: https://github.com/raspberrypi/tools/blob/master/armstubs/armstub8.S
