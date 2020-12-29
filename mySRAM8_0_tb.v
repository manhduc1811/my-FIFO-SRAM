/************************************************************************************************
************************************************************************************************/
module mySRAM_tb;
    parameter       BITS = 12, WORD_DEPTH = 8, ADDR_WIDTH = 3;
    reg             clk,rst_n;
    reg             read;
    reg             write;
    reg  [BITS-1:0] data_in;
    wire [BITS-1:0] data_out;
    wire            ready;
    wire            overflow;
    mySRAM #(
		.BITS(BITS),
		.WORD_DEPTH(WORD_DEPTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	) 
	UUT (
		.clk(clk),
		.rst_n(rst_n),
		.read(read),
		.write(write),
		.data_in(data_in),
		.data_out(data_out),
		.ready(ready),
		.overflow(overflow)
	);
    always #10 clk  = !clk;
    initial begin
            clk     = 0;
            rst_n   = 0;
            read    = 0;
            write   = 0;
        #20 rst_n   = 1;
            data_in = 12'h0e0;
            write   = 1;
        #20 data_in = 12'h0e1;
        #20 data_in = 12'h0e2;
        #20 data_in = 12'h0e3;
        #20 data_in = 12'h0e4;
        #20 data_in = 12'h0e5;
            read    = 1;
        #20 data_in = 12'h0e6;
        #20 data_in = 12'h0e7;
        #20 data_in = 12'h0e8;
            read    = 0;
        #20 data_in = 12'h0e9;
        #20 data_in = 12'h0ea;
        #20 data_in = 12'h0eb;
        #20 data_in = 12'h0ec;
        #20 data_in = 12'h0ed;
        #20 data_in = 12'h0ee;
        #20 data_in = 12'h0ef;
        #20 data_in = 12'h0f0;
            read    = 1;
        #20 data_in = 12'h0f1;
        #20 data_in = 12'h0f2;
            read    = 0;
        #20 data_in = 12'h0f3;
            read    = 1;
        #20 data_in = 12'h0f4;
            write   = 0;
		#20 $stop;	
    end
endmodule