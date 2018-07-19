module IntOpDecode
  (
  InsBitDispatchIfl.De2 iIns,
  De2Ifs.De2 oDe2,
  ExIfs.De2 De2ExData
);
  //input op, input funct3, input funct7
  //output AddEn,output MultEn,output DivEn,output BitEn,output ShiftEn,output MemEn,output BjEn
  //output AddOpEn,output BitOpEn,output ShiftOpEn,output MultOpEn,output DivOpEn,output MemOpEn,output BjOpEn
 
  //generate Int  En
  wire temp  = iIns.funct3 == 3'b000;
  wire AddEn = iIns.op[2] | temp & (!iIns.op[5] | (iIns.op[5] & !iIns.funct7[5]));
  assign oDe2.AddEn   = AddEn;

  wire ShiftEn = iIns.funct3[1:0] == 2'b01 & !iIns.op[2];
  assign oDe2.ShiftEn = ShiftEn;

  assign oDe2.BitEn   = !AddEn & !ShiftEn ;

  //generate Int OpEn
  //generate AddOpEn
  assign De2ExData.AddOpEn = iIns.op[2] & !iIns.op[5];

  //generate BitOpEn
  wire AndEn = iIns.funct3 == 3'b111;
  wire OrEn  = iIns.funct3 == 3'b110;
  wire XorEn = iIns.funct3 == 3'b100;
  wire SubEn = iIns.funct3 == 3'b000 & oDe2.BitEn;
  wire SltEn = !iIns.funct3[2] & iIns.funct3[1];
  assign De2ExData.BitOpEn = {SltEn,SubEn,XorEn,OrEn,AndEn};

  //generate ShiftOpEn
  wire SllEn = ShiftEn & !iIns.funct3[2];
  wire SrEn  = ShiftEn &  iIns.funct3[2];

  wire SrlEn = SrEn & !iIns.funct7[5];
  wire SraEn = SrEn &  iIns.funct7[5];
  assign De2ExData.ShiftOpEn = {SraEn,SrlEn,SllEn};


endmodule