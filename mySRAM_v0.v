/************************************************************************************************
Old version in __1Eb, with error
************************************************************************************************/
module mySRAM 
#(
    parameter BITS       = 12, 
	          word_depth = 8, 
              addr_width = 3
)
(
    input        		    clk,                                // clock
    input        		    rst_n,                              // reset
    input        		    read,                               // fifo read, active high
    input        		    write,                              // fifo write, active high
    input  [BITS-1:0]       data_in,                            // fifo data input
    output [BITS-1:0]       data_out,                           // fifo data output
    output       		    ready,                              // fifo has data
    output reg   		    overflow                            // fifo overflow flag
);   // fifo
// Internal signals
    reg    [BITS-1:0] 		fifo_buff        [word_depth-1:0];  // fifo buffer of depth word_depth
    reg    [addr_width-1:0] write_pointer;                   	// fifo write pointer
    reg    [addr_width-1:0] read_pointer;                    	// fifo read pointer
// State register
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer                       <= 0;                              // clear write pointer
            read_pointer                        <= 0;                              // clear read pointer
            overflow                            <= 0;                              // clear overflow flag
        end 
		else begin
            if (write) begin
                if ((write_pointer + 1) != read_pointer) begin 
                    fifo_buff[write_pointer] 	<= data_in;                        // push data
                    write_pointer               <= write_pointer + 1;              // pointer++
                end 
				else begin
                    overflow                    <= 1;                              // overflow
                end
            end
            if (read && ready) begin
                read_pointer                    <= read_pointer + 1;               // pointer++, pop
                overflow                        <= 0;                              // clear overflow
            end 
        end
    end
// Output logic
    assign ready                                = (write_pointer != read_pointer);// has data
    assign data_out                             = fifo_buff[read_pointer];        // data output
endmodule