### Considerations
bcm2711_defconfig will support all 64-bit Pi devices and uses a pagesize of 4K
bcm2712_defconfig switches to a 64K pagesize, and only works on Pi 5.

sudo dnf groupinstall "Development Tools" --Raspberry almalinux
sudo dnf install openssl-devel raspbian 
sudo apt install bison flexasp
sudo dnf install bc alma 


# Clone the RPi kernel source
git clone --depth=1 --branch rpi-6.12.y https://github.com/raspberrypi/linux
cd linux

# Start with the default RPi config
KERNEL=kernel8 raspberrypi4
KERNEL=kernel_2712 raspberypi5
make bcm2712_defconfig

# Open the config menu and change VA bits
make menuconfig
# Navigate to: Kernel Features -> Virtual address space size
# Select: 48-bit virtual address space

# Or do it non-interactively:
scripts/config --disable CONFIG_ARM64_VA_BITS_39
scripts/config --enable CONFIG_ARM64_VA_BITS_48
scripts/config --set-val CONFIG_ARM64_VA_BITS 48

# Build (grab a coffee, this takes a while)
make -j6 Image modules dtbs

make -j6 Image.gz modules dtbs

# Install
sudo make -j6 modules_install

sudo cp arch/arm64/boot/Image.gz /boot/$KERNEL.img


sudo cp /boot/firmware/$KERNEL.img /boot/firmware/$KERNEL-backup.img
sudo cp arch/arm64/boot/Image /boot/firmware/$KERNEL.img
sudo cp arch/arm64/boot/dts/broadcom/*.dtb /boot/firmware/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/firmware/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/firmware/overlays/
sudo reboot