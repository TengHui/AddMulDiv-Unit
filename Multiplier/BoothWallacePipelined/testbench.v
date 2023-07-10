`timescale 1ns/100ps

`include "mul.v"

module test_mul();

reg rst;
reg clk;
reg sign;
reg [31:0] x;
reg [31:0] y;
wire [63:0] result;

mul u_mul(
    .rst(rst),
    .clk(clk),
    .sign(sign),
    .x(x),
    .y(y),
    .result(result)
);

initial begin
    x=32'd1314;
    y=32'd9999;
    sign=1;
    clk=0;
    rst=0;
    #2
    rst=1;
    #2
    rst=0;
end

always #5 clk = ~clk;

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_mul);     //tb模块名称
end

initial
    #100 $finish;

endmodule