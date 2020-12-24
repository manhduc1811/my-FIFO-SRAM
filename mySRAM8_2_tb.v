/************************************************************************************************
************************************************************************************************/
module mySRAM_tb;
    parameter       BITS = 12, word_depth = 8, addr_width = 3;
    reg             clk,rst_n;
    reg             read;
    reg             write;
    reg  [BITS-1:0] data_in;
    wire [BITS-1:0] data_out;
    wire            ready;
    wire            overflow;
    mySRAM #(
		.BITS(BITS),
		.word_depth(word_depth),
		.addr_width(addr_width)
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
        #20 data_in = 12'h001; 
        #20 data_in = 12'h002; 
        #20 data_in = 12'h003;	write   = 1; 
        #20 data_in = 12'h004;	 
        #20 data_in = 12'h005; 
        #20 data_in = 12'h006; 
        #20 data_in = 12'h007; 	read = 1;
        #20 data_in = 12'h008; 
        #20 data_in = 12'h009; 
        #20 data_in = 12'h00a; 
        #20 data_in = 12'h00b; 
        #20 data_in = 12'h00c; 	
        #20 data_in = 12'h00d; 	
        #20 data_in = 12'h00e; 
        #20 data_in = 12'h00f; 	read = 0;
        #20 data_in = 12'h010; 	
        #20 data_in = 12'h011; 
        #20 data_in = 12'h012; 
        #20 data_in = 12'h013; 
        #20 data_in = 12'h014; 
        #20 data_in = 12'h015; 	read = 1;
        #20 data_in = 12'h016; 
        #20 data_in = 12'h017; 
        #20 data_in = 12'h018;
        #20 data_in = 12'h019; 
        #20 data_in = 12'h01a; 
        #20 data_in = 12'h01b; 
        #20 data_in = 12'h01c; 
        #20 data_in = 12'h01d; 	read = 0; write = 0;
        #20 data_in = 12'h01e; 
        #20 data_in = 12'h01f; 
        #20 data_in = 12'h020; 
        #100 read = 1; 		
		#100 $stop;	
    end
endmodule