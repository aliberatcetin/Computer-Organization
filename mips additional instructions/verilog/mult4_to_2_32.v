module mult4_to_2_32(out, i0,i1,i2,i3,s);
output [31:0] out;
reg [31:0] out;
input [31:0]i0,i1,i2,i3;
input[1:0] s;

always @(i0 or i1 or i2 or i3 or s)
begin
case(s)
    2'b00:out=i0;
    2'b01:out=i1;
    2'b10:out=i2;
    2'b11:out=i3;
endcase
end
endmodule
