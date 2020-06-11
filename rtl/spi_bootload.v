`timescale 1ns / 1ps
// we use 4 16-bit registers for access to SPI. Data is always read/written pages (256 bytes) at a time!
// This is flash memory - you have to ERASE before PROGRAM. ERASING is done once for each sector (64 kB).
// This means programming 64 kB takes ~180 milliseconds, and fully programming the TOF bitstream will
// take ~6 seconds or longer. Please note this is still STUPID FAST.
//
// 0: FIFO keyhole. Write data into FIFO to be written to SPI. Read data from FIFO from SPI.
//    When written into SPI, [15:8] is the second word in, [7:0] is the first word in.
//    Ditto for the reverse.
// 1: Argument or result from operation, [15:0].
// 2: Argument or result from operation, [31:16].
// 3: Operation/status register.
//
// Operations are the same as SPI operations, but only some are supported:
// 0x02 PAGE PROGRAM (takes ~0.12 ms typ, max 1.8 ms) (or 0x12 4-BYTE-ADDR PAGE PROGRAM)
// 0x03 READ (takes ~0.05 ms) (or 0x13 4-BYTE-ADDR READ)
// 0xD8 SECTOR ERASE (64 kB: (or 0xDC 4-BYTE-ADDR SECTOR ERASE)
// 0x9E READ ID
// 0xE3 WRITE NONVOLATILE LOCK BITS
// 0xE4 ERASE NONVOLATILE LOCK BITS
// 0xFF ICAP_REBOOT
//
// Note that the 4-byte-addr operations can be used for the 3-byte devices too, but
// the top byte of the argument must be 0xFF.
//
// [15:8] is a check byte: it's equal to [7:0] ^ ADDR[31:24] ^ ADDR[23:16] ^ ADDR[15:8] ^ ADDR[7:0]
// ALL THREE registers must be written for a command to be processed, even if there
// is no argument (read ID/enter/release from power down).
//
//
// Status register
// [0]: Command busy.
// [1]: Last command complete.
// [2]: Last command match error.
// [3]: Last command timed out.
//
// Reading the status register will take until the command completes
// UNLESS the data IN the read is set to 0xFFFF. (Holy crap, we're abusing the
// packet format).
//
// IF you write 0x6699 to the operation register FOUR TIMES (this is not
// a joke, 0x66 is RESET ENABLE and 0x99 is RESET MEMORY, don't blame me)
// the controller will interrupt itself, execute RESET ENABLE / RESET MEMORY
// and go back to normal behavior.
//
// Note: commands CAN and WILL take a macroscopic amount of time to complete.
// Resetting should NEVER be necessary unless something goes horribly wrong,
// because the code has an internal timeout on all operations: 10 ms on
// page program/write nonvolatile lock bits operations, and 2 ** seconds ** on 
// sector erase/erase nonvolatile lock bits operations.
//
// So nominally the basic sequence would be something like
// 6: write 0 to 1
// 7: write 0 to 2
// 8: write 0x9E9E to 3
// 9: read 3, check for error.
// 10: read 1 and 2 and confirm device ID.
// 11: write ADDR[15:0] to 1
// 12: write ADDR[23:16] to 2
// 13: write 0x[check]D8 (where [check] = D8^ADDR[23:16]^ADDR[15:8]^ADDR[7:0].)
// 14: read 3, check for error.
// 15: write 128x to 0
// 16: write ADDR[15:0] to 1
// 17: write ADDR[23:16] to  2
// 18: write 0x[check]02 (where [check] = 02^ADDR[23:16]^ADDR[15:8]^ADDR[7:0].)
// 19: read 3, check for error.
// then repeat from step 15 256x
// then repeat from step 11 for however many sectors.

// OMG the PicoBlaze portion of this needs to be rewritten.
//
// target plan:
// constant output port at addr 1 for clock and cs (if (k_write_strobe && port_id[0]))
// hybrid output port at addr 2 for data           (if ((k_write_strobe || write_strobe) && h_port_id[5:4]==00 && port_id[1])
// constant output port at addr 4 for icap         (if (k_write_strobe && port_id[2]))
// input port at addr 0 for spi                    (if port_id[5:4] == 0)
// input port at addr 10/11 for command (these are actually used as 1E/1F) if (port_id[5:4] == 1)
// output port at addr 10 for command pending      (if write_strobe && port_id[5:4] == 1) and !port_id[0]
// output port at addr 11 for command status       (if write_strobe && port_id[5:4] == 1) and port_id[0]
// input/output port at addr 20/21/22/23 for arguments if write_strobe && port_id[5:4] == 2 and if (port_id[5:4] == 2)
// input/output port at addr 30 for FIFO           (if write_strobe && port_id[5:4] == 3

// this is then very compact.
// reg [7:0] in_port = {8{1'b0}};
// always @(posedge clk_i) begin
//   case (port_id[5:4])
//     2'b00: in_port <= spi_input_port;
//     2'b01: in_port <= (port_id[0]) ? command[15:8] : command[7:0];
//     2'b10: 
//         case(port_id[1:0])
//           2'b00: in_port <= arg0[7:0];
//           2'b01: in_port <= arg0[15:8];
//           2'b10: in_port <= arg1[7:0];
//           2'b11: in_port <= arg1[15:8];
//         endcase
//     2'b11: in_port <= fifo_data_out;
//  endcase
// end

module spi_bootload( input clk_i,
                     input rst_i,
                     // when en_i && wr_i, data on dat_i is written into the address adr_i
                     // when en_i && !wr_i, data from address adr_i is placed on dat_o,
                     //    and valid when dat_valid_o.
                     // if WAIT_RESPONSE = "TRUE", then dat_valid_o can come WAAAY later
                     // than en_i (it's pushed out when the PicoBlaze writes to it).
                     // otherwise it's valid 1 clock later, and it's just a shadow of the
                     // PicoBlaze register.
                     // WAIT_RESPONSE = "TRUE" is helpful if the interface is written
                     // to be able to arbitrarily wait. Then software just has to make sure
                     // that it doesn't send more control packets than can be buffered.
                     input en_i,
                     input [1:0] adr_i,
                     input       wr_i,
                     input [15:0] dat_i,
                     output [15:0] dat_o,
                     output dat_valid_o,

                     output spi_cs_b_o,
                     output spi_sclk_o,
                     output spi_mosi_o,
                     input spi_miso_i);

    parameter WAIT_RESPONSE = "TRUE";
    parameter [31:0] IDCODE = 32'h0362D093;
    
    localparam [15:0] RESET_MATCH = 16'h6699;

    reg cs_b = 1;
    reg sclk = 0;
    reg mosi = 0;
    reg miso = 0;

    reg poweron_reset = 1;
    reg [7:0] poweron_reset_delay = {8{1'b0}};
    always @(posedge clk_i) begin
        if (poweron_reset) poweron_reset_delay <= poweron_reset_delay[6:0] + 1;
        if (poweron_reset_delay[7]) poweron_reset <= 0;
    end

    wire local_rst = (poweron_reset || rst_i);

    wire [7:0] fifo_data_out;
    wire fifo_data_valid;
    wire [15:0] fifo_addr_data = { {7{1'b0}}, !fifo_data_valid, fifo_data_out };

    reg [15:0] arg0 = {16{1'b0}};
    reg [15:0] arg1 = {16{1'b0}};
    reg [15:0] cmd = {16{1'b0}};
    reg [3:0] cmd_pending = {8{1'b0}};    
    wire [15:0] cmd_status_out;

    wire [15:0] dat_mux[3:0];
    assign dat_mux[0] = fifo_addr_data;
    assign dat_mux[1] = arg0;
    assign dat_mux[2] = arg1;
    assign dat_mux[3] = cmd_status_out;
        
    // set by (en_i && !wr_i && (adr_i != 2'b11 || (WAIT_RESPONSE != "TRUE")  || (cmd_was_busy && !cmd_busy))
    // that is, immediate ack after any address if WAIT_RESPONSE != "TRUE",
    // else immediate ack to any address other than status,
    // and ack to status when cmd_busy falls. 
    reg dat_valid = 0;
    // captured read address
    reg [1:0] read_adr = 2'b00;
    // set by en_i && !wr_i and cleared by dat_valid
    reg read_pending = 0;
        
    reg cmd_was_busy = 0;
    reg cmd_busy = 0;
    reg cmd_complete = 0;
    reg cmd_error = 0;
    reg cmd_timeout = 0;
    wire [7:0] cmd_status = { {4{1'b0}}, cmd_timeout, cmd_error, cmd_complete, cmd_busy };
    assign cmd_status_out = { {8{1'b0}}, cmd_status };
    // capture adr_i unless read_pending, then capture read_adr
    reg [15:0] dat = {16{1'b0}};
    
    reg [1:0] reset_counter = {2{1'b0}};
    wire [2:0] reset_counter_plus_one = reset_counter + 1;
    
    wire [11:0] address;
    wire [17:0] instruction;
    wire bram_enable;
    reg [7:0] in_port = {8{1'b0}};
    wire [7:0] out_port;
    wire [7:0] port_id;
    wire write_strobe;
    wire k_write_strobe;
    wire read_strobe;
    reg interrupt = 0;
    wire interrupt_ack;
    wire sleep = 0;
    reg reset = 0;
    // derived stuff
    // outputk functions use only bottom 4 bits
    wire [7:0] kport_id = { {4{1'b0}}, port_id[3:0] };
    // combined hybrid port (can be both output/outputk)
    wire [7:0] h_port_id = (k_write_strobe) ? kport_id : port_id;    

    // SPI input port.  
    wire [7:0] spi_in_port = { {5{1'b0}}, spi_miso_i,{2{1'b0}}};

    // write 0x8000 to FIFO port to reset it.
    wire fifo_if_write = (en_i && wr_i && (adr_i == 2'b00));
    wire fifo_if_read = (en_i && !wr_i && (adr_i == 2'b00));
    wire fifo_if_reset = (en_i && wr_i && (adr_i == 2'b00) && dat_i[15]);

    reg fifo_write = 0;
    reg fifo_is_pb_write = 0;
    reg fifo_read = 0;
    reg [7:0] fifo_data = {8{1'b0}};
            
    // On the PicoBlaze side, we just blatantly assume that reads/writes will work.
    // writes/reads are to 0x30
    wire fifo_pb_write = (write_strobe && (port_id[5:4] == 3));
    wire fifo_pb_read = (read_strobe && (port_id[5:4] == 3));
 
    // ICAP stuff.
    reg icap_csib = 1;
    reg icap_rdwrb = 0;
    wire [31:0] icap_in;
    function [7:0] reverse_byte( input [7:0] byte );
        integer i;
        begin
            for (i=0;i<8;i=i+1) begin : reverse
                reverse_byte[7-i] = byte[i];
            end
        end
    endfunction
    assign icap_in[7:0] = reverse_byte(arg0[7:0]);
    assign icap_in[15:8] = reverse_byte(arg0[15:8]);
    assign icap_in[23:16] = reverse_byte(arg1[7:0]);
    assign icap_in[31:24] = reverse_byte(arg1[15:8]);    
    (* KEEP = "TRUE" *)
    ICAPE2 #(.DEVICE_ID(IDCODE),.ICAP_WIDTH("X32"),.SIM_CFG_FILE_NAME("NONE")) 
        u_icap(.I(icap_in),.O(),.CSIB(icap_csib),.RDWRB(icap_rdwrb),.CLK(clk_i));
        
    always @(posedge clk_i) begin
        //// INPUT PORTS ////

        // 0x00 - 0x0F : spi_input_port
        // 0x10/0x11/0x14/0x15/0x18/0x19/0x1C/0x1D: cmd_pending
        // 0x12/0x16/0x1A/0x1E: cmd[7:0]
        // 0x13/0x17/0x1B/0x1F: cmd[15:8]
        // 0x20/0x24/0x28/0x2C: arg0[7:0]
        // 0x21/0x25/0x29/0x2D: arg0[15:8]
        // 0x22/0x26/0x2A/0x2E: arg1[7:0]
        // 0x23/0x27/0x2B/0x2F: arg1[15:8]
        // 0x30-0x3F: fifo_input
        // all addresses are shadowed with bits 7/6.        
        case (port_id[5:4])
            2'b00: in_port <= #1 spi_in_port;
            2'b01:
                case(port_id[1:0])
                    2'b00,2'b01: in_port <= #1 {{4{1'b0}}, cmd_pending};
                    2'b10: in_port <= #1 cmd[7:0];
                    2'b11: in_port <= #1 cmd[15:8];
                endcase
            2'b10:
                case(port_id[1:0])
                    2'b00: in_port <= #1 arg0[7:0];
                    2'b01: in_port <= #1 arg0[15:8];
                    2'b10: in_port <= #1 arg1[7:0];
                    2'b11: in_port <= #1 arg1[15:8];
                endcase
            2'b11: in_port <= #1 fifo_data_out;
        endcase

        if (en_i && wr_i) begin
            if (adr_i == 2'b11 && dat_i == RESET_MATCH) reset_counter <= #1 reset_counter_plus_one;
            else reset_counter <= #1 {2{1'b0}};
        end

        if (interrupt_ack) #1 interrupt <= 0;
        else if (en_i && wr_i && adr_i == 2'b11 && dat_i == RESET_MATCH && reset_counter_plus_one[2]) interrupt <= #1 1;            

        //// OUTPUT PORTS ////

        // SPI ports. Clock/CS is a constant port at 1 (and 3).
        if (k_write_strobe && port_id[0]) begin
            sclk <= #1 out_port[0];
            cs_b <= #1 out_port[1];
        end
        // Data. Hybrid output port at 2 (and 3).
        if ( (write_strobe || k_write_strobe) && ((h_port_id[5:4] == 2'b00) && port_id[1]))
            mosi <= #1 out_port[7];

        // ICAP port. Constant port at 4.
        if (k_write_strobe && port_id[2]) begin        
            icap_rdwrb <= #1 out_port[0];
            icap_csib <= #1 0;
        end else icap_csib <= #1 1;

        // RESET port. Constant port at 8.
        if (k_write_strobe && port_id[3]) reset <= #1 out_port[0];
        else reset <= #1 0;

        // Command pending. Port at 0x10.
        // Automatically clears when written to.
        if ((write_strobe && (port_id[5:4] == 1) && (port_id[1:0] == 2'b00)) || local_rst)
            cmd_pending <= #1 {4{1'b0}};
        else if (en_i && wr_i)
            cmd_pending[adr_i] <= #1 1'b1;
        
        // Command status. Port at 0x11
        // clear status on rising edge of cmd_busy signal
        if (reset || local_rst || (cmd_busy && !cmd_was_busy)) begin
            cmd_complete <= #1 0;
            cmd_error <= #1 0;
            cmd_timeout <= #1 0;            
        end else if (write_strobe && (port_id[5:4] == 1) && (port_id[1:0] == 2'b01)) begin
            cmd_complete <= #1 out_port[1];
            cmd_error <= #1 out_port[2];
            cmd_timeout <= #1 out_port[3];
        end

        // Argument ports. I/O at 0x20-0x23.
        // arg0 capture inbound
        if (en_i && wr_i && (adr_i == 2'b01)) arg0 <= #1 dat_i;
        // picoblaze capture
        else if (write_strobe && (port_id[5:4] == 2) && !port_id[1]) begin
            if (!port_id[0]) arg0[7:0] <= #1 out_port;
            if (port_id[0]) arg0[15:8] <= #1 out_port;
        end
        // arg1 capture inbound
        if (en_i && wr_i && (adr_i == 2'b10)) arg1 <= #1 dat_i;
        // picoblaze capture
        else if (write_strobe && (port_id[5:4] == 2) && port_id[1]) begin
            if (!port_id[0]) arg1[7:0] <= #1 out_port;
            if (port_id[0]) arg1[15:8] <= #1 out_port;
        end
        
        // cmd capture inbound. picoblaze can't write this.
        if (en_i && wr_i && adr_i == 2'b11) cmd <= #1 dat_i;

        // Interface stuff. if WAIT_RESPONSE == "TRUE",
        // then a read to 0x3 will wait until cmd_busy falls,
        // which occurs when cmd_pending[3:1] clears, which occurs when PB writes it
        // (after the status write). This could be a LOOONG time.
        // Otherwise dat_valid goes high the next cycle after a read.                                 
        dat_valid <= #1 (en_i && !wr_i && (adr_i != 2'b11 || (WAIT_RESPONSE != "TRUE")))  || ((WAIT_RESPONSE == "TRUE" && read_pending && cmd_was_busy && !cmd_busy));

        // determine if a read is pending.
        // set when a read occurs, cleared when dat_valid is asserted.
        // normally dat_valid will autoclear read_pending next clock
        if (dat_valid) read_pending <= #1 0;
        else if (en_i && !wr_i) read_pending <= #1 1;
        // capture what the read address is. Probably not important since it shouldn't change
        // while waiting for a response... but this allows it to.
        if (en_i && !wr_i && !read_pending) read_adr <= #1 adr_i;

        // so this sequence goes
        // clk en_i wr_i adr_i dat_valid read_pending read_adr  dat
        // 0   1    0    1     0         0            X         X
        // 1   0    0    X     1         1            1         dat[1]
        // <-- can accept new command here
        
        // clk en_i wr_i adr_i dat_valid read_pending read_adr  dat    cmd_busy cmd_was_busy
        // 0   1    0    3     0         0            X         X      1        1
        // 1   0    0    X     0         1            3         dat[3] 1        1
        // ...
        // N   0    0    X     0         1            3         dat[3] 0        1
        // N+1 0    0    X     1         1            3         dat[3] 0        0
        // N+2 0    0    X     0         0            X         X      0        0
        // <-- can accept new command here
             
        if (read_pending) dat <= #1 dat_mux[read_adr]; else dat <= dat_mux[adr_i];

        // as soon as all 3 commands become written to, go for it
        cmd_busy <= #1 &cmd_pending[3:1];
        cmd_was_busy <= #1 cmd_busy;
        
        // FIFO multiplexing. Software needs to NOT eff this up.
        fifo_read <= #1 (fifo_if_read || fifo_pb_read);
        fifo_write <= #1 ((fifo_if_write && !fifo_if_reset) || fifo_pb_write);
        fifo_is_pb_write <= #1 fifo_pb_write;
        fifo_data <= #1 (fifo_pb_write) ? out_port : dat_i;        
    end
    
    // freaking MAGIC. These are the initial scratchpad RAM values. 
    localparam [31:0] ICAP_NOOP =   32'h20000000;
    localparam [31:0] ICAP_SYNC =   32'hAA995566;
    localparam [31:0] ICAP_CMD =    32'h30008001;
    localparam [31:0] ICAP_WBSTAR = 32'h30020001;
    localparam [31:0] ICAP_IPROG =  32'h0000000F;
    localparam [159:0] icap_commands = { 
        //  13                 12                  11                 10
            ICAP_IPROG[24 +: 8], ICAP_IPROG[16 +: 8], ICAP_IPROG[8 +: 8], ICAP_IPROG[0 +: 8],
        //  0F                 0E                  0D                 0C
            ICAP_WBSTAR[24 +: 8], ICAP_WBSTAR[16 +: 8], ICAP_WBSTAR[8 +: 8], ICAP_WBSTAR[0 +: 8],
        //  0B                 0A                  09                 08
            ICAP_CMD[24 +: 8], ICAP_CMD[16 +: 8], ICAP_CMD[8 +: 8], ICAP_CMD[0 +: 8],
        //  07                 06                  05                 04
            ICAP_SYNC[24 +: 8], ICAP_SYNC[16 +: 8], ICAP_SYNC[8 +: 8], ICAP_SYNC[0 +: 8],
        //  03                 02                  01                 00 
            ICAP_NOOP[24 +: 8], ICAP_NOOP[16 +: 8], ICAP_NOOP[8 +: 8], ICAP_NOOP[0 +: 8] };

    // I should try to find a way to embed the FIFO
    // inside kcpsm6's BRAM. The SPI flash code only takes ~25% of the BRAM,
    // so I can burn the top quarter. And it doesn't REALLY need to be a proper FIFO...    
    kcpsm6 #(.scratch_pad_initial_values( {{(2048-160){1'b0}}, icap_commands } ))
            u_picoblaze(.address(address),.instruction(instruction),.bram_enable(bram_enable),
                        .in_port(in_port),.out_port(out_port),.port_id(port_id),
                        .write_strobe(write_strobe),.k_write_strobe(k_write_strobe),
                        .read_strobe(read_strobe),.interrupt(interrupt),.interrupt_ack(interrupt_ack),
                        .sleep(sleep),.reset(local_rst || reset),.clk(clk_i));

    // sleaze the top 1/8th of the ROM as a poor man's FIFO.                        
    // we have to be perpetually enabled to act as a FWFT FIFO.
    wire bram_en = 1'b1;
    wire bram_we = (fifo_write);
    // the top bit that's output is 1 if it was written to by the PicoBlaze.
    // if you do a write, then readback, this bit indicates the data's valid.
    wire [8:0] bram_dat_in = { fifo_is_pb_write , fifo_data };
    wire [8:0] bram_dat_out;                         
    // auto counter in 8 bits.
    // address is 11 bits
    // we use the top eighth, so it's 111
    reg [7:0] auto_counter = {8{1'b0}};

    // world's easiest FIFO!
    // This works because we never mix reading and writing. It's just a buffer.
    // So you write 256 in, you execute the command, and the autocounter resets back to 0 when cmd_busy goes high.
    // PicoBlaze either reads (or writes) data in, and the autocounter resets back to 0 when cmd_busy goes low.
    // The only additional trick here is that it's a good idea before writing a page in to just reset the buffer
    // once.
    //
    // This also has the advantage that if you want to write the SAME THING into multiple pages,
    // you actually only need to send the data once.
    always @(posedge clk_i) begin
        if ((cmd_busy && !cmd_was_busy) || (!cmd_busy && cmd_was_busy) || (adr_i == 0 && en_i && wr_i && dat_i[15]))
            auto_counter <= #1 {8{1'b0}};
        else begin
            if (fifo_write || fifo_read) auto_counter <= #1 auto_counter + 1;
        end
    end
                        
    spi_bootloader u_rom(.clk(clk_i),.address(address),.enable(bram_enable),.instruction(instruction),
                         .bram_en_i(bram_en),.bram_we_i(bram_we),.bram_adr_i({3'b111,auto_counter}),
                         .bram_dat_i(bram_dat_in),.bram_dat_o(bram_dat_out));

    // we no longer need this guy, the FIFO's embedded in the block RAM for the PicoBlaze
    /*
    wire [7:0] true_fifo_data_out;
    wire       true_fifo_data_valid;
    spi_bootloader_fifo u_fifo(.clk(clk_i),.din(fifo_data),.wr_en(fifo_write),.dout(true_fifo_data_out),.rd_en(fifo_read),.srst(fifo_if_reset),
                                .valid(true_fifo_data_valid));
    */                            
    
    // OK so now let's redirect the data over to the fakey FIFO
    assign fifo_data_out = bram_dat_out[7:0];
    assign fifo_data_valid = bram_dat_out[8];

    assign spi_cs_b_o = cs_b;
    assign spi_sclk_o = sclk;
    assign spi_mosi_o = mosi;
    assign dat_o = dat;
    assign dat_valid_o = dat_valid;
    
endmodule
                                          