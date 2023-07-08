module rda_div
#(
    parameter WIDTH=32
)
(
    input [WIDTH-1:0] x,
    input [WIDTH-1:0] y,
    output reg [WIDTH-1:0] r,
    output reg [WIDTH-1:0] q
);

reg [2*WIDTH-1:0] A;
reg [2*WIDTH-1:0] D;

integer i;
always @(x or y) begin
    A = {{WIDTH{1'b0}},x};
    D = {y,{WIDTH{1'b0}}};
    for(i = 0; i < WIDTH; i = i + 1) begin
        A = A << 1;
        A = A - D;
        if(A[2*WIDTH-1]==1'b1) begin
            A[0] = 1'b0;
            A = A + D;//restore
        end
        else begin
            A[0] = 1'b1;
        end
    end
    r = A[2*WIDTH-1:WIDTH];
    q = A[WIDTH-1:0];
end

endmodule