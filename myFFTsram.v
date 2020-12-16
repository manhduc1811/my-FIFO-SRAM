/************************************************
************************************************/
module myFFTsram (
    input        clk,                             // clock
    input        rst_n,                            // reset
    input        read,                            // fifo read, active high
    input        write,                           // fifo write, active high
    input  [7:0] data_in,                         // fifo data input
    output [7:0] data_out,                        // fifo data output
    output       ready,                           // fifo has data
    output reg   overflow                        // fifo overflow flag
);   // fifo
// Internal signals
    reg    [7:0] fifo_buff [7:0];                 // fifo buffer of depth 8
    reg    [2:0] write_pointer;                   // fifo write pointer
    reg    [2:0] read_pointer;                    // fifo read pointer
// State register
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            write_pointer                       <= 0;                              // clear write pointer
            read_pointer                        <= 0;                              // clear read pointer
            overflow                            <= 0;                              // clear overflow flag
        end else begin
            if (write) begin
                if ((write_pointer + 3'b1) != read_pointer) begin 
                    fifo_buff[write_pointer] 	<= data_in;                        // push data
                    write_pointer               <= write_pointer + 3'd1;           // pointer++
                end 
				else begin
                    overflow                    <= 1;                              // overflow
                end
            end
            if (read && ready) begin
                read_pointer                    <= read_pointer + 3'd1;            // pointer++, pop
                overflow                        <= 0;                              // clear overflow
            end 
        end
    end
// Output logic
    assign ready                                = (write_pointer != read_pointer);// has data
    assign data_out                             = fifo_buff[read_pointer];        // data output
endmodule
