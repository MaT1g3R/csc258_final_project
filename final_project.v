// vim: ts=4:sw=4:et
// Part 2 skeleton

module final_project
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	wire resetn;
	assign resetn = SW[0];
    wire clk;
    assign clk = CLOCK_50;

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

endmodule


module draw(
    input clk,
    input go,
    input resetn,
    input [7:0] x_in,
    input [7:0] y_in,
    output reg [7:0] x_out,
    output reg [6:0] y_out,
    );
    reg [4:0] x_counter;
    reg [7:0] tmp_y;
    always @(posedge clk) begin
        if (!resetn) begin
            y_out <= 7'b0000000;
            tmp_y <= 8'b00000000;
            x_out <= x_in;
            x_counter <= 5'd0;
        end
        else if (go) begin
            tmp_y <= y_in - 8'd120;
            y_out <= tmp_y[6:0];
            if (x_counter < 30) begin
                x_counter <= x_counter + 1;
            end
            else begin
                x_counter <= 5'd0;
            end
            x_out <= x_in + x_counter;
        end
        else if (!go) begin
            y_out <= 7'b0000000;
            tmp_y <= 8'b00000000;
            x_out <= x_in;
            x_counter <= 5'd0;
        end
    end
endmodule


module move_fsm();
endmodule

module delay();
endmodule

module y_counter();
endmodule

module rng();
endmodule

module write_enable();
endmodule
