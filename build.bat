:: 1. Компилируем (добавляем -fno-stack-protector, чтобы не было лишних символов)
gcc -m32 -ffreestanding -fno-stack-protector -c kernel.c -o kernel.o
nasm kernel_entry.asm -f win32 -o kernel_entry.o

:: 2. Линкуем в обычный .o (или .elf)
ld -m i386pe -Ttext 0x7e00 --section-alignment 0x200 -e _start -o kernel.tmp kernel_entry.o kernel.o

:: 3. Извлекаем "чистое мясо" (бинарный код) через objcopy
objcopy -O binary kernel.tmp kernel.bin
::pause

::ndisasm -b 32 kernel.bin

nasm -f bin boot.asm -o boot.bin
nasm -f bin 32pro.asm -o 32pro.bin
copy /b boot.bin + kernel.bin os-image.bin
::copy /b boot.bin + 32pro.bin os-image.bin
::pause

::qemu-system-x86_64 os-image.bin
qemu-system-x86_64 -drive format=raw,file=os-image.bin  -d int -no-reboot  -monitor stdio
pause