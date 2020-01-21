#ifndef SOFT_SPI_FLASH_H
#define SOFT_SPI_FLASH_H

#include "soft_spi.h"
#include "pb_stack.h"

// rework of SPI flash
// routines from Ken Chapman in
// pseudo-c.

// Again, standard convention is that
// parameters are sA/sB/sC/sD/sE,
// and sF is a completely spare
// register.

// commands
#define SPI_FLASH_READ 0x3
#define SPI_FLASH_4READ 0x13
#define SPI_FLASH_RDID 0x9F
#define SPI_FLASH_PP 0x2
#define SPI_FLASH_4PP 0x12
#define SPI_FLASH_WREN 0x06
#define SPI_FLASH_WRDI 0x04
// sigh, they should've defined it as C8,
// so that the 4 byte commands were just the 3-byte
// commands with bit 4 toggled. Or as DA,
// so they're just the command ORed with 0x12.
// bastards.
#define SPI_FLASH_SE 0xD8
#define SPI_FLASH_4SE 0xDC
#define SPI_FLASH_RDSR 0x05

// these are called PPB Program/PPB Erase on Spansion
// devices, but work exactly the same, thankfully.
// The VOLATILE ones don't, because no one can play
// nicely together.
#define SPI_FLASH_ERASE_NVLB 0xE4
#define SPI_FLASH_WRITE_NVLB 0xE3

#define SPI_FLASH_RESET_SPANSION 0xF0
#define SPI_FLASH_RESET_ENABLE_MICRON 0x66
#define SPI_FLASH_RESET_MICRON 0x99

// bits
#define SPI_FLASH_WIP 0x01

#define SPI_FLASH_ENTER_DPWDN 0xB9
#define SPI_FLASH_RELEASE_DPWDN 0xAB

// these are in ~6.5 ms increments
// ~1.2 seconds
#define SPI_FLASH_SECTOR_ERASE_TIMEOUT 170
// 6.5 ms
#define SPI_FLASH_PAGE_PROGRAM_TIMEOUT 1

void SPI_Flash_single_command(void) __attribute__((noreturn));
void SPI_Flash_single_command() {
  SPI_DISABLE();
  SPI_tx_rx();
  psm("jump SPI_disable_and_return");
}

// These commands are all the same except for
// the command they send.
#define SPI_Flash_set_WREN() \
  sA = SPI_FLASH_WREN;       \
  SPI_Flash_single_command()

#define SPI_Flash_reset_WREN() \
  sA = SPI_FLASH_WRDI;         \
  SPI_Flash_single_command()

// SPI_Flash_read_ID: Executes read ID instruction
//     input: none
//     output: sC/sB/sA data from 'RDID' (0x9F)
void SPI_Flash_read_ID(void) __attribute__((noreturn));
void SPI_Flash_read_ID() {
  SPI_DISABLE();
  sA = SPI_FLASH_RDID;
  // transmit sA and receive the byte after that.
  SPI_tx_rx_twice();
  // store sA in 0x3F
  push1();
  SPI_tx_rx();
  // store sA in 0x3E
  push1();
  SPI_tx_rx();
  // store sA in 0x3D
  push1();
  // put 0x3D in sA
  // put 0x3E in sB
  // put 0x3F in sC
  pop3();
  psm("jump SPI_disable_and_return");
}

// SPI_Flash_tx_address: Transmits the three bytes from the stack.
//     input: none
//     output: none
//     uses: sA/sB (implicitly)
//
// Also creates SPI_Flash_tx_stack2 and SPI_Flash_tx_stack.
// The nested call this way uses 5 instructions total,
// as opposed to the 7 instructions otherwise (3x pop/tx, return)
void SPI_Flash_tx_address() {
  // pop, then transmit
  SPI_Flash_tx_stack();
  // returns here...
 SPI_Flash_tx_stack2:
  // pop, then transmit
  SPI_Flash_tx_stack();
  // returns here...
 SPI_Flash_tx_stack:
  // pop
  pop1();
  // transmit
  SPI_tx_rx();
}

// SPI_Flash_read_begin: Executes read instruction
//     input: sD/sA/sB/sC : address to read (note weird ordering)
//                          for a 3-byte device use 0xFF as address 0
void SPI_Flash_read_begin() {
  // Stacks are last in first out, which is why we
  // ask for the address in inverse order.
  // That way we can push3 straight from the beginning
  // and pop1/pop1/pop1.
  SPI_DISABLE();  
  push3();
  sA = SPI_FLASH_READ;
  if (sD != 0xFF) {
    sA = SPI_FLASH_4READ;
    SPI_tx_rx();
    sA = sD;
  }
  SPI_tx_rx();
  SPI_Flash_tx_address();
}

// SPI_Flash_read_byte: returns next byte in sA
//                    : (must call SPI_Flash_read_begin first)
//    input: none
//    uses: sB/sA
//    output: sA has byte read
#define SPI_Flash_read_byte() \
  SPI_tx_rx()

// SPI_Flash_read_complete: finishes read
//    input: none
//    uses: none
//    output: none
#define SPI_Flash_read_complete() \
  SPI_DISABLE()

