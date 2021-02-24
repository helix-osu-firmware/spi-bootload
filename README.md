# SPI 'Bootloader'

This core was originally for HELIX but really can be used anywhere,
the interface is generic enough.

I call this an SPI "bootloader" but it's not really one in the
traditional microcontroller sense, as code that runs before
normal operation. Instead, this is code that can write to the SPI
Flash to program/erase/etc. stuff, and also issue an IPROG command
via ICAPE2 with a specified warm boot start address (WBSTAR).

# Required Interface

The interface to the SPI bootloader consists of 4 16-bit read/write
registers.

## Signal names

* en_i : 1 indicates a transaction on the bus. Should be a flag (single
         cycle high).
* wr_i : 1 indicates that this transaction is a write. Qualified by
         en_i, so if en_i is 0, this bit is do-not-care.
* adr_i : 2-bit input indicating which register is being accessed.
          Qualified by en_i, so if en_i is 0, this is do-not-care.
* dat_i : 16-bit data input. Qualified by en_i.
* dat_o : 16-bit data output. Valid when dat_valid_o is asserted,
          which occurs after en_i.
* dat_valid_o : Indicates that dat_o is valid. See parameters (generics)
                for behavior.

* spi_cs_b_o, spi_mosi_o, spi_miso_i, spi_sclk_o : SPI Flash interface signals.
  ***Note*** : To output using the CCLK output (used for configuration),
  you must instantiate the STARTUPE2 primitive and hook up spi_sclk_o to
  the USRCCLKO output.

Note that for the HELIX control interface, the SPI bootload core ignores
the difference between a write and an update.

Transactions are therefore begun with en_i, and end immediately if they
are a write (i.e. a write takes a single cycle), or with dat_valid_o
if they are a read (i.e. a read takes more than one cycle).

If WAIT_RESPONSE is "FALSE" (see parameters), read transactions are
deterministic and take 2 clock cycles. If WAIT_RESPONSE is "TRUE"
reads to register 3 can take a macroscopic amount of time (on the
order of a second).

Because of the streaming nature of the command/status packets, if this
interface does not match the rest of the FPGA, a simple way to integrate
this core is to peel off command packets addressing this core and
integrate status packets returned using a pair of AXI4-Stream switches.
See the HELIX SPI Wrapper section for details on this.

## Parameters/Generics

* WAIT_RESPONSE : either "TRUE" or "FALSE". Just use "FALSE"!
* IDCODE : This is the IDCODE of the FPGA device. Only used for simulation
           for the ICAP behavior.

## Register 0: FIFO keyhole

This is a keyhole to a pseudo-FIFO to store data either to be written
or read out from the SPI flash. Data can only be programmed and read
back in 256 byte pages. (Note that flash _in general_ must be erased
before programmed, and must be erased a sector at a time, with the
sector size device-dependent).

Data is written 1 byte at a time, even though it's a 16-bit data
path. If bit 15 (the high bit) is set, this resets the FIFO pointer
to 0 (but NOT the FIFO data).

***Any command*** resets the FIFO pointer to 0. However, the only
command that changes the FIFO _data_ is a read operation.

## Register 1/2: Command Arguments (arg0/arg1) (and return values)

Register 1 and 2 form a 32-bit data value which serves as
the argument for commands (when written) as well as
the return value (when read) for commands which return
data (currently only the READ ID command).

Register 1 is the least-significant word (bits [15:0])
and register 2 is the most-significant word (bits [31:16]).

Note that register 1 and 2 must be written for ***all***
commands, even ones that do not need an argument, and
even when the registers already contain the desired
arguments. This is further clarified in the Command/Status
section.

## Register 3: Command/Status (command)

This is a 16-bit register that contains the command to be
executed (when written) and the status/result of the
command (when read).

Bits [7:0] contain the actual command value (detailed
under Commands).

Bits [15:8] contain a checksum for the desired
command/arguments. In other words, command[15:8]
must contain the XOR of

```
command[7:0]
arg0[7:0]
arg0[15:8]
arg1[7:0]
arg1[15:8]
```

Commands will not be executed until a write to register
1, 2, and 3 occur. It is therefore recommended that
registers always be written in the same order for
a command (1, 2, then 3). This way, if something happens,
the expected command will always be executed.

Reading register 3 returns a 4 bit value, which is

```
bit 3: command timed out
bit 2: command error (either unrecognized or bad checksum)
bit 1: command complete
bit 0: command busy
```

Note that _all_ commands will complete at a certain point
if the bootloader is functioning properly, even if the SPI
flash is not.

Reading register 3 when WAIT_RESPONSE is TRUE will never
have bit 0 (command busy) set. If WAIT_RESPONSE is FALSE,
register 3 can be polled until bit 0 is not set.

### Commands

Except for ICAP_UNLOCK/ICAP_REBOOT, all commands correspond
to the actual command sent to the SPI Flash.

* 0x9E : READ_ID - Read SPI flash device ID 
         (core actually sends 0x9F to the device, just use 0x9E for the command, not fixing this)
* 0x03 : READ - Read page. arg1/arg0 specify the ***24-BIT*** address.
         This is for devices that are less than 256 Mbit.
* 0x13 : 4READ - Read page. arg1/arg0 specify the 32-bit address of the page.
         This is for devices that are 256 Mbit or more.
* 0x02 : PAGE_PROGRAM - Write page. arg1/arg0 specify the ***24-BIT*** address.
         This is for devices that are less than 256 Mbit.
* 0x12 : 4PAGE_PROGRAM - Write page. arg1/arg0 specify the 32-bit address.
         This is for devices that are 256 Mbit or more.
