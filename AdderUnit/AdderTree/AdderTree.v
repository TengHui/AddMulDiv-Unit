module AdderTree
#(
    parameter DATA_WIDTH=32,
    parameter LENGTH=8,
    parameter OUT_WIDTH=DATA_WIDTH+$clog2(LENGTH)
)
(
    input signed [LENGTH*DATA_WIDTH-1:0] in_addends,
    output signed [OUT_WIDTH-1:0] out_sum
);

localparam LENGTH_A = LENGTH >> 1;
localparam LENGTH_B = LENGTH - LENGTH_A;
localparam OUT_WIDTH_A = DATA_WIDTH + $clog2(LENGTH_A);
localparam OUT_WIDTH_B = DATA_WIDTH + $clog2(LENGTH_B);

generate
    if(LENGTH==1) begin
        assign out_sum = in_addends;
    end
    else begin
        wire signed [OUT_WIDTH_A-1:0] sum_a;
        wire signed [OUT_WIDTH_B-1:0] sum_b;

        wire signed [LENGTH_A*DATA_WIDTH-1:0] addends_a;
        wire signed [LENGTH_B*DATA_WIDTH-1:0] addends_b;

        assign addends_a = in_addends[LENGTH_A*DATA_WIDTH-1:0];
        assign addends_b = in_addends[LENGTH*DATA_WIDTH-1:LENGTH_A*DATA_WIDTH];

        //divide set into two block
        AdderTree #(
            .DATA_WIDTH(DATA_WIDTH),
            .LENGTH(LENGTH_A),
            .OUT_WIDTH(OUT_WIDTH_A)
        ) subtree_a (
            .in_addends(addends_a),
            .out_sum(sum_a)
        );

        AdderTree #(
            .DATA_WIDTH(DATA_WIDTH),
            .LENGTH(LENGTH_B),
            .OUT_WIDTH(OUT_WIDTH_B)
        ) subtree_b (
            .in_addends(addends_b),
            .out_sum(sum_b)
        );

        assign out_sum = sum_a + sum_b;
        
    end

endgenerate

endmodule