module nrda_div
#(
    parameter WIDTH=32
)
(
    input [WIDTH-1:0] x,
    input [WIDTH-1:0] y,
    output reg [WIDTH-1:0] r,
    output reg [WIDTH-1:0] q
);

reg [2*WIDTH:0] A;//Reserve one carry bit
reg [2*WIDTH-1:0] D;

integer i;
always @(x or y) begin
    //signed->unsigned
    A = x[WIDTH-1] ? {{(WIDTH+1){1'b0}},~x+1'b1} : {{(WIDTH+1){1'b0}},x};
    D = y[WIDTH-1] ? {~y+1'b1,{WIDTH{1'b0}}} : {y,{WIDTH{1'b0}}};
    //calculate unsigned div
    for(i = 0; i < WIDTH; i = i + 1) begin
        if(A[2*WIDTH]==1'b1) begin
            A = A << 1;
            A = A + D;
        end
        else begin
            A = A << 1;
            A = A - D;
        end
        if(A[2*WIDTH]==1'b1) begin
            A[0] = 1'b0;
        end
        else begin
            A[0] = 1'b1;
        end
    end
    r = A[2*WIDTH-1:WIDTH];
    q = A[WIDTH-1:0];
    //Calculation calibration, the remainder R is converted to a positive number
    if(r[WIDTH-1]==1'b1) begin
        r = y[WIDTH-1] ? (r+(~y+1'b1)) : (r+y);
    end
    r = x[WIDTH-1] ? (~r+1'b1) : r;
    q = x[WIDTH-1]^y[WIDTH-1] ? (~q+1'b1) : q;
end

endmodule