* 0xD8 : SECTOR_ERASE - Erase sector. The size of each sector is device
         specific. arg1/arg0 specify the ***24-BIT*** address.
	 This is for devices that are less than 256 Mbit.
* 0xDC : SECTOR_ERASE_4 - 32-bit version of SECTOR_ERASE.
* 0xE3 : WRITE_NONVOLATILE_LOCK_BITS - Write the lock bit for the
         sector beginning at address in arg1/arg0.
* 0xE4 : ERASE_NONVOLATILE_LOCK_BITS - Erase all nonvolatile lock bits.
* 0xFE : ICAP_UNLOCK - if arg1/arg0 is equal to 0x42796533 (KEY),
         unlock the ICAP_REBOOT command. ***Note*** - the unlock
	 is valid for _one command only_. Therefore ICAP_UNLOCK must
	 be set immediately before ICAP_REBOOT.
* 0xFF : ICAP_REBOOT - execute an IPROG reboot using the warm-boot
         start address (WBSTAR) specified in arg1/arg0.
	 This command is locked and will not execute unless preceded
	 by an ICAP_UNLOCK command.
	 
Note that WBSTAR isn't the 32-bit address for 256 Mbit+ devices: it's
the address *downshifted by 8*. See table 7-2 in UG470.

# HELIX SPI Wrapper

The HELIX SPI Wrapper allows for simple integration into any design
by specifically picking off packets addressed to the SPI core. The
core takes a 16-bit AXI4-Stream input and produces two AXI4-Stream
outputs, one for the SPI bootloader, and one for the rest of the
system. It includes the SPI bootloader core inside of it.

Note that the HELIX SPI Wrapper will _only_ process control packets
- that is, it requires packets to be 4 beats of a 16-bit input stream.

The SPI wrapper treats the combined 22-bit "lane/brd/chip/address"
fields in the control packet as a single field, and matches SPI
bootloader packets using a mask and a base address.

Up to 2 TUSER bits per beat can be used as additional packet matching.
For instance, TUSER[0] can indicate the start beat of the packet,
and TUSER[1] can indicate a CRC error for the last beat of the packet.
Because the packet consists of 4 16-bit beats, this means there are
a total of 8 TUSER bits to match against. These are matched using
a mask and a match field. Note that because AXI4-Stream is little
endian, TUSER[1:0] are the TUSER bits in the first word, TUSER[3:2]
in the second word, TUSER[5:4] in the third word, and TUSER[7:6]
in the last word.

TUSER is matched as (control_tuser & ~TUSER_MASK == TUSER_MATCH).
Ignoring all TUSER bits would just be setting TUSER_MASK = 0xFF
and TUSER_MATCH = 0. Ignoring all TUSER[1] bits would be
TUSER_MASK = 0x55. If TUSER[0] is used as start of frame and
TUSER[1] is used as CRC error, TUSER_MASK == 0x0 (all bits valid) and
TUSER_MATCH = 0x1 (only TUSER[0] in first packet ever set).

## Parameters/Generics

* [21:0] ADDRESS_MASK. Specifies which bits of the combined address field
         to ignore. For example, to exclude the "lane/brd/chip" fields,
	 use ADDRESS_MASK = 11_1111_1111_0000_0000_0011 = 0x3FF003.
	 Note that the bottom two bits should ALWAYS be 1, because the
	 SPI bootloader requires 4 addresses.
	 Defaults to 0x3FF003.
* [21:0] ADDRESS_MATCH. Specifies the base address of the SPI bootloader
  	 to match against. The combined 22-bit address field is matched
	 against this with (combined_addr & ~ADDRESS_MASK == ADDRESS_MATCH).
	 For instance, to exclude the lane/brd/chip fields and place
	 the SPI bootloader at address FFC, ADDRESS_MASK = 0x3FF003
	 and ADDRESS_MATCH = 0x000FFC.
	 Defaults to 0x000FFC.
* [7:0]  TUSER_MASK. Specifies which TUSER bits are ignored for TUSER_MATCH.
         Defaults to 0x0.
* [7:0]  TUSER_MATCH. Specifies what the combined TUSER bits from all 4
         beats should match to after ignoring TUSER_MASK bits.
	 Defaults to 0x1.
* [7:0]  TUSER_OUT_MASK. Specifies what bits from the _input_ tuser should
         be ignored and set to TUSER_OUT when outputting from the SPI core.
	 Defaults to 0x0 - as in, the output TUSER = input TUSER.
* [7:0]  TUSER_OUT. Specifies what the output tuser bits should be for the
         masked off bits. As in, output tuser = (input tuser & ~TUSER_OUT_MASK)
	 | (output_tuser & TUSER_OUT_MASK).
	 Defaults to 0x0.	 
* HELIX_MATCH. Either "TRUE" (default) or "FALSE". This checks all of the
         constant fields of the control packets. These are defined
	 in other parameters (HELIX_HEADER/HELIX_SOF/HELIX_EOF). This should
	 always be TRUE unless they're pre-checked elsewhere.

* IDCODE : passed to the SPI bootloader module
* WAIT_RESPONSE : passed to the SPI bootloader module

# Verification

There are two testbenches in the sim folder, one (spi_bootload_tb.v)
just using the direct low-level interface, and a second
(spi_stream_wrap_tb.sv) which checks the stream wrapper. Both use
an SPI Flash simulation model from Micron.

Note that both of the testbenches wait for a fairly long whiile before
releasing reset (~microseconds). This is because with the ICAP included,
GSR takes much longer (~1.25 us) to release, and only the Xilinx
primitives respond to GSR.

# PicoBlaze notes

The code in src/ is compiled using a PicoBlaze pseudocompiler, located
at http://github.com/barawn/picoblaze_utils.

This is NOT C. See the details in the repository above. It should be
as readable as C is, however.
