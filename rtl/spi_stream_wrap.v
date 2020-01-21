`timescale 1ns/1ps

// Wrapper to peel off SPI control packets and respond with status packets.
// Note that the "tuser" bits here are user-defined - by default they're
// used as start-of-frame (tuser[0]) and CRC error (tuser[1]),
// with a valid packet being defined by tuser[0] set in the first beat
// and only the first beat, and nothing else.
//
// If tuser[1] isn't used at all just set any inputs for it to 0,
// and ignore any outputs, or set the bits high in TUSER_MASK.
// If tuser[0] isn't used set the bits high in TUSER_MASK.
// If no tuser bits are used just set TUSER_MASK = 8'hFF and set the inputs
// to whatever.

module spi_stream_wrap( input aclk,
                        input aresetn,
                        input [15:0] s_axis_ctrl_tdata,
                        input [1:0]  s_axis_ctrl_tuser,
                        input        s_axis_ctrl_tlast,
                        input        s_axis_ctrl_tvalid,
                        output       s_axis_ctrl_tready,
                                                
                        output [15:0] m_axis_ctrl_tdata,
                        output [1:0]  m_axis_ctrl_tuser,
                        output        m_axis_ctrl_tlast,
                        output        m_axis_ctrl_tvalid,
                        input         m_axis_ctrl_tready,

                        input [15:0] s_axis_stat_tdata,
                        input [1:0]  s_axis_stat_tuser,
                        input        s_axis_stat_tlast,
                        input        s_axis_stat_tvalid,
                        output       s_axis_stat_tready,
                        
                        output [15:0] m_axis_stat_tdata,
                        output [1:0]  m_axis_stat_tuser,
                        output        m_axis_stat_tlast,
                        output        m_axis_stat_tvalid,
                        input         m_axis_stat_tready,
                        
                        output spi_cs_b_o,
                        output spi_sclk_o,
                        output spi_mosi_o,
                        input spi_miso_i
                        );
                        
    // by default ignore lane/chip/brd and bottom 2 bits
    parameter [21:0] ADDRESS_MASK = 22'h3FF003;
    // by default match FFC-FFF
    parameter [21:0] ADDRESS_MATCH = 22'h000FFC;
    // by default pay attention to all tuser bits
    parameter [7:0] TUSER_MASK = 8'h00;
    // by default match only tuser[0] in first beat
    parameter [7:0] TUSER_MATCH = 8'h01;
    // by default copy all tuser bits to the output tuser from SPI
    parameter [7:0] TUSER_OUT_MASK = 8'h00;
    // these are the values for TUSER not copied from input
    parameter [7:0] TUSER_OUT = 8'h00;
    // by default match the constant values    
    parameter HELIX_MATCH = "TRUE";
    // for the ICAP simulation
    parameter [31:0] IDCODE = 32'h0362D093;
    // SPI bootloader behavior
    parameter WAIT_RESPONSE = "TRUE";
            
    // constant values    
    parameter [15:0] HELIX_HEADER = 16'hC751;
    parameter [3:0] HELIX_SOF = 4'hF;
    parameter [3:0] HELIX_EOF = 4'h8;    
                        
    wire [63:0] control_tdata;
    // sigh
    wire [7:0] control_tkeep;
    wire [7:0] control_tuser;
    wire       control_tlast;
    wire       control_tvalid;
    wire       control_tready;

    spi_wrap_inwidthconv u_inwidthconv(.aclk(aclk),.aresetn(aresetn),
                                        .s_axis_tdata(s_axis_ctrl_tdata),
                                        .s_axis_tuser(s_axis_ctrl_tuser),
                                        .s_axis_tlast(s_axis_ctrl_tlast),
                                        .s_axis_tready(s_axis_ctrl_tready),
                                        .s_axis_tvalid(s_axis_ctrl_tvalid),
                                        .m_axis_tdata(control_tdata),
                                        .m_axis_tkeep(control_tkeep),
                                        .m_axis_tuser(control_tuser),
                                        .m_axis_tlast(control_tlast),
                                        .m_axis_tvalid(control_tvalid),
                                        .m_axis_tready(control_tready));

    wire [21:0] control_address = {control_tdata[16 +: 10],control_tdata[36 +: 12]};

    // match_constant/match_tuser/match_tkeep feed into 3 tuser bits which feed
    // the register slice.
    // match_address feeds the TDEST bit.
    wire match_constant = ((control_tdata[0 +: 16] == HELIX_HEADER) && (control_tdata[48 +: 4] == HELIX_EOF) && (control_tdata[28 +: 4] == HELIX_SOF))
                        || (HELIX_MATCH != "TRUE");
    
    wire match_tuser = ((control_tuser & ~TUSER_MASK) == (TUSER_MATCH & ~TUSER_MASK));
    wire match_tkeep = (control_tkeep == 8'hFF);
    wire match_address = ((control_address & ~ADDRESS_MASK) == (ADDRESS_MATCH & ~ADDRESS_MASK));
    
    wire [63:0] slicein_tdata = control_tdata;
    // tuser[7:0] are the input TUSER bits
    // tuser[8] = match_constant
    // tuser[9] = match_tuser
    // tuser[10] = match_tkeep
    wire [10:0] slicein_tuser = { match_tkeep, match_tuser, match_constant, control_tuser };
    wire        slicein_tlast = control_tlast;
    wire        slicein_tvalid = control_tvalid;
    wire        slicein_tready;
    assign control_tready = slicein_tready;
    // destination is match_address
    wire        slicein_tdest = match_address;
    
    wire [63:0] sliceout_tdata;
    wire [10:0] sliceout_tuser;
    wire        sliceout_tlast;
    wire        sliceout_tvalid;
    wire        sliceout_tready;
    wire        sliceout_tdest;
    
    spi_wrap_slice u_slicein(.aclk(aclk),.aresetn(aresetn),
                            .s_axis_tdata(slicein_tdata),
                            .s_axis_tuser(slicein_tuser),
                            .s_axis_tvalid(slicein_tvalid),
                            .s_axis_tready(slicein_tready),
                            .s_axis_tdest(slicein_tdest),
                            .s_axis_tlast(slicein_tlast),
                            .m_axis_tdata(sliceout_tdata),
                            .m_axis_tuser(sliceout_tuser),
                            .m_axis_tlast(sliceout_tlast),
                            .m_axis_tvalid(sliceout_tvalid),
                            .m_axis_tready(sliceout_tready),
                            .m_axis_tdest(sliceout_tdest));

    // This dumps all non-matching packets.
    // Packets have to have TKEEP = 8'hFF, matched constant (unless bypassed), matched tuser, and tlast = 1.
    wire [63:0] switchin_tdata = sliceout_tdata;
    wire [7:0]  switchin_tuser = sliceout_tuser[7:0];
    wire        switchin_tlast = sliceout_tlast;
    wire        switchin_tvalid = sliceout_tvalid && (&sliceout_tuser[10:8] && sliceout_tlast);
    wire        switchin_tready;
    // 10:8 are match keep/user/constant
    assign      sliceout_tready = (&sliceout_tuser[10:8] && sliceout_tlast) ? switchin_tready : 1'b1;
    wire        switchin_tdest = sliceout_tdest;

    // the SPI core doesn't use the TUSER bits other than the matched fields
    wire [63:0] spi_in_tdata;
    wire [7:0]  spi_in_tuser;
    wire        spi_in_tlast;
    wire        spi_in_tvalid;
    wire        spi_in_tready;
    
    wire [63:0] outwidth_tdata;
    wire [7:0]  outwidth_tuser;
    wire        outwidth_tlast;
    wire        outwidth_tready;
    wire        outwidth_tvalid;
    
    spi_wrap_switchin u_switchin(.aclk(aclk),.aresetn(aresetn),
                                .s_axis_tdata(switchin_tdata),
                                .s_axis_tuser(switchin_tuser),
                                .s_axis_tlast(switchin_tlast),
                                .s_axis_tvalid(switchin_tvalid),
                                .s_axis_tready(switchin_tready),
                                .s_axis_tdest(switchin_tdest),
                                .m_axis_tdata( {spi_in_tdata, outwidth_tdata} ),
                                .m_axis_tuser( {spi_in_tuser, outwidth_tuser} ),
                                .m_axis_tlast( {spi_in_tlast, outwidth_tlast} ),
                                .m_axis_tvalid( {spi_in_tvalid, outwidth_tvalid} ),
                                .m_axis_tready( {spi_in_tready, outwidth_tready} ));
    spi_wrap_outwidthconv u_outwidthconv(.aclk(aclk),.aresetn(aresetn),
                                .s_axis_tdata(outwidth_tdata),
                                .s_axis_tuser(outwidth_tuser),
                                .s_axis_tlast(outwidth_tlast),
                                .s_axis_tready(outwidth_tready),
                                .s_axis_tvalid(outwidth_tvalid),
                                .m_axis_tdata(m_axis_ctrl_tdata),
                                .m_axis_tuser(m_axis_ctrl_tuser),
                                .m_axis_tlast(m_axis_ctrl_tlast),
                                .m_axis_tready(m_axis_ctrl_tready),
                                .m_axis_tvalid(m_axis_ctrl_tvalid));

    wire [63:0] spi_out_tdata;
    wire [7:0]  spi_out_tuser;
    wire        spi_out_tlast = 1;
    wire        spi_out_tready;
    wire        spi_out_tvalid;
    
    wire [15:0] control_data;
    wire [15:0] status_data;
    wire        status_valid;
    wire [1:0]  address;
    wire        enable;
    wire        write;    
    wire        reset;
    spi_wrap_decode #(.TUSER_OUT_MASK(TUSER_OUT_MASK),.TUSER_OUT(TUSER_OUT)) u_decoder(.aclk(aclk),.aresetn(aresetn),
                                .s_axis_tdata(spi_in_tdata),
                                .s_axis_tuser(spi_in_tuser),
                                .s_axis_tlast(spi_in_tlast),
                                .s_axis_tvalid(spi_in_tvalid),
                                .s_axis_tready(spi_in_tready),
                                .m_axis_tdata(spi_out_tdata),
                                .m_axis_tuser(spi_out_tuser),
                                .m_axis_tready(spi_out_tready),
                                .m_axis_tvalid(spi_out_tvalid),
                                .en_o(enable),
                                .wr_o(write),
                                .adr_o(address),
                                .dat_o(control_data),
                                .dat_i(status_data),
                                .dat_valid_i(status_valid),
                                .rst_o(reset));
                                
    wire [15:0] spi_status_tdata;
    wire [1:0] spi_status_tuser;
    wire spi_status_tlast;
    wire spi_status_tready;
    wire spi_status_tvalid;

    spi_wrap_outwidthconv u_spioutconv(.aclk(aclk),.aresetn(aresetn),
                                .s_axis_tdata(spi_out_tdata),
                                .s_axis_tuser(spi_out_tuser),
                                .s_axis_tlast(spi_out_tlast),
                                .s_axis_tready(spi_out_tready),
                                .s_axis_tvalid(spi_out_tvalid),
                                .m_axis_tdata(spi_status_tdata),
                                .m_axis_tuser(spi_status_tuser),
                                .m_axis_tlast(spi_status_tlast),
                                .m_axis_tready(spi_status_tready),
                                .m_axis_tvalid(spi_status_tvalid));                                

    spi_wrap_switchout u_switchout(.aclk(aclk),.aresetn(aresetn),
                                    .s_axis_tdata( {spi_status_tdata, s_axis_stat_tdata }),
                                    .s_axis_tuser( {spi_status_tuser, s_axis_stat_tuser }),
                                    .s_axis_tlast( {spi_status_tlast, s_axis_stat_tlast }),
                                    .s_axis_tvalid( {spi_status_tvalid, s_axis_stat_tvalid }),
                                    .s_axis_tready( {spi_status_tready, s_axis_stat_tready }),
                                    .m_axis_tdata( m_axis_stat_tdata ),
                                    .m_axis_tuser( m_axis_stat_tuser ),
                                    .m_axis_tlast( m_axis_stat_tlast ),
                                    .m_axis_tvalid( m_axis_stat_tvalid ),
                                    .m_axis_tready( m_axis_stat_tready ),
                                    .s_req_suppress( 2'b00 ) );
                                    
    spi_bootload u_bootload( .clk_i(aclk),.rst_i(reset),
                            .en_i(enable),.wr_i(write),.dat_i(control_data),.dat_o(status_data),.dat_valid_o(status_valid),.adr_i(address),
                            .spi_cs_b_o(spi_cs_b_o),
                            .spi_sclk_o(spi_sclk_o),
                            .spi_miso_i(spi_miso_i),
                            .spi_mosi_o(spi_mosi_o));
        
endmodule
                        
                        