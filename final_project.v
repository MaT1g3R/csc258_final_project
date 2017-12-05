// vim: ts=4:sw=4:et
`include "vga_adapter.v"
`include "vga_address_translator.v"
`include "vga_controller.v"
`include "vga_pll.v"

module final_project
    (
        CLOCK_50,						//	On Board 50 MHz
        // Your inputs and outputs here
        KEY,
        SW,
		  HEX0,
		  scoreR,
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
    output  [9:0] scoreR;
	 output  [6:0] HEX0;
	  

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
//	 assign resetn = 0;
    assign resetn = SW[0];

    wire clk;
    assign clk = CLOCK_50;

    // Create the colour, x, y and writeEn wires that are inputs to the controller.
    reg [2:0] colour;
    reg [7:0] x;
    reg [6:0] y;
    reg writeEn;
    reg [3:0] lives;
	 reg [3:0] total_score;
	 wire score0, score1, score2, score3;

	 
    wire [6:0] random_y;
    wire [3:0] go;
    wire [7:0] x0, x1, x2, x3;
    wire [6:0] y0, y1, y2, y3;
    wire [2:0] c0, c1, c2, c3;
    wire [3:0] wrenAll;
    wire [3:0] need_rng_all;
	 
    
     wire need_rng_final;
     assign need_rng_final = (need_rng_all > 0);
     rng random(
         .clock(clk),
         .reset_n(resetn),
         .need_rng(need_rng_final),
         .out(random_y)
    );
	 
	 hex_decoder hex_d0(
	     .hex_digit(total_score), 
		  .segments(HEX0)
	 );

    delay d0(
        .clk(clk),
        .resetn(resetn),
        .go(go)
    );

     main m0(
        .clk(clk),
        .resetn(resetn),
        .go(go[0]),
        .colour_in(SW[9:7]),
        .x_in(8'd19),
        .random_y(random_y),
        .writeEnable(wrenAll[0]),
        .x_out(x0),
        .y_out(y0),
        .colour_out(c0),
        .need_rng(need_rng_all[0]),
		  .key(KEY[3]),
		  .kill(kill0),
		  .score(score0)
     );
//
//     main m1(
//        .clk(clk),
//        .resetn(resetn),
//        .go(go[1]),
//        .colour_in(SW[9:7]),
//        .x_in(8'd50),
//        .random_y(random_y),
//        .writeEnable(wrenAll[1]),
//        .x_out(x1),
//        .y_out(y1),
//        .colour_out(c1),
//        .need_rng(need_rng_all[1]),
//		  .key(!KEY[2]),
//	     .kill(kill1)
//     );
//
//     main m2(
//        .clk(clk),
//        .resetn(resetn),
//        .go(go[2]),
//        .colour_in(SW[9:7]),
//        .x_in(8'd80),
//        .random_y(random_y),
//        .writeEnable(wrenAll[2]),
//        .x_out(x2),
//        .y_out(y2),
//        .colour_out(c2),
//        .need_rng(need_rng_all[2]),
//		  .key(!KEY[1]),
//		  .kill(kill2)
//		);
//
//     main m3(
//        .clk(clk),
//        .resetn(resetn),
//        .go(go[3]),
//        .colour_in(SW[9:7]),
//        .x_in(8'd110),
//        .random_y(random_y),
//        .writeEnable(wrenAll[3]),
//        .x_out(x3),
//        .y_out(y3),
//        .colour_out(c3),
//        .need_rng(need_rng_all[3]),
//		  .key(!KEY[0]),
//		  .kill(kill3)
//		);
	  
     
	  reg [31:0] add_counter0;
	  always @(posedge clk) begin
	      if(!resetn) begin
			    total_score <= 0;
				 add_counter0 <= 0;
			end else begin
				if (score0 == 1) begin
					 if (add_counter0 == 0) begin
						add_counter0 <= 1;
						total_score <= total_score + 1;
					 end
				end else begin
				    if (add_counter0 < 3000) begin
					     add_counter0 <= add_counter0 + 1;
					 end else begin
					     add_counter0 <= 0;
					 end
				end
			end
		end
			
			
     always @(*) begin
        if (wrenAll[0]) begin
            x = x0;
            y = y0;
            writeEn = wrenAll[0];
            colour = c0;
        end else if (wrenAll[1]) begin
            x = x1;
            y = y1;
            colour = c1;
            writeEn = wrenAll[1];
        end else if (wrenAll[2]) begin
            x = x2;
            y = y2;
            colour = c2;
            writeEn = wrenAll[2];
        end else if (wrenAll[3]) begin
            x = x3;
            y = y3;
            colour = c3;
            writeEn = wrenAll[3];
        end else begin
            x = 8'd0;
            y = 7'd0;
            writeEn = 1'b0;
            colour = 3'd0;
        end
    end
    // Create an Instance of a VGA controller - there can be only one!
    // Define the number of colours as well as the initial background
    // image file (.MIF) for the controller.
//	 always @(*) begin
//	     x <= x2;
//	     y <= y2;
//	     colour <= c2;
//		  writeEn = wrenAll[2];
//	 end
//	 writeEn = wrenAll[0];
     
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

endmodule


module main(
        input clk, resetn, go, key,
        input [2:0] colour_in,
        input [7:0] x_in,
        input [6:0] random_y,
        output writeEnable,
		  output score,
        output [7:0] x_out,
        output [6:0] y_out,
        output [2:0] colour_out,
		  output kill,
		  output need_rng
        );
        
        wire [7:0] y_reg;
        wire [7:0] y_to_draw;
        wire fake_wren;
        wire [7:0] rng_y_out;
        wire [6:0] y_to_wr;
        
        
        assign y_out = y_to_wr;
        
        move_fsm m0(
            .clk(clk),
            .resetn(resetn),
            .go(go),
            .y_in(y_reg),
            .colour_in(colour_in),
            .y_out(y_to_draw),
            .colour_out(colour_out),
            .wren(fake_wren),
            .need_rng(need_rng)
        );
        
        draw d0(
            .clk(clk),
            .go(fake_wren),
            .resetn(resetn),
            .x_in(x_in),
            .y_in(y_to_draw),
            .x_out(x_out),
            .y_out(y_to_wr),
				.key(key),
				.kill(kill),
				.score(score)
        );
        
        y_counter yc0 (
            .clk(clk),
            .go(go),
            .resetn(resetn),
            .y_in(random_y),
            .y_out(y_reg)
        );
        
        write_enable w0(
            .fake_wren(fake_wren),
            .y_in(y_to_wr),
            .writeEn(writeEnable)
        );
     
endmodule

module draw(
    input clk,
    input go,
    input resetn,
	 input key,
    input [7:0] x_in,
    input [7:0] y_in,
	 output reg score,
	 output reg kill,
    output reg [7:0] x_out,
    output reg [6:0] y_out
    );
    reg [4:0] x_counter;
    reg [7:0] tmp_y; 
    reg is_pressed;

    always @(posedge clk) begin
		 if (!resetn) begin
            y_out <= 7'b0000000;
            x_out <= x_in;
            tmp_y <= 7'd0;
            x_counter <= 5'd0;
				is_pressed <= 0;
				score <= 0;
        end
        else if (go) begin
                tmp_y <= y_in - 8'd135;
					 if (tmp_y > 105 && tmp_y < 135 && !key) begin
//					     is_pressed <= 1;
                    score <= 1;
					 end
					 if (tmp_y > 135) begin
						score <= 0;
					 end
                if (y_in > 8'd135) begin
                    y_out <= tmp_y[6:0];
						  if (!is_pressed) begin
						       kill <= 1;
						  end
					 end else begin
                     y_out <= 0;
                end

            if (x_counter < 30) begin
                x_counter <= x_counter + 1;
            end
            else begin
                x_counter <= 5'd0;
            end
            x_out <= x_in + x_counter;
        end
        else if (!go) begin
		     is_pressed <= 0;
            y_out <= 7'b0000000;
            x_out <= x_in;
            tmp_y <= 7'd0;
            x_counter <= 5'd0;
        end
    end
endmodule

module delay(
    input clk,
    input resetn,
    output reg [3:0] go
    );
    localparam delay_total = 20'd833332;
//  localparam delay_total = 20'd300;

    reg [19:0] delay_counter;
    always @(posedge clk) begin
        if (!resetn) begin
            go <= 4'b0000;
            delay_counter <= delay_total;
        end
        else begin
            if (delay_counter == 0) begin
                delay_counter <= delay_total;
                go <= 4'b0001;
            end
            else begin
                delay_counter <= delay_counter - 1;
                if (delay_counter == delay_total) begin
                    go <= 4'b0001;
                end else if ((delay_counter == delay_total - 90) || (delay_counter == delay_total - 91)) begin
                    go <= 4'b0010;
                end else if ((delay_counter == delay_total - 180) || (delay_counter == delay_total - 181)) begin
                    go <= 4'b0100;
                end else if ((delay_counter == delay_total - 270) || (delay_counter == delay_total - 271)) begin
                    go <= 4'b1000;
                end else begin
                    go <= 4'b0000;
                end
            end 
        end
    end
endmodule


module y_counter(
    input clk,
    input go,
    input resetn,
    input [7:0] y_in,
    output reg [7:0] y_out
    );
    reg counter;
    always @(posedge clk) begin
        if (!resetn) begin
            y_out <= y_in;
            counter <= 0;
        end
        else if (go) begin
            counter <= !counter;
            if (y_out >= 8'd255) begin
                y_out <= y_in;
            end
            else begin
                y_out <= y_out + counter;
            end
        end
    end
endmodule



module write_enable(
    input fake_wren,
    input [7:0] y_in,
    output writeEn
    );
//    always @(*) begin
//        if (y_in <= 8'd210 && y_in >= 8'd90) begin
//            writeEn = fake_wren;
//        end
//        else begin
//            writeEn = 0;
//        end
//    end
    assign writeEn = fake_wren;
endmodule

module move_fsm(
    input clk,
    input resetn,
    input go,
    input [7:0] y_in,
    input [2:0] colour_in,

    output reg  [7:0] y_out,
    output reg  [2:0] colour_out,
    output reg  wren, need_rng
    );
    reg [2:0] current_state, next_state; 
    reg [4:0] counter;
  
    localparam  WaitForGo   = 3'd0,
                DrawNewLine = 3'd1,
                Wait30One   = 3'd2,
                DeleteLine  = 3'd3,
                Wait30Two   = 3'd4,
					 BlackLine   = 3'd5,
					 Wait30Three = 3'd6;

  
    // Next state logic aka our state table
    always@(*)
    begin: state_table
        case (current_state)
            WaitForGo: next_state = go ? DrawNewLine : WaitForGo;
            DrawNewLine: next_state = Wait30One;
            Wait30One: next_state = (counter == 5'd30) ? DeleteLine : Wait30One;
            DeleteLine: next_state = Wait30Two;
            Wait30Two: next_state = (counter == 5'd30) ? BlackLine : Wait30Two;
				BlackLine: next_state = Wait30Three;
				Wait30Three: next_state = (counter == 5'd30) ? WaitForGo : Wait30Three;
            default: next_state = WaitForGo;
        endcase
    end // state_table


    // Output logic aka all of our datapath control signals
    always @(posedge clk)
    begin: enable_signals
        // By default make all our signals 0
        wren <= 1'b0;
        need_rng <= 1'b0;
        y_out = 8'b00000000;
        colour_out <= 3'b000;

        case (current_state)
             WaitForGo: begin
                 wren <= 0;
                 counter <= 0;
             end
             DrawNewLine: begin
                 colour_out <= colour_in;
                 wren <= 0;
                 y_out <= y_in + 29;
             end
             Wait30One: begin
                 colour_out <= colour_in;
                 wren <= 1;
                 y_out <= y_in + 29;
                 counter <= counter + 1;
             end
             DeleteLine: begin
                 colour_out <= 3'b000;
                 wren <= 0;
                 y_out <= y_in - 1;
                 counter <= 0;
             end
             Wait30Two: begin 
                 colour_out <= 3'b000;
                 wren <= 1;
                 y_out <= y_in - 1;
                 counter <= counter + 1;
             end
				 BlackLine: begin
				     colour_out <= 3'b000;
					  wren <= 0;
					  y_out <= 0;
					  counter <= 0;
					  need_rng <= 1;
				 end
				 Wait30Three: begin
				     colour_out <= 3'b000;
					  wren <= 1;
					  y_out <= 0;
					  counter <= counter + 1;
				 end
        endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= WaitForGo;
        else
             current_state <= next_state;
    end // state_FFS
endmodule


module rng(
    input clock,
    input reset_n,
    input need_rng,
    output reg [6:0] out
);

    reg [9:0] current_value;
    reg temp;
    
    always @(posedge clock) begin 
        if (!reset_n) begin
            current_value <= 1;
            temp <= 0;
            out <= 0;
        end else if (need_rng) begin 
            temp <= current_value[3] ^ current_value[0];
            current_value <= current_value >> 1;
            current_value[9] <= temp;
            out <= current_value % 90;
        end
    end
    
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;

    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;
            default: segments = 7'h7f;
        endcase
endmodule
