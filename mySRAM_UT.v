/************************************************************************************************
Based on ___4Eb, not yet finished
************************************************************************************************/
module mySRAM 
#(
    parameter BITS       = 12, 
	          WORD_DEPTH = 8, 
              ADDR_WIDTH = 3
)
(
    input        		    clk,                                // clock
    input        		    rst_n,                              // reset
    input        		    read,                               // fifo read, active high
    input        		    write,                              // fifo write, active high
    input      [BITS-1:0]   data_in,                            // fifo data input
    output     [BITS-1:0]   data_out,                           // fifo data output
    output       		    ready,                              // fifo has data
    output      		    overflow                            // fifo overflow flag
);   // fifo
// Internal signals
    reg    [BITS-1:0] 		fifo_buff      [WORD_DEPTH-1:0];  // fifo buffer of depth WORD_DEPTH
    reg    [ADDR_WIDTH-1:0] write_pointer, write_pointer_nxt, write_pointer_succ;                 // fifo write pointer
    reg    [ADDR_WIDTH-1:0] read_pointer, read_pointer_nxt, read_pointer_succ;                 // fifo read pointer
	reg                     full_reg, empty_reg, full_next, empty_next;
	wire                    write_en;
//Register file write operation
	always @ (posedge clk) begin
		if(write_en)
			fifo_buff[write_pointer] <= data_in;
	end
	// register file read operation
	assign	data_out = fifo_buff[read_pointer];
	// write enable when FIFO is not full
	assign write_en  = write&~full_reg;
// State register
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer   <= 0;
            read_pointer    <= 0;
            full_reg        <= 1'b0;
			empty_reg       <= 1'b1;
        end 
		else begin
            write_pointer   <= write_pointer_nxt;
            read_pointer    <= read_pointer_nxt;
            full_reg        <= full_next;
			empty_reg       <= empty_next;			
        end
    end
// Next state logic
	always @* begin
		//successive pointer values
		write_pointer_succ = write_pointer + 1;
		read_pointer_succ  = read_pointer  + 1;
		// Keep old values
		write_pointer_nxt  = write_pointer;
		read_pointer_nxt   = read_pointer;
		full_next          = full_reg;
		empty_next         = empty_reg;
		case({write, read})
			2'b01: begin
				if (~empty_reg) begin
					read_pointer_nxt = read_pointer_succ;
					full_next        = 1'b0;
					if (read_pointer_succ == write_pointer)
						empty_next   = 1'b1;
				end
			end
			2'b10: begin
				if (~full_reg) begin
					write_pointer_nxt = write_pointer_succ;
					empty_next        = 1'b0;
					if (write_pointer_succ == read_pointer)
						full_next     = 1'b1;
				end
			end
			2'b11: begin
				write_pointer_nxt     = write_pointer_succ;
				read_pointer_nxt      = read_pointer_succ;
			end
		endcase
	end
// Output logic
    assign overflow                         = full_reg; 
    assign ready                            = ~empty_reg; // has data
endmodule