// SPI Flash writing:
//    Write procedure involves multiple calls,
//    to allow for multiple bytes to be sent.
//  1: SPI_Flash_write_begin() (with address in sD/sA/sB/sC)
//   : NOTE THE GOOFY BYTE ORDERING. 3 byte addresses use sD = 0xFF
//  2: sA = byte_to_write; SPI_tx_rx(); (for each byte to write)
//  3: SPI_Flash_write_complete()
//
void SPI_Flash_write_begin() {
  // save address
  push3();
  SPI_Flash_set_WREN();
  sA = SPI_FLASH_PP;
  // check sD. If it's 0xFF (which is like, impossible for any
  // of our SPI flash) just use the 3-byte version.
  if (sD != 0xFF) {
    // it's a 4-byte address, so transmit that first.
    sA = SPI_FLASH_4PP;
    // and everything else is the same, except we're actually
    // sending the first byte of the address later now
    SPI_tx_rx();
    sA = sD;
  }
  SPI_tx_rx();
  SPI_Flash_tx_address();
  // and done. we're just the beginning
}

#define SPI_Flash_write_byte() \
  SPI_tx_rx()

void SPI_Flash_write_complete() {
  // end last command
  SPI_DISABLE();
  // wait for WIP done
  sA = SPI_FLASH_PAGE_PROGRAM_TIMEOUT;
  SPI_Flash_wait_WIP();
  // save result
  push1();
  // clear WREN
  SPI_Flash_reset_WREN();
  // restore result
  pop1();
}

// for PP, pass sA = 1, becomes 8*256 = 2048 cycles (~7 ms)
// for SE, pass sA = 170, becomes 348,160 cycles (~1.11 s)
// SPI_Flash_wait_WIP: waits for the WIP bit to clear
//    uses: sA/sB/sC/sD/sE
//    returns: sA=0 on success, sA = 1 on timeout
void SPI_Flash_wait_WIP() {
  // Our lower-level functions clobber sA/sB,
  // so we need sC/sD/sE.
  // We're a terminating function so no one
  // above us needs anything.
  sD = sA;
  sE.sD <<= 1;
  sE.sD <<= 1;
  sE.sD <<= 1;
  sC = 0;
  do {
    SPI_Flash_read_SR();
    sA &= 0x1;
    if (Z) return;
  } while (sE.sD.sC--);  
}

void SPI_Flash_read_SR(void) __attribute__((noreturn));
void SPI_Flash_read_SR() {
  SPI_DISABLE();
  sA = SPI_FLASH_RDSR;
  // transmit sA and receive the byte after that.
  SPI_tx_rx_twice();
  psm("jump SPI_disable_and_return");
}

// Erase the SPI flash sector pointed to by the address (sD/sA/sB/sC)
// note the wacko ordering. 3-byte addresses should use sD = 0xFF
// returns sA = 1 on timeout, sA = 0 on success
void SPI_Flash_erase_sector(void) __attribute__((noreturn));
void SPI_Flash_erase_sector() {
  push3();
  SPI_Flash_set_WREN();
  sA = SPI_FLASH_SE;
  if (sD != 0xFF) {
    sA = SPI_FLASH_4SE;
    SPI_tx_rx();
    sA = sD;
  }
  SPI_tx_rx();
  SPI_Flash_tx_address();
  SPI_DISABLE();  
 SPI_Flash_erase_sector_wait:
  // set timeout
  sA = SPI_FLASH_SECTOR_ERASE_TIMEOUT;
  psm("jump SPI_Flash_wait_WIP");
}

// erase nonvolatile lock bits.
// returns sA = 1 on timeout, sA = 0 on success
void SPI_Flash_erase_nonvolatile_lock_bits(void) __attribute__((noreturn));
void SPI_Flash_erase_nonvolatile_lock_bits() {
  SPI_Flash_set_WREN();
  sA = SPI_FLASH_ERASE_NVLB;
  SPI_Flash_single_command();
  psm("jump SPI_Flash_erase_sector_wait");
}

// write nonvolatile lock bits pointed to by address. (sD/sA/sB/sC)
// note that you don't HAVE to use sD = 0xFF on devices <256M
// but it doesn't matter if you do
// returns sA = 1 on timeout, sA = 0 on success
void SPI_Flash_write_nonvolatile_lock_bits(void) __attribute__((noreturn));
void SPI_Flash_write_nonvolatile_lock_bits() {
  // if we add 1 and it's not zero, subtract one.
  // this just maps FF -> 00
  sD++;
  if (!Z) sD--;
  push3();
  SPI_Flash_set_WREN();
  sA = SPI_FLASH_WRITE_NVLB;
  SPI_tx_rx();
  sA = sD;
  SPI_tx_rx();
  SPI_Flash_tx_address();
  // finish with the page program timeout
  psm("jump SPI_Flash_write_complete");
}

void SPI_Flash_reset(void) __attribute__((noreturn));
void SPI_Flash_reset() {
  SPI_DISABLE();
  // There's no universal 'RESET' command, unfortunately,
  // but we can just do BOTH of the commands.
  sA = SPI_FLASH_RESET_ENABLE_MICRON;
  SPI_Flash_single_command();
  sA = SPI_FLASH_RESET_SPANSION;
  SPI_Flash_single_command();
  sA = SPI_FLASH_RESET_MICRON;
  // exit through SPI_Flash_single_command
  psm("jump SPI_Flash_single_command");
}

void SPI_disable_and_return() {
  SPI_DISABLE();
}

#endif
