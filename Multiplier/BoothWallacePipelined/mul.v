module mul
(
    input rst,
    input clk,
    input sign,
    input [31:0] x,
    input [31:0] y,
    output [63:0] result
);

//x expands to 64 bits and y expands to 34 bits to differ signed or unsigned
wire [63:0] ex_x;
wire [33:0] ex_y;

assign ex_x = sign ? {{32{x[31]}},x} : {32'b0,x};
assign ex_y = sign ? {{2{y[31]}},y} : {2'b0,y};

//===========1.booth===========
//The carry calculated by booth
wire [16:0] carry;
//Partial product result
wire [63:0] part_res [16:0];

BoothInterBase ufirst_BoothInterBase(
        .y({ex_y[1:0],1'b0}), 
        .x(ex_x), 
        .p(part_res[0]), 
        .c(carry[0])
    );

generate
    genvar i;
    for(i=2;i<=32;i=i+2) begin
        BoothInterBase ui_BoothInterBase(
            .y(ex_y[i+1:i-1]),
            .x(ex_x<<i),
            .p(part_res[i>>1]),
            .c(carry[i>>1])
        );
    end
endgenerate
//===========1.booth===========

//===========2.pipeline===========
reg [16:0] carry_stage;
reg [16:0] part_res_stage [63:0];

integer m,n;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        carry_stage <= 17'b0;
        for(m=0;m<64;m=m+1) begin
            part_res_stage [m] <= 17'b0;
        end
    end
    else begin
        carry_stage <= carry;
        for(m=0;m<64;m=m+1) begin
            for(n=0;n<17;n=n+1) begin
                part_res_stage[m][n] <= part_res[n][m];
            end
        end
    end
end
//===========2.pipeline===========

//===========3.wallace===========
wire [13:0] wallace_carry [64:0];
wire [63:0] c_res,s_res;

wallace17 ufirst_wallace17(
        .in_data(part_res_stage[0]), 
        .cin(carry_stage[13:0]), 
        .cout(wallace_carry[1]),
        .c(c_res[0]),
        .s(s_res[0])
    );

generate
    genvar k;
    for(k=1;k<64;k=k+1) begin
        wallace17 ufirst_wallace17(
            .in_data(part_res_stage[k]), 
            .cin(wallace_carry[k]), 
            .cout(wallace_carry[k+1]),
            .c(c_res[k]),
            .s(s_res[k])
        );
    end
endgenerate
//===========3.wallace===========

assign result = s_res + {c_res[62:0],carry_stage[14]} + carry_stage[15];

endmodule