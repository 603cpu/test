////////////////////////////////////////////////////////////////////////
//Branch and jump instruction decode, 
//notice that the module include AuiPc instruction decode
////////////////////////////////////////////////////////////////////////
module BJOpDecode
(
  InsBitDispatchIfl.De2 iIns,
  //De2Ifs.De2 oDe2,
  ExIfs.De2 De2ExData
);

	//input op, input funct3, input funct7
  //output AddEn,output MultEn,output DivEn,output BitEn,output ShiftEn,output MemEn,output BjEn
  //output AddOpEn,output BitOpEn,output ShiftOpEn,output MultOpEn,output DivOpEn,output MemOpEn,output BjOpEn

  //generate BJ En 
  //assign oDe2.BjEn = 1'b1;
  //generate BJ OpEn
	wire JumpEn   =  iIns.op[2];//jal jalr
	wire BranchEn = !iIns.op[2];
	
	wire fun3_y2 =  iIns.funct3[2];
	wire fun3_n2 = !iIns.funct3[2];
	wire fun3_y0 =  iIns.funct3[0];
	wire fun3_n0 = !iIns.funct3[0];
	
	wire BneEn = fun3_n2 & fun3_y0 & BranchEn;//bne
	wire BeqEn = fun3_n2 & fun3_n0 & BranchEn;//beq
	wire BgeEn = fun3_y2 & fun3_y0 & BranchEn;//bge bgeu
	wire BltEn = fun3_y2 & fun3_n0 & BranchEn;//blt bltu

// wire SltEn = (iBjDe.IntImmEn | iBjDe.IntRegEn) &
// 						 !fun7[0] & (fun3[2:1]==2'b01);//slti sltiu slt sltu 
																																										 
assign De2ExData.BjOpEn = {JumpEn,BneEn,BeqEn,BgeEn,BltEn};

 
endmodule 
