/************************************************

************************************************/
module myFFTsram_tb;
    reg        clk,clrn;
    reg        read;
    reg        write;
    reg  [7:0] data_in;
    wire [7:0] data_out;
    wire       ready;
    wire       overflow;
    myFFTsram UUT (clk,clrn,read,write,data_in,data_out,ready,overflow);
    always #10 clk = !clk;
    initial begin
            clk     = 0;
            clrn    = 0;
            read    = 0;
            write   = 0;
        #20 clrn    = 1;
            data_in = 8'he0;
            write   = 1;
        #20 data_in = 8'he1;
        #20 data_in = 8'he2;
        #20 data_in = 8'he3;
        #20 data_in = 8'he4;
        #20 data_in = 8'he5;
            read    = 1;
        #20 data_in = 8'he6;
        #20 data_in = 8'he7;
        #20 data_in = 8'he8;
            read    = 0;
        #20 data_in = 8'he9;
        #20 data_in = 8'hea;
        #20 data_in = 8'heb;
        #20 data_in = 8'hec;
        #20 data_in = 8'hed;
        #20 data_in = 8'hee;
        #20 data_in = 8'hef;
        #20 data_in = 8'hf0;
            read    = 1;
        #20 data_in = 8'hf1;
        #20 data_in = 8'hf2;
            read    = 0;
        #20 data_in = 8'hf3;
            read    = 1;
        #20 data_in = 8'hf4;
            write    = 0;
		#20 $stop;	
    end
endmodule
