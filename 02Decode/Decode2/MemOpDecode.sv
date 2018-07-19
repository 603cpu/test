//////////////////////////////////////////////////////////////////////////
//MemOp is used to decode load or store instuction
//////////////////////////////////////////////////////////////////////////
module MemOpDecode
(
  InsBitDispatchIfl.De2 iIns,
  De2Ifs.De2 oDe2,
  ExIfs.De2 De2ExData
);

  //generate Mem En
  //assign oDe2.MemEn = 1'b1;
  //generate Mem OpEn
  wire fun3_y2 =  iIns.funct3[2];
  wire fun3_n2 = !iIns.funct3[2];
  wire fun3_y1 =  iIns.funct3[1];
  wire fun3_n1 = !iIns.funct3[1];
  wire fun3_y0 =  iIns.funct3[0];
  wire fun3_n0 = !iIns.funct3[0];
  
  wire StoreEn    = iIns.op[5];
  wire WordEn     = fun3_y1; 
  wire HalfWordEn = fun3_n1 & fun3_y0;
  wire ByteEn     = fun3_n1 & fun3_n0;
  wire SignedEn   = fun3_n2;
  assign De2ExData.MemOpEn = {StoreEn,WordEn,HalfWordEn,ByteEn,SignedEn};
  assign oDe2.StoreEn = StoreEn;
endmodule
