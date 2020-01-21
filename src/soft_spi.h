#ifndef SOFT_SPI_H
#define SOFT_SPI_H

// Ken's routines use s0 to track
// SPI state so he can toggle things
// without doing an input.
//
// We instead bury everything in
// address decoding, so that
// 0x00 = input and chip select
// control.
// 0x01 = clock (bit 0) and chip select (bit 1)
// 0x02 = data (bit 7)
// 0x03 = everything

// again convention:
// input/outputs sA/sB/sC/sD/sE
// register sSpare is always internally used
// only and never considered preserved
// except by functions in all capitals
// (which are simple macros anyway)

#define SPI_clk 0x1
#define SPI_data 0x80
#define SPI_miso 0x4
#define SPI_cs_b 0x2

// these can be adjusted so long as they stay
// within kport space (0x00-0x3F).
#define SPI_input_port 0x00
#define SPI_clk_cs_port 0x01
#define SPI_data_port 0x02
#define SPI_output_port 0x03

// Macros.
// SPI_clock_pulse: raise/lower SPI clock
// macro only, doesn't use anything
#define SPI_CLOCK_PULSE()              \
  outputk(SPI_clk_cs_port, SPI_clk);    \
  outputk(SPI_clk_cs_port, 0)

// SPI_disable: raises chip select (and sets clock/data to 0)
// macro only, doesn't use anything
#define SPI_DISABLE()				\
  outputk(SPI_output_port, SPI_cs_b)

// SPI_enable: lowers chip select and clock (data is unaffected
// macro only, doesn't use anything
#define SPI_ENABLE()				\
  outputk(SPI_clk_cs_port, 0)

// Set which chip select to use (from a register)
// macro only, doesn't use anything
#define SET_SPI_CS(x)				\
  output(SPI_input_port, x)

// Set which chip select to use (from a constant)
// macro only, doesn't use anything
#define KSET_SPI_CS(x)				\
  outputk(SPI_input_port, x)


// SPI_STARTUP_initialize: Initialize the STARTUP primitive.
//   input: none
//   output: none
//   uses: none
void SPI_STARTUP_initialize() {
  SPI_DISABLE();
  sSpare = 8;  
  do {
    outputk(SPI_clk_cs_port, SPI_clk | SPI_cs_b);
    outputk(SPI_clk_cs_port, SPI_cs_b);
  } while (--sSpare);
}

// SPI_tx_rx_twice: transmit/receive byte on SPI (twice).
//    input: sA, value to be output
//    output: sA, value received (after first transmit).
//    uses: sA/sB
//
// This also has SPI_tx_rx() inside it as a nested
// function. The extra SPI_tx_rx call at the beginning
// essentially makes this a very cheap add.
// The first call calls forward, then the return
// returns back to execute it again.
// SPI_tx_rx_twice is used whenever a read is done
// (read ID, read status register).
void SPI_tx_rx_twice() {
  SPI_tx_rx();
 SPI_tx_rx:  
  // SPI_tx_rx works by using sB as an
  // 8 bit counter, and outputting
  // sA while shifting it. Because
  // we write it to the data-only
  // register, the remaining
  // bits don't matter.
  
  sB = 8;
  SPI_ENABLE();
  do {
    // Only the data bit (SPI_mosi, 0x80) matters
    output(SPI_data_port, sA);
    input(SPI_input_port, sSpare);
    psm("test %1, %2", sSpare, SPI_miso);
    psm("sla %1", sA);
    SPI_CLOCK_PULSE();
  } while (--sB);
}

#endif
