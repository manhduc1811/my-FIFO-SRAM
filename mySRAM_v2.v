/************************************************************************************************
New version, full version of FIFO
************************************************************************************************/
module mySRAM 
#(	parameter               BITS             = 12, 
	                        WORD_DEPTH       = 8, 
                            ADDR_WIDTH       = 3)
(   input        		    clk,                                                // clock
    input        		    rst_n,                                              // reset
    input        		    read,                                               // fifo read, active high
    input        		    write,                                              // fifo write, active high
    input  [BITS-1:0]       data_in,                                            // fifo data input
    output [BITS-1:0]       data_out,                                           // fifo data output
    output       		    ready,                                              // fifo has data, no empty
    output      		    overflow                                            // fifo full flag
);   // fifo
// Internal signals
    reg    [BITS-1:0] 		fifo_buff        [WORD_DEPTH-1:0];                  // fifo buffer of depth WORD_DEPTH
    reg    [ADDR_WIDTH:0]   write_count;
	reg    [ADDR_WIDTH:0]   read_count;
	wire   [ADDR_WIDTH:0]   count            = write_count - read_count;
	wire   [ADDR_WIDTH-1:0] write_pointer    = write_count[ADDR_WIDTH-1:0];     // fifo write pointer
    wire   [ADDR_WIDTH-1:0] read_pointer     = read_count[ADDR_WIDTH-1:0];      // fifo read pointer
// State register
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_count                      <= 0;                              // clear write pointer
            read_count                       <= 0;                              // clear read pointer
        end else begin
            if (write & ~overflow) begin
				fifo_buff[write_pointer]     <= data_in;
				write_count                  <= write_count + 1;
            end 
			if (read & ready) begin
				read_count                   <= read_count + 1;
			end
        end
    end
// Output logic
    assign data_out                          = fifo_buff[read_pointer];         // data output
    assign overflow                          = count[ADDR_WIDTH];                                                
	assign ready                             = (count != 0);                    // has data
endmodule