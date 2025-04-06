#!/bin/bash

required_version="0.14.0"
current_version=$(zig version)

version_check=$(printf "%s\n%s" "$required_version" "$current_version" | sort -V | head -n1)
if [ "$version_check" != "$required_version" ]; then
    echo "[ ✖ ] Zig $required_version or higher is required. Found: Zig $current_version"
    exit 1
fi

echo "[ + ] Compiling..."
if ! zig build; then
    echo "[ ✖ ] Failed to compile Karnl."
    exit 1
fi

rm -f isodir/boot/karnl.elf
cp zig-out/bin/karnl.elf isodir/boot/

echo "[ + ] Generating ISO file..."
if ! grub-mkrescue -o karnl.iso isodir > /dev/null 2>&1; then
    echo "[ ✖ ] Failed to generate ISO file."
    exit 1
fi

echo "[ ✔ ] Successfully built Karnl!"
