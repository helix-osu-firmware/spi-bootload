# this retains the intermediate files
.PRECIOUS: %.s %.obj
CC=pblaze-cc.py
AS=pblaze-as.py
LD=pblaze-ld.py

# pblaze-ld/pblaze-as flags
LDFLAGS=--dualport
ASFLAGS=-6

# target. Change this only.
all: spi_bootloader.v

%.s : %.c
	$(CC) $(CFLAGS) $<

%.obj : %.s
	$(AS) $(ASFLAGS) $<

%.v : %.obj
	$(LD) $(LDFLAGS) $<


