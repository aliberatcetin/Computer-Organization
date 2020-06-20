module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:127]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0]
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,   //Output of mux with PcToReg control-mult5
sum,		//ALU result
extad,	//Output of sign-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad;	//Output of shift left 2 unit


wire [5:0] inst31_26,	//31-26 bits of instruction
inst5_0; //function code
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1,		//Write data input of Register File
rdOrDefault31Output, //rd or default 31 for register Write
inst10_6; //shamt



wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)


wire [2:0] gout,	//Output of ALU control unit
aluOp; //Aluop Control singal

wire [1:0] branch, //branch control signal
pcAddrDecision; 

wire zout,	//Zero output of ALU
nout, //Negative output of ALU
stateRegNout,
stateRegZout,
//Control signals
rdOrDefault31Decision,
regdest,alusrc,memtoreg,regwrite,memread,memwrite,jump,statusRegWrite,jpc,pcToReg;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

//State registers for negative and zero
reg negative,
zero;


integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[6:0]],mem[pc[6:0]+1],mem[pc[6:0]+2],mem[pc[6:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];
 assign inst5_0 = instruc[5:0];
 assign inst10_6 = instruc[10:6];


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2

always @(posedge clk)
 registerfile[rdOrDefault31Output]= regwrite ? out5:registerfile[rdOrDefault31Output];//Write data to register


assign stateRegNout=negative;
assign stateRegZout=zero;

//update state register values for each clock
always @(posedge clk)
begin
     negative= statusRegWrite ? nout:negative;
     zero = statusRegWrite ? zout:zero;
end



//read data from memory, sum stores address
assign dpack={datmem[sum[4:0]],datmem[sum[4:0]+1],datmem[sum[4:0]+2],datmem[sum[4:0]+3]};

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, inst20_16,inst15_11,regdest);
//mux with rdOrDefault31Decision control
mult2_to_1_5  mult2(rdOrDefault31Output, out1,5'b11111,rdOrDefault31Decision);

//mux with ALUSrc control
mult2_to_1_32 mult3(out2, datab,extad,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult4(out3, sum,dpack,memtoreg);
//mux with PcToReg control
mult2_to_1_32 mult5(out5, adder1out,out3,pcToReg);

//mux with pcAddrDecision control
mult4_to_2_32 mult6(out4, adder1out,dpack,adder2out,dataa,pcAddrDecision);



// load pc
always @(posedge clk)
begin
pc=out4;
end
// alu, adder and control logic connections

//ALU unit
alu32 alu1(dataa,out2,gout,inst10_6,sum,nout,zout);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(inst31_26,inst5_0,jpc,regdest,alusrc,memtoreg,regwrite,memwrite,memread,statusRegWrite,
aluOp,branch,jump,rdOrDefault31Decision);


//Sign extend unit
signext sext(inst15_0,extad);

//ALU control unit
alucont acont(aluOp,inst5_0,gout);

//branch and jump control unit
branchAndJumpControl bjcontrol(jump,branch[1],branch[0],stateRegNout,stateRegZout,jpc,pcAddrDecision,pcToReg);

//Shift-left 2 unit
shift shift2(sextad,extad);


//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;

end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

