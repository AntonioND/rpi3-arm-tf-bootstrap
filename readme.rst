Linux Bootstrap for Raspberry Pi 3 with Trusted Firmware-A
==========================================================

This repository contains bootstraps that the `Trusted Firmware-A`_ needs to use
as BL33 images in order to boot the `Raspberry Pi Linux kernel tree`_. The
reason for that is that this port doesn't support PSCI. However, this repository
also contains a `patch`_ thatcan be applied to that tree in order to enable
support for PSCI in the DTS files used by the Raspberry Pi (only for 64-bit
kernels). This means that there are two options:

* Use the Linux kernel tree as it is and use the bootstraps. This is the only
  option for now for 32-bit kernels.

* Modify the DTS files to enable PSCI support. If you do this, there are two
  possibilities:

  - Use `Das U-Boot`_. If so, compile the Trusted Firmware with it as BL33.

  - Compile the Trusted Firmware with direct-to-kernel boot.

The code of this repository (except for the patch for the Linux kernel) is
licensed under the terms of the MIT license.

Bootstraps
----------

It is needed to use a specific bootstrap because the kernel expects the
secondary CPU cores to use a specific mailbox address to perform a warmboot
instead of using PSCI as the Trusted Firmware would expect. Note that this
mailbox is different depending on the architecture. Ultimately, it depends on
the Device Tree, the bootstrap scripts have been created considering the same
addresses used in the upstream kernel.

The kernel also needs to get the address of the DTB in a specific register. This
last part can be done by the `Trusted Firmware-A`_, but it is also done by the
bootstrap.

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

Fix DTS files
-------------

Apply the patch in the Linux tree:

.. code:: bash

    git clone --depth=1 -b rpi-4.18.y https://github.com/raspberrypi/linux
    cd linux
    git am path/to/0001-rpi3-Enable-PSCI-support.patch

Now, compile the kernel as usual:

.. code:: bash

    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
    make -j 6 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-

    cp arch/arm64/boot/Image /path/to/boot/kernel8.img
    cp arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb /path/to/boot/
    cp arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b-plus.dtb /path/to/boot/

    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
    INSTALL_MOD_PATH=/path/to/filesystem modules_install

The Trusted Firmware has to be built with support for direct kernel boot. Follow
the instructions in that repository. Copy the resulting ``armstub8.bin`` to the
boot partition of the SD card. With this you should have a working AArch64
kernel that uses PSCI.

.. _Trusted Firmware-A: https://github.com/ARM-software/arm-trusted-firmware
.. _AArch32 stub: https://github.com/raspberrypi/tools/blob/master/armstubs/armstub7.S
.. _AArch64 stub: https://github.com/raspberrypi/tools/blob/master/armstubs/armstub8.S
.. _Raspberry Pi Linux kernel tree: https://github.com/raspberrypi/linux
.. _Patch: 0001-rpi3-Enable-PSCI-support.patch
.. _Das U-Boot: http://www.denx.de/wiki/U-Boot/
