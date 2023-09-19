module umul
#(parameter DATA_WIDTH)
(
    input logic [DATA_WIDTH - 1 : 0] in0, in1,
    output logic [DATA_WIDTH- 1 : 0] out, ov,
    output logic sig_ov
);

// Max value that can be stored in out
logic [DATA_WIDTH - 1 : 0] MAX;
assign MAX = '1;
logic [DATA_WIDTH - 1 : 0] ZERO;
assign ZERO = '0;

// 2d array to store intermediate values
logic [2 * DATA_WIDTH - 1 : 0] sum [DATA_WIDTH];
// summation signal to store sum
logic [2 * DATA_WIDTH - 1 : 0] product;

//
genvar i;
generate
    for(i = 0; i < DATA_WIDTH; i++ ) begin
        assign sum[i] = in1[i] ? {2 * DATA_WIDTH{1'b0}} + (in0 << i) : '0;
    end
endgenerate

always_comb begin
    product = '0;
    for (int j = 0; j < DATA_WIDTH; j++) begin
        product = product + sum[j];
    end
end

always_comb begin
    sig_ov = |product[2*DATA_WIDTH - 1 : DATA_WIDTH];
    out = sig_ov ? MAX : product[DATA_WIDTH - 1 : 0];
    ov = sig_ov ? product - out : '0;
end

endmodule

module umul_tb();

import std_types::*;

localparam SIZE = 8;

bool clk, sig_ov;
u8 in0, in1, out, ov;

u16 prod;
bool err, test_ov;

umul #(.DATA_WIDTH(SIZE)) DUT (
    .in0(in0),
    .in1(in1),
    .out(out),
    .ov(ov),
    .sig_ov(sig_ov)
);

initial begin
    clk = 0;
    in0 = 0;
    in1 = 0;
    forever begin
        clk = ~clk;
        #1;
    end
end

always @(posedge clk) begin
    in0 = $urandom_range(0,$pow(2,SIZE));
    in1 = $urandom_range(0,$pow(2,SIZE/2));
end


always_comb begin
    prod = in0 * in1;
    test_ov = ( prod > {SIZE{1'b1}} );
    err = (test_ov && !sig_ov) || (prod != out);
end

endmodule