`timescale 1ns/100ps

`include "rca_array_mul.v"

module test_rca_array_mul();

parameter WIDTH=4;

reg [WIDTH-1:0] A;
reg [WIDTH-1:0] B;
wire [2*WIDTH-1:0] S;

rca_array_mul #(
    .WIDTH(WIDTH)
    ) u_rca_array_mul (
    .A(A),
    .B(B),
    .S(S)
    );

initial begin
    A=4'd13;
    B=4'd14;
end

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_rca_array_mul);     //tb模块名称
end

initial
    #20 $finish;

endmodule