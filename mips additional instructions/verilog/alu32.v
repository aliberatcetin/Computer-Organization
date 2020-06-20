module alu32(a,b,gin,shamt,sum,nout,zout);//ALU operation according to the ALU control line values
output [31:0] sum; //32 bit alu result
output zout; //zero output bit
output nout; //negative output bit

input [4:0] shamt; //input for shift amount
input [31:0] a,b;  
input [2:0] gin;//ALU control line
reg [31:0] sum;
reg [31:0] less;
reg nout;
reg zout;
always @(a or b or gin or shamt)
begin
	case(gin)
		3'b000: sum = a & b; //ALU control line=000 AND
		3'b001: sum = a | b; //ALU control line=001 OR
		3'b010: sum = a + b; //ALU control line=010 ADD
		3'b011: sum = a;	 //ALU control line=011 result directly equal to a
		3'b101: sum = b >> shamt; //ALU control line=101 SHIFT
		3'b110: sum = a - b;	//ALU control line=110 SUM
		3'b111: begin			//ALU control line=111 set on less than
					less = a - b;
					sum = less[31];
				end
		default:sum = 31'bx;
	endcase
zout = ~(|sum);
nout = sum[31]; //zero out signal equal to nor of result's bits
end
endmodule
