module MultDivOpDecode
(
  InsBitDispatchIfl.De2 iIns,
  De2Ifs.De2 oDe2,
  ExIfs.De2 De2ExData
);

  //input op, input funct3, input funct7
  //output AddEn,output MultEn,output DivEn,output BitEn,output ShiftEn,output MemEn,output BjEn
  //output AddOpEn,output BitOpEn,output ShiftOpEn,output MultOpEn,output DivOpEn,output MemOpEn,output BjOpEn
 
  //generate MultDiv En

  assign oDe2.MultEn = !iIns.funct3[2];
  assign oDe2.DivEn =   iIns.funct3[2];

  //generate MultDiv OpEn
  wire Rem = iIns.funct3[2:1] == 2'b11;
  wire Div = iIns.funct3[2:1] == 2'b10;
  assign De2ExData.DivOpEn = {Div,Rem};

  wire Mul  = iIns.funct3[2:0] == 3'b000;
  wire MulH = !iIns.funct3[2] & !Mul;
  assign De2ExData.MultOpEn = {Mul,MulH}; 
  
  endmodule 
