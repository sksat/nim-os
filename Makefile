TARGET	= main.bin

ASM	= boot.S
NIMSRC	= main.nim
NIMLIB	= stdlib_system.c
LDSCRIPT= linker.ld

AS	= as
CC	= gcc
QEMU	= qemu-system-i386

LDFLAGS	= -m32 -ffreestanding -O2 -nostdlib
QEMUFLAGS= -kernel

NIMCACHE= ./nimcache
ASMOBJS	= $(patsubst %.S,%.o,$(ASM))
NIMOBJS	= $(addprefix $(NIMCACHE)/,$(patsubst %.nim,%.o,$(NIMSRC)))
NIMOBJS	+= $(addprefix $(NIMCACHE)/,$(patsubst %.c,%.o,$(NIMLIB)))

%.o: %.S
	$(AS) --32 $< -o $@

OBJS	= $(ASMOBJS) $(NIMOBJS)

all: $(TARGET)

run: $(TARGET)
	$(QEMU) $(QEMUFLAGS) $<

$(NIMOBJS): $(NIMSRC)
	nim c $^

$(TARGET): $(OBJS) $(LDSCRIPT)
	$(CC) -T $(LDSCRIPT) -o $@ $(LDFLAGS) $(OBJS)
