module branchAndJumpControl(jump,branch1,branch0,negative,zero,jpc,addrdecision,whichtoreg);
input jump,branch1,branch0,negative,zero,jpc; //branch and jum inputs comes from control unit and zero,negative input comes from aLU
output [1:0] addrdecision; //generate addrDecision output for select signal for addressSelectMux
reg [1:0] addrdecision;
output whichtoreg;
reg whichtoreg;

always @(jump or branch1 or branch0 or negative or zero or jpc)
begin
case(jpc) 
    1'b1:addrdecision = 2'b10; //when jpc equal to 1 addrdecision becomes to 2
    1'b0://when jpc equal to zero we check the branch,jump,negative and zero inputs
    //when jump equal to 1 addrDecision become to 01
    //when branch equal to 10(bgez) and jump equal to 0 and negative equal to 0  addrDecision become to 10
    //when branch equal to 01(beq) and jump equal to 0 and zero equal to 1 addrDecision become to 10
    //when branch equal to 11(balrn) and jump equal to 0 and negative equal to 1 addrDecision become to 11
    begin 
        addrdecision[0] = jump | (branch1 & branch0 & negative); 
        addrdecision[1] = ~jump & ((~branch1 & branch0 & zero) | (branch1 & ~branch0 & ~negative) | (branch1 & branch0 & negative) );
    end
endcase
whichtoreg = ~( (addrdecision[1] & addrdecision[0]) | jpc | jump  );
end
endmodule