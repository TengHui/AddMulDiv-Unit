module wallace17
(
    input [16:0] in_data,
    input [13:0] cin,
    output [13:0] cout,
    output c,s
);

///////////first///////////
wire [4:0] first_s;
adder first1 (.data(in_data[04:02]), .cout(cout[0]), .s(first_s[0]));
adder first2 (.data(in_data[07:05]), .cout(cout[1]), .s(first_s[1]));
adder first3 (.data(in_data[10:08]), .cout(cout[2]), .s(first_s[2]));
adder first4 (.data(in_data[13:11]), .cout(cout[3]), .s(first_s[3]));
adder first5 (.data(in_data[16:14]), .cout(cout[4]), .s(first_s[4]));

///////////second///////////
wire [3:0] second_s;
adder second1 (.data(cin[2:0]                   ), .cout(cout[5]), .s(second_s[0]));
adder second2 (.data({in_data[0],cin[4:3]}      ), .cout(cout[6]), .s(second_s[1]));
adder second3 (.data({first_s[1:0],in_data[1]}  ), .cout(cout[7]), .s(second_s[2]));
adder second4 (.data(first_s[4:2]               ), .cout(cout[8]), .s(second_s[3]));

///////////third///////////
wire [1:0] third_s;
adder third1 (.data({second_s[0],cin[6:5]} ), .cout(cout[09]), .s(third_s[0]));
adder third2 (.data(second_s[3:1]          ), .cout(cout[10]), .s(third_s[1]));

///////////fourth///////////
wire [1:0] fourth_s;
adder fourth1 (.data(cin[9:7]               ), .cout(cout[11]), .s(fourth_s[0]));
adder fourth2 (.data({third_s[1:0],cin[10]} ), .cout(cout[12]), .s(fourth_s[1]));

///////////fifth///////////
wire fifth_s;
adder fifth1 (.data({fourth_s[1:0],cin[11]}), .cout(cout[13]), .s(fifth_s));

///////////sixth///////////
adder sixth1 (.data({fifth_s,cin[13:12]}), .cout(c), .s(s));

endmodule