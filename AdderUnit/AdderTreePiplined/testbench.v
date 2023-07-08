`timescale 1ns/100ps

`include "AdderTreePipelined.v"

module test_AdderTreePipelined();

parameter DATA_WIDTH=32;
parameter LENGTH=8;
parameter OUT_WIDTH=DATA_WIDTH+$clog2(LENGTH);
parameter DELAT_STAGES=$clog2(LENGTH);

reg rst;
reg clk;
reg in_advance;
reg [LENGTH*DATA_WIDTH-1:0] in_addends;
wire [OUT_WIDTH-1:0] out_sum;

AdderTreePipelined #(
    .DATA_WIDTH(DATA_WIDTH),
    .LENGTH(LENGTH),
    .OUT_WIDTH(OUT_WIDTH),
    .DELAT_STAGES(DELAT_STAGES)
) u_AdderTreePipelined (
    .rst(rst),
    .clk(clk),
    .in_advance(in_advance),
    .in_addends(in_addends),
    .out_sum(out_sum)
);

initial begin
    in_addends = {32'd123, -32'd387, -32'd1468, 32'd1189, 32'd4396, -32'd231, 32'd666, 32'd999};//res=35'd5287=35'h14A7
    in_advance = 1;
    rst=0;
    clk=0;
    #2
    rst=1;
    #2
    rst=0;
    #20
    in_advance = 0;
    #20
    in_advance = 1;
end

always #5 clk=~clk;

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_AdderTreePipelined);     //tb模块名称
end

initial
    #100 $finish;

endmodule