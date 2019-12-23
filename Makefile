C_SOURCES = $(wildcard src/kernel/*.c src/drivers/*.c src/kernel/io/*.c)
HEADERS = $(wildcard src/kernel/*.h src/drivers/*.h src/kernel/io/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os-image
run: all
	qemu-system-x86_64 os-image

os-image: src/boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: src/kernel/kernel_entry.o ${OBJ}
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf64 -o $@

%.bin: %.asm
	nasm $< -f bin -I 'src/boot/' -o $@

.PHONY: clean
clean:
	rm -rf *.bin *.o os-image
	rm -rf src/kernel/*.o src/boot/*.bin src/drivers/*.o src/kernel/io/*.o
