`timescale 1ns/100ps

`include "wallace_mul.v"

module test_wallace_mul();

parameter WIDTH=8;

reg [WIDTH-1:0] X;
reg [WIDTH-1:0] Y;
wire [2*WIDTH-1:0] P;

wallace_mul #(
    .WIDTH(WIDTH)
    ) u_wallace_mul (
    .X(X),
    .Y(Y),
    .P(P)
    );

initial begin
    X=8'd234;
    Y=8'd186;
end

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_wallace_mul);     //tb模块名称
end

initial
    #20 $finish;

endmodule