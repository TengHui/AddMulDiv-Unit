module AdderTreePipelined
#(
    parameter DATA_WIDTH=32,
    parameter LENGTH=8,
    parameter OUT_WIDTH=DATA_WIDTH+$clog2(LENGTH),
    parameter DELAT_STAGES=$clog2(LENGTH)
)
(
    input rst,
    input clk,
    input in_advance,
    input signed [LENGTH*DATA_WIDTH-1:0] in_addends,
    output signed [OUT_WIDTH-1:0] out_sum
);

localparam LENGTH_A = LENGTH >> 1;
localparam LENGTH_B = LENGTH - LENGTH_A;
localparam OUT_WIDTH_A = DATA_WIDTH + $clog2(LENGTH_A);
localparam OUT_WIDTH_B = DATA_WIDTH + $clog2(LENGTH_B);

generate
    if(LENGTH==1) begin
        if(DELAT_STAGES>0) begin
            reg signed [DELAT_STAGES*DATA_WIDTH-1:0] delay_fifo;
            assign out_sum = delay_fifo[DATA_WIDTH-1:0];
            always @(posedge clk or posedge rst) begin
                if(rst) begin
                    delay_fifo <= {{(DELAT_STAGES*DATA_WIDTH){1'b0}}};
                end
                else if(in_advance==1'b1) begin
                    delay_fifo[DELAT_STAGES*DATA_WIDTH-1 -: DATA_WIDTH] <= in_addends;
                    delay_fifo[(DELAT_STAGES-1)*DATA_WIDTH-1:0] <= delay_fifo[DELAT_STAGES*DATA_WIDTH-1:DATA_WIDTH];
                end
            end
        end
        else begin
            assign out_sum = in_addends;
        end
    end
    else begin
        reg signed [OUT_WIDTH-1:0] out_sum_temp;
        wire signed [OUT_WIDTH_A-1:0] sum_a;
        wire signed [OUT_WIDTH_B-1:0] sum_b;

        wire signed [LENGTH_A*DATA_WIDTH-1:0] addends_a;
        wire signed [LENGTH_B*DATA_WIDTH-1:0] addends_b;

        assign addends_a = in_addends[LENGTH_A*DATA_WIDTH-1:0];
        assign addends_b = in_addends[LENGTH*DATA_WIDTH-1:LENGTH_A*DATA_WIDTH];

        //divide set into two block
        AdderTreePipelined #(
            .DATA_WIDTH(DATA_WIDTH),
            .LENGTH(LENGTH_A),
            .OUT_WIDTH(OUT_WIDTH_A),
            .DELAT_STAGES(DELAT_STAGES-1)
        ) subtree_a (
            .rst(rst),
            .clk(clk),
            .in_advance(in_advance),
            .in_addends(addends_a),
            .out_sum(sum_a)
        );

        AdderTreePipelined #(
            .DATA_WIDTH(DATA_WIDTH),
            .LENGTH(LENGTH_B),
            .OUT_WIDTH(OUT_WIDTH_B),
            .DELAT_STAGES(DELAT_STAGES-1)
        ) subtree_b (
            .rst(rst),
            .clk(clk),
            .in_advance(in_advance),
            .in_addends(addends_b),
            .out_sum(sum_b)
        );
        
        always @(posedge clk or posedge rst) begin
            if(rst) begin
                out_sum_temp <= {{OUT_WIDTH{1'b0}}};
            end
            else if(in_advance) begin
                out_sum_temp <= sum_a + sum_b;
            end
        end
        assign out_sum = out_sum_temp;
    end
endgenerate

endmodule