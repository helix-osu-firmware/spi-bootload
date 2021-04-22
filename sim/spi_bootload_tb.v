`timescale 1ns / 1ps

module spi_bootload_tb;

    parameter USE_FLASH = "TRUE";

    wire clk;
    tb_rclk #(.PERIOD(12.5)) u_clk(.clk(clk));
    
    reg rst = 1;
    wire sclk;
    wire mosi;
    wire miso;
    pulldown(miso);
    wire cs_b;
    
    wire hold;
    pullup(hold);
    wire w;
    pullup(w);

    reg [15:0] dat_in = {16{1'b0}};
    wire [15:0] dat_out;
    reg [1:0] address = {2{1'b0}};
    reg write = 0;
    reg en = 0;
    wire valid;
    
        
    spi_bootload u_spi(.clk_i(clk),.rst_i(rst),.spi_cs_b_o(cs_b),.spi_sclk_o(sclk),.spi_mosi_o(mosi),.spi_miso_i(miso),
                        .adr_i(address),.dat_i(dat_in),.dat_o(dat_out),.en_i(en),.wr_i(write),.dat_valid_o(valid));
                        
    generate
        if (USE_FLASH == "TRUE") begin : FL                        
            N25Qxxx u_memory( .S(cs_b),.C_(sclk), .DQ0(mosi),.DQ1(miso),.Vcc(3300),.HOLD_DQ3(hold),.Vpp_W_DQ2(w));
        end
    endgenerate
    // dig out the programming status stuff
    wire PROGB = u_spi.IC.u_icap.SIM_CONFIGE2_INST.prog_b_t;
    wire DONE = u_spi.IC.u_icap.SIM_CONFIGE2_INST.DONE;
    wire GSR = u_spi.IC.u_icap.SIM_CONFIGE2_INST.GSR;
    wire GTS = u_spi.IC.u_icap.SIM_CONFIGE2_INST.GTS;
    wire GWE = u_spi.IC.u_icap.SIM_CONFIGE2_INST.GWE;
    
    task write_word;
        input [1:0] addr;
        input [15:0] data;
        begin
            @(posedge clk); #1 en = 1; write = 1; address = addr; dat_in = data; @(posedge clk); #1 en = 0; write = 0;
        end
    endtask
    task read_word;
        input [1:0] addr;
        output [15:0] read_data;
        begin
            @(posedge clk); #1 en = 1; write = 0; address = addr;
            while(!valid) begin
                @(posedge clk);
                if (valid) begin
                    read_data <= dat_out;
                    $display("read from %x : %x", addr, dat_out);
                    #1 en = 0;           
                end
            end
            @(posedge clk);
        end
    endtask
    
    reg [15:0] tmp = {16{1'b0}};
    reg [31:0] idcode = {32{1'b0}};
    integer i;
    initial begin
        rst = 0;
        #5000;
        @(posedge clk) #1 rst = 1;
        @(posedge clk) #1 rst = 0;
        #150000;
        // test FIFO
        write_word(0, 16'h8000);
        write_word(0, 16'h0055);
        write_word(0, 16'h00AA);
        write_word(0, 16'h8000);
        read_word(0, tmp);
        $display("readback: %x", tmp);
        if (tmp != 16'h0155) begin
            $error("readback incorrect, expected 0155");
        end
        read_word(0, tmp);
        $display("readback: %x", tmp);
        if (tmp != 16'h01AA) begin
            $error("readback incorrect, expected 01AA");
        end        
        read_word(0, tmp);
        $display("readback: %x", tmp);
        if (tmp != 16'h0100) begin
            $error("readback incorrect, expected 0100");
        end
        write_word(1, 16'h0000);
        write_word(2, 16'h0000);
        write_word(3, 16'h9E9E);
        read_word(3, tmp);
        read_word(1, idcode[15:0]);
        read_word(2, idcode[31:16]);
        $display("IDCODE: %x", idcode);
        
        #100;
        for (i=0;i<256;i=i+1) begin        
            write_word(0, i);
        end
        write_word(1, 16'h0000);
        write_word(2, 16'h0001);
        write_word(3, 16'h0302);    // top byte is checksum
        read_word(3, tmp);
        $display("Result: %x", tmp);        
        // clear the fake-FIFO
        #100;
        for (i=0;i<256;i=i+1) begin
            write_word(0, 0);
        end
        // and reset the real-FIFO
        write_word(0, 16'h8000);
        
        // now readread
        write_word(1, 16'h0000);
        write_word(2, 16'h0001);
        write_word(3, 16'h0203);    // top byte is checksum
        read_word(3, tmp);
        $display("Result: %x", tmp);
        #100;
        for (i=0;i<256;i=i+1) begin
            read_word(0, tmp);
            $display("word %d: %x", i, tmp);
        end
        #100;

        // try sector erase, now with ACTUAL SECTOR ERASE command
        write_word(1, 16'h0000);
        write_word(2, 16'h0000);
        write_word(3, 16'hD8D8);
        read_word(3, tmp);

        // unlock ICAP
        write_word(1, 16'h6533);
        write_word(2, 16'h4279);
        write_word(3, 16'h93FE);
        read_word(3, tmp);
        
        // issue reboot
        write_word(1, 16'h0000);
        write_word(2, 16'h0000);
        write_word(3, 16'hFFFF);
        read_word(3, tmp);

        // note: in a behavioral sim, nothing ACTUALLY happens here.

    end    
    
endmodule
