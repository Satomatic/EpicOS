mkdir -p cdiso

# Build kernel & bootloader
nasm bootloader.asm -f bin -o boot.bin
nasm main.asm -f bin -o kernel.bin

# Write disk image
dd if=/dev/zero of=cdiso/boot.flp bs=1024 count=1440
dd if=boot.bin of=cdiso/boot.flp seek=0 count=1 conv=notrunc
dd if=kernel.bin of=cdiso/boot.flp seek=1 count=10 conv=notrunc

# Clean up files
rm boot.bin
rm kernel.bin

python3 buildfs.py

qemu-system-x86_64 -fda cdiso/boot.flp
