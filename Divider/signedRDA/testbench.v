`timescale 1ns/100ps

`include "rda_div.v"

module test_rda_div();

parameter WIDTH=32;

reg [WIDTH-1:0] x;
reg [WIDTH-1:0] y;
wire [WIDTH-1:0] r;
wire [WIDTH-1:0] q;

rda_div #(
    .WIDTH(WIDTH)
    ) u_rda_div (
    .x(x),
    .y(y),
    .r(r),
    .q(q)
    );

initial begin
    x=32'd1436;
    y=32'd135;
    #5
    x=-32'd1436;
    y=32'd135;
    #5
    x=32'd1436;
    y=-32'd135;
    #5
    x=-32'd1436;
    y=-32'd135;
end

initial begin            
    $dumpfile("wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, test_rda_div);     //tb模块名称
end

initial
    #20 $finish;

endmodule