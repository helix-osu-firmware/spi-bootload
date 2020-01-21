`timescale 1ns/1ps

module spi_wrap_decode( input aclk,
                        input aresetn,
                        input [63:0] s_axis_tdata,
                        output       s_axis_tready,
                        input        s_axis_tvalid,
                        input        s_axis_tlast,
                        input [7:0]  s_axis_tuser,
                        
                        output [63:0] m_axis_tdata,
                        input         m_axis_tready,
                        output        m_axis_tvalid,
                        output [7:0]  m_axis_tuser,
                        output        m_axis_tlast,
                        
                        output        rst_o,
                        output [15:0] dat_o,
                        input [15:0]  dat_i,
                        input         dat_valid_i,
                        output [1:0]  adr_o,
                        output        en_o,
                        output        wr_o );

    parameter [7:0] TUSER_OUT_MASK = {8{1'b0}};
    parameter [7:0] TUSER_OUT = {8{1'b0}};    

    localparam [15:0] STATUS_HEADER = 16'h57A7;
    localparam [3:0] STATUS_SOF = 4'hF;
    localparam [3:0] STATUS_EOF = 4'hF;

    localparam FSM_BITS = 2;
    localparam [FSM_BITS-1:0] RESET = 0;
    localparam [FSM_BITS-1:0] IDLE = 1;             // nothing, or only a write
    localparam [FSM_BITS-1:0] OUT_WAIT_VALID = 2;   // read seen and issued, waiting for dat_valid_i (always 1 clock latency)
    localparam [FSM_BITS-1:0] OUT_WAIT_READY = 3;   // dat valid was seen, waiting for out ready
    reg [FSM_BITS-1:0] state = RESET;

    reg [7:0] out_tuser = {8{1'b0}};
    reg [15:0] out_data = {16{1'b0}};
    reg [21:0] out_addr = {22{1'b0}};
    // in_addr is tx_word1[3:0] and tx_word2[15:4].
    // tx_word1[3:0] = 16 +: 4
    // tx_word2[15:4] = 36 +: 12
    wire [21:0] in_addr = {s_axis_tdata[16 +: 10],s_axis_tdata[36 +: 12]};
        
    wire [1:0] type = s_axis_tdata[26 +: 2];
    localparam [1:0] TYPE_NOP = 2'b00;
    localparam [1:0] TYPE_WRITE = 2'b01;
    localparam [1:0] TYPE_READ = 2'b10;
    localparam [1:0] TYPE_UPDATE = 2'b11;
    
    // This is the wrap decode, the matching and address decoding's done upstream    
    always @(posedge aclk) begin
        if (!aresetn) state <= #1 RESET;
        else case (state)
            RESET: state <= #1 IDLE;
            IDLE: if (s_axis_tvalid && (type == TYPE_READ)) state <= #1 OUT_WAIT_VALID;
            OUT_WAIT_VALID: if (dat_valid_i) state <= #1 OUT_WAIT_READY;
            OUT_WAIT_READY: if (m_axis_tready) state <= #1 IDLE;
        endcase
        
        if (dat_valid_i) out_data <= #1 dat_i;
        if (state == IDLE && s_axis_tvalid) out_addr <= #1 in_addr;
        
        if (state == IDLE && s_axis_tvalid) out_tuser <= #1 (s_axis_tuser & ~TUSER_OUT_MASK) | (TUSER_OUT_MASK & TUSER_OUT);        
    end
    
    assign m_axis_tdata[0 +: 16] = STATUS_HEADER;
    assign m_axis_tdata[16 +: 16] = { STATUS_SOF, TYPE_READ, out_addr[12 +: 10] };
    assign m_axis_tdata[32 +: 16] = { out_addr[0 +: 12], out_data[12 +: 4] };
    assign m_axis_tdata[48 +: 16] = { out_data[0 +: 12], STATUS_EOF };
    assign m_axis_tvalid = (state == OUT_WAIT_READY);
    assign m_axis_tuser = out_tuser;
    assign m_axis_tlast = 1'b1;
    
    assign s_axis_tready = (state == IDLE);
    
    assign en_o = (state == IDLE && s_axis_tvalid);
    assign wr_o = (type == TYPE_WRITE || type == TYPE_UPDATE);
    assign dat_o = {s_axis_tdata[32 +: 4],s_axis_tdata[52 +: 12]};
    assign adr_o = in_addr[1:0];
    assign rst_o = (state == RESET);
endmodule
