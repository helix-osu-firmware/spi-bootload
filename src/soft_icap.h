#ifndef SOFT_ICAP_H
#define SOFT_ICAP_H

// based on Ken Chapman's ICAPE2 routines, but this is only
// for rebooting the FPGA to a WBSTAR address.
// you should define:
// ICAP LSB port (ICAP_LSB_PORT)
// ICAP trigger port (ICAP_TRIGGER_PORT)
//
// and several memory locations should be pre-filled (or loaded)
// NOOP scratchpad pointer (NOOP_PTR)     (0x20000000)
// SYNC scratchpad pointer (SYNC_PTR)     (0xAA995566)
// CMD scratchpad pointer (CMD_PTR)       (0x30008001)
// WBSTAR scratchpad pointer (WBSTAR_PTR) (0x30020001)
// IPROG scratchpad pointer (IPROG_PTR)   (0x0000000F)
// ADDRESS scratchpad pointer (ADDR_PTR) - (user programmed)

#define icap_write 0
#define icap_read 1

// Scratchpad should be initialized for these guys.
// I need to find a way to embed this.

// The only thing we use scratchpad for is
// the stack, and that never gets very deep.
// So we PRE-INITIALIZE the scratchpad,
// and then cheezeball out the 4 bytes.

void ICAP_reboot() {
  sA = 0xFF;
  sB = ICAP_LSB_PORT;
  do {
    output(sB, sA);
    sB++;
  } while(sB != ICAP_LSB_PORT+4);
  // the above looks stupid:
  // (it's load/out/add/compare/jump instead of 4x out)
  // except the add/compare/jump gets us the 3 clocks
  // we need to wait, so this is actually cheaper
  // than 4x out + 2x nop
  sA = SYNC_PTR;
  ICAP_write_word();  
  ICAP_noop();
  sA = WBSTAR_PTR;
  ICAP_write_word();
  sA = ADDR_PTR;
  ICAP_write_word();
  sA = CMD_PTR;
  ICAP_write_word();
  sA = IPROG_PTR;
  ICAP_write_word();
  ICAP_noop();
}

// ICAP_noop and ICAPE2_write_word are nested in here.
// This is a BIG nest overall, mind you, but still
// way smaller than our stack (just 7 levels)
// check_command/ICAP_reboot->ICAP_noop2->ICAP_noop->
// ICAPE2_out4->memout2->memout1
void ICAP_noop2() {
  ICAP_noop();
 ICAP_noop:
  sA = NOOP_PTR;
 ICAP_write_word:  
  ICAP_out4();
  outputk(ICAP_TRIGGER_PORT, icap_write);
}

// sA is pointer to value in memory to use
// memout4/memout2/memout1: fetch from sA and output to sB multiple times,
// incrementing between.
void ICAP_out4() {
  sB = ICAP_LSB_PORT;
 memout4:
  memout2();
 memout2:
  memout1();
 memout1:
  fetch(sA, &sSpare);
  output(sB, sSpare);
  sA++;
  sB++;
}

#endif
