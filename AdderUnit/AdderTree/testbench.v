`timescale 1ns/100ps

`include "AdderTree.v"

module test_AdderTree();

parameter DATA_WIDTH=32;
parameter LENGTH=8;
parameter OUT_WIDTH=DATA_WIDTH+$clog2(LENGTH);

reg [LENGTH*DATA_WIDTH-1:0] in_addends;
wire [OUT_WIDTH-1:0] out_sum;

AdderTree #(
    .DATA_WIDTH(DATA_WIDTH),
    .LENGTH(LENGTH),
    .OUT_WIDTH(OUT_WIDTH)
) u_AdderTree (
    .in_addends(in_addends),
    .out_sum(out_sum)
);

initial begin
    in_addends = {32'd123, -32'd387, -32'd1468, 32'd1189, 32'd4396, -32'd231, 32'd666, 32'd999};//res=35'd5287=35'h14A7
end

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_AdderTree);     //tb模块名称
end

initial
    #20 $finish;

endmodule