module rng(
    input clock,
    input reset_n,
    input [9:0] seed,
    input load_n
    output out
);

wire shift_right;
assign shift_right = 1'b1;
#Always want to shift when clk is pulsed.

wire newBit;
assign newBit = shift_out[0] ^ shift_out[3];
#Taps on the 10th and 7th regesters will lead to the longest output cycle.

    shift_bit shift9(
        .load_val(seed[9]),
        .in(newBit),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[9])
    );

    shift_bit shift8(
        .load_val(seed[6]),
        .in(shift_out[9]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[8])
    );

    shift_bit shift7(
        .load_val(seed[7]),
        .in(shift_out[8]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[7])
    );

    shift_bit shift6(
        .load_val(seed[6]),
        .in(shift_out[7]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[6])
    );

    shift_bit shift5(
        .load_val(seed[5]),
        .in(shift_out[6]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[5])
    );

    shift_bit shift4(
        .load_val(seed[4]),
        .in(shift_out[5]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[4])
    );

    shift_bit shift3(
        .load_val(seed[3]),
        .in(shift_out[4]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[3])
    );

    shift_bit shift2(
        .load_val(seed[2]),
        .in(shift_out[3]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[2])
    );

    shift_bit shift1(
        .load_val(seed[1]),
        .in(shift_out[2]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[1])
    );

    shift_bit shift0(
        .load_val(seed[0]),
        .in(shift_out[1]),
        .shift_right(shift_right),
        .load_n(load_n),
        .clock(clock),
        .reset_n(reset_n),
        .out(shift_out[0])
    );

endmodule


module mux2to1(x, y, s, m);
    input x, y, s;
    output m;
    reg m;

    always @(*)
    begin
        if (s == 1'b0)
            m = x;
        else
            m = y;
    end

endmodule


module flipflop(clock, reset_n, q, d);
    input reset_n, clock;
    input d;
    output q;
    reg q;
    
    always @(posedge clock)
    begin
        if (reset_n == 1'b0)
            q <= 0;
        else
            q <= d;
    end

endmodule


module shift_bit(load_val, in, shift_right, load_n, clock, reset_n, out);
    input load_val, in, shift_right, load_n, clock, reset_n;
    output out;
    
    wire mux0_out;
    wire mux1_out;

    mux2to1 m0(
        .x(out),
        .y(in),
        .s(shift_right),
        .m(mux0_out)
    );

    mux2to1 m1(
        .x(load_val),
        .y(mux0_out),
        .s(load_n),
        .m(mux1_out)
    );

    flipflop flip(
        .clock(clock),
        .reset_n(reset_n),
        .q(out),
        .d(mux1_out)
    );
endmodule
