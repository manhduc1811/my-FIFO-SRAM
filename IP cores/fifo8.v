module fifo8(clk,clrn,data_in,data_out,write,read,full,empty);
	parameter width    = 8; // fifo width
	parameter widthad  = 3; // log2 numwords
	parameter numwords = 8; // fifo depth
	input              clk;
	input              clrn;
	input 			   write;
	input 			   read;
	input  [width-1:0] data_in;
	output [width-1:0] data_out;
	output 			   full;
	output 			   empty;

	reg  [width-1:0] fifo_buffer [numwords-1:0]; // fifo memory
	reg  [widthad:0] write_count;
	reg  [widthad:0]  read_count;
	wire [widthad:0] count = write_count - read_count;
	wire [widthad-1:0] write_pointer = write_count[widthad-1:0];
	wire [widthad-1:0]  read_pointer =  read_count[widthad-1:0];

	assign data_out = fifo_buffer[read_pointer];
	assign full  = count[widthad];
	assign empty = (count == 0);

	always @( posedge clk or negedge clrn ) begin
		if (!clrn) begin
			write_count <= 0;
			read_count  <= 0;
		end else begin
			if(write & ~full) begin
				fifo_buffer[write_pointer] <= data_in;
				write_count <= write_count + 1;
			end
			if(read & ~empty) begin
				read_count <= read_count + 1;
			end
		end
	end
endmodule
