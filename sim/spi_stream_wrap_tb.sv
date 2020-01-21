`timescale 1ns/1ps

// for the AXI4-Stream VIP
import axi4stream_vip_pkg::*;
import merger_stream_generator_pkg::*;

module spi_stream_wrap_tb;

    wire aclk;
    tb_rclk #(.PERIOD(12.5)) u_clk(.clk(aclk));
    reg aresetn = 1'b1;
    
    wire [15:0] in_tdata;
    wire        in_tlast;
    wire        in_tready;
    wire        in_tvalid;
    wire [1:0]  in_tuser;
    assign in_tuser[1] = 1'b0;
        
    wire [15:0] out_tdata;
    wire        out_tlast;
    wire        out_tready = 1;
    wire        out_tvalid;
    wire [1:0]  out_tuser;

    merger_stream_generator_mst_t mst_agent;
    
    merger_stream_generator gen( .aclk(aclk),.aresetn(aresetn),
                                    .m_axis_tdata(in_tdata),
                                    .m_axis_tlast(in_tlast),
                                    .m_axis_tuser(in_tuser[0]),
                                    .m_axis_tready(in_tready),
                                    .m_axis_tvalid(in_tvalid));

    wire cs_b;
    wire sclk;
    wire mosi;
    wire miso;

    spi_stream_wrap u_wrap(.aclk(aclk),.aresetn(aresetn),
                            .s_axis_ctrl_tdata(in_tdata),
                            .s_axis_ctrl_tuser(in_tuser),
                            .s_axis_ctrl_tlast(in_tlast),
                            .s_axis_ctrl_tready(in_tready),
                            .s_axis_ctrl_tvalid(in_tvalid),
                            
                            .m_axis_ctrl_tready(1'b1),
                            
                            .s_axis_stat_tdata({16{1'b0}}),
                            .s_axis_stat_tuser({2{1'b0}}),
                            .s_axis_stat_tlast(1'b0),
                            .s_axis_stat_tvalid(1'b0),
                            
                            .m_axis_stat_tdata(out_tdata),
                            .m_axis_stat_tuser(out_tuser),
                            .m_axis_stat_tlast(out_tlast),
                            .m_axis_stat_tready(out_tready),
                            .m_axis_stat_tvalid(out_tvalid),
                            
                            .spi_cs_b_o(cs_b),
                            .spi_sclk_o(sclk),
                            .spi_miso_i(miso),
                            .spi_mosi_o(mosi));

    wire hold;
    pullup(hold);
    wire w;
    pullup(w);
    
    pulldown(miso);

    N25Qxxx u_memory( .S(cs_b),.C_(sclk), .DQ0(mosi),.DQ1(miso),.Vcc(3300),.HOLD_DQ3(hold),.Vpp_W_DQ2(w));

    // dig out the programming status stuff
    wire PROGB = u_wrap.u_bootload.u_icap.SIM_CONFIGE2_INST.prog_b_t;
    wire DONE = u_wrap.u_bootload.u_icap.SIM_CONFIGE2_INST.DONE;
    wire GSR = u_wrap.u_bootload.u_icap.SIM_CONFIGE2_INST.GSR;
    wire GTS = u_wrap.u_bootload.u_icap.SIM_CONFIGE2_INST.GTS;
    wire GWE = u_wrap.u_bootload.u_icap.SIM_CONFIGE2_INST.GWE;

    localparam [15:0] HELIX_HEADER = 16'hC751;
    localparam [3:0] HELIX_SOF = 4'hF;
    localparam [3:0] HELIX_EOF = 4'h8;
    localparam [1:0] TYPE_NOP = 2'b00;
    localparam [1:0] TYPE_WRITE = 2'b01;
    localparam [1:0] TYPE_READ = 2'b10;
    localparam [1:0] TYPE_UPDATE = 2'b11;
    
    // msb/lsb here is technically wrong, because we swap it
    // due to AXI4-Stream spec
    task control_write;
        input [21:0] address;
        input [15:0] data;
        reg [7:0] msb;
        reg [7:0] lsb;
        axi4stream_transaction wr_transaction;
        begin
            wr_transaction = mst_agent.driver.create_transaction("control_write");
            wr_transaction.set_delay(0);
            lsb = HELIX_HEADER[15:8];
            msb = HELIX_HEADER[7:0];
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b1 );
            mst_agent.driver.send(wr_transaction);
            // control_word_1: [15:12] = SOF. [11:10] = type. [9:0] = address[21:12] ( lane[3:0]/brd[2:0]/chip[2:0] )
            lsb = { HELIX_SOF, TYPE_WRITE, address[21:20] };
            msb = address[19:12];
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
            // control_word_2: [15:12] = data[15:12], [11:0] = address[11:0]
            // lsb = address[11:4]
            // msb = {address[3:0],data[15:12]}
            lsb = address[11:4];
            msb = {address[3:0], data[15:12]};
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
            // control_word_3
            lsb = data[11:4];
            msb = {data[3:0] , HELIX_EOF };
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b1 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
        end
    endtask
    
    // msb/lsb here is technically wrong, because we swap it
    // due to AXI4-Stream spec
    task control_read;
        input [21:0] address;
        input [15:0] data;
        axi4stream_transaction wr_transaction;
        reg [7:0] msb;
        reg [7:0] lsb;
        begin
            wr_transaction = mst_agent.driver.create_transaction("control_read");
            wr_transaction.set_delay(0);
            lsb = HELIX_HEADER[15:8];
            msb = HELIX_HEADER[7:0];
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b1 );
            mst_agent.driver.send(wr_transaction);
            // control_word_1: [15:12] = SOF. [11:10] = type. [9:0] = address[21:12] ( lane[3:0]/brd[2:0]/chip[2:0] )
            lsb = { HELIX_SOF, TYPE_READ, address[21:20] };
            msb = address[19:12];
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
            lsb = address[11:4];
            msb = {address[3:0], data[15:12]};
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b0 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
            // control_word_3: [15:12] = EOF. [11:0] = data[11:0]
            // control_word_3
            lsb = data[11:4];
            msb = {data[3:0] , HELIX_EOF };
            wr_transaction.set_data( { msb, lsb } );
            wr_transaction.set_last( { 1'b1 } );
            wr_transaction.set_user_beat( 1'b0 );
            mst_agent.driver.send(wr_transaction);
        end
    endtask
    
    initial begin
        mst_agent = new("master vip agent", gen.inst.IF);
        mst_agent.start_master();
    
        #1500;
    
        #100; aresetn = 1'b0; #1000; @(posedge aclk); #1 aresetn = 1'b1;
        
        #1000;
        control_write( 22'h000FFD, 16'h0 );
        control_write( 22'h000FFE, 16'h0 );
        control_write( 22'h000FFF, 16'h9E9E );
        control_read( 22'h000FFF, 16'h0 );
    end
                                
                            
endmodule