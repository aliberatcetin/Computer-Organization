module alucont(aluOp,func,gout);//Figure 4.12 
input[2:0] aluOp; //aluOp become 3 bit
input[5:0] func;  //function inpur for R-type instrunctions 
output [2:0] gout; //output for ALU
reg [2:0] gout;
wire aluops;
assign aluops = ~aluOp[2] & ~aluOp[0] & aluOp[1]; //aluops signal for mux select signal
always @(aluOp or func)
begin
	case(aluops) //when aluop equal to 010 aluops become to 1.
		1'b0:  //if oluops Equal to 0 we consider instruction is I-type.So we check only AluOp.
			//when AluOp equal to 100(ori) gout become 001
			//when AluOp equal to 011(bgez) gout become 011
			//when AluOp equal to 001(beq) gout become 110
			//when AluOp equal to 000(lw/sw) gout become 010
			begin
				gout[0] = aluOp[2] | aluOp[1]; 
				gout[1] = ~aluOp[2];
				gout[2] = aluOp[0] & ~aluOp[1];
			end
		1'b1: //if oluops Equal to 1 we consider instruction is R-type.So we check the function codes.
			//when function code equal to 100000(add) gout become 010
			//when function code equal to xx1xxx(slt) gout become 111
			//when function code equal to 100010(sub) gout become 110
			//when function code equal to 100101(or) gout become 001
			//when function code equal to 100100(and) gout become 000
			//when function code equal to 000010(shift) gout become 101
			//when function code equal to 100001(jmadd) gout become 010

			begin
				gout[2] = func[3] | (~func[4] & func[1] );
				gout[1] = func[3] | func[4] | (func[5] & ~func[2] );
				gout[0] = func[3] | ~func[5] | ( func[0] & func[2] );
			end
	endcase
end
endmodule