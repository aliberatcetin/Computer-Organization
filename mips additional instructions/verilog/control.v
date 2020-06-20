module control(opcode,funct,jpc,regdest,alusrc,memtoreg,regwrite,memwrite,memread,statusregwrite,aluop,branch,jump,rdOrDefault31Decision);

input[5:0] opcode,funct; //opcode and functions code inputs for control unit
output jpc,regdest,alusrc,memtoreg,regwrite,memwrite,jump,memread,statusregwrite,rdOrDefault31Decision; //control signals
output[1:0] branch; //branch output for branch &jump control unit
output[2:0] aluop; //aluop for alu Control unit
wire rformat,lw,sw,beq,ori,bgqz,jpc2,balrn,jmadd;

assign rformat = (~opcode[5]) & (~opcode[4]) &  (~opcode[3]) & (~opcode[2]) & (~opcode[1]) & (~opcode[0]); //when opcode equal to 000000 rformat wire become to 1
assign lw = opcode[5] & (~opcode[4]) &  (~opcode[3]) & (~opcode[2]) & opcode[1] & opcode[0];               //when opcode equal to 100011 lw wire become to 1
assign sw = opcode[5] & (~opcode[4]) & opcode[3] & (~opcode[2]) & opcode[1] & opcode[0];                   //when opcode equal to 101011 sw wire become to 1
assign beq = (~opcode[5]) & (~opcode[4]) & (~opcode[3]) & opcode[2] & (~opcode[1]) & (~opcode[0]);         //when opcode equal to 000100 beq wire become to 1
assign ori = (~opcode[5]) & (~opcode[4]) & opcode[3] & (opcode[2]) & (~opcode[1]) & opcode[0];             //when opcode equal to 001101 ori wire become to 1
assign bgez = opcode[5] & (~opcode[4]) & (~opcode[3]) & (opcode[2]) & opcode[1] & opcode[0];               //when opcode equal to 011000 bgez wire become to 1
assign jpc2 = (~opcode[5]) & (opcode[4]) & (opcode[3]) &  (opcode[2]) & opcode[1] & (~opcode[0]);          //when opcode equal to 011110 jpc wire become to 1
assign balrn =   ( (~funct[5]) & funct[4] & (~funct[3]) & funct[2] & funct[1] & funct[0] ) & rformat;      //when opcode equal to 000000 and function code equal to 010111 balrn wire become to 1
assign jmadd =   ( funct[5] & (~funct[4]) & (~funct[3]) & (~funct[2]) & (~funct[1]) & funct[0] ) & rformat ;//when opcode equal to 000000 and function code equal to 100001 jmadd wire become to 1



assign jump = jmadd;
assign memread = jmadd | lw;
assign statusregwrite = ~balrn;
//when instruction is bgez branch Become 10
//when instruction is beq branch Become 01
//when instruction is balrn branch Become 11
assign branch[1] = balrn | bgez;
assign branch[0] = balrn | beq;
//when instruction is R-type AluOp Become 010
//when instruction is lw/sw AluOp Become 000
//when instruction is beq AluOp Become 001
//when instruction is ori AluOp Become 100
//when instruction is bgez AluOp Become 011
assign aluop[2] = ori;
assign aluop[1] = bgez | rformat;
assign aluop[0] = bgez | beq;
assign alusrc = ori | lw | sw;
assign regdest = rformat;
assign memtoreg = lw;
assign regwrite = jpc | rformat | lw | ori;
assign memwrite = sw;
assign jpc = jpc2;
assign rdOrDefault31Decision = jpc | jump; 


endmodule