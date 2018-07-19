import ZionDataType::*;
module MemRd
( 
  Mem1Mem2Ifs.Mem2 iMem2Data,
  input CpuType DcacheData,
  input logic [1:0] DcacheAddr,
  ExIfs.Rd iRdOp,
  ExResSelectIfs.Mem2 oMem2
 
);


  
  //assign DcacheData = iMem2Data.MemRdData;
  //assign DcacheAddr = iMem2Data.MemAddr;

  wire LoadEn = !iRdOp.MemOpEn[4];
  
  wire LbEn  = LoadEn & iRdOp.MemOpEn[1] & iRdOp.MemOpEn[0];
  wire LhEn  = LoadEn & iRdOp.MemOpEn[2] & iRdOp.MemOpEn[0];
  wire LwEn  = LoadEn & iRdOp.MemOpEn[3] & iRdOp.MemOpEn[0];
  wire LbuEn = LoadEn & iRdOp.MemOpEn[1] & !iRdOp.MemOpEn[0];
  wire LhuEn = LoadEn & iRdOp.MemOpEn[2] & !iRdOp.MemOpEn[0];
  
CpuType oMemRdData;
always_comb begin
    unique case(1'b1)
      LbEn   : oMemRdData = $signed(DcacheData[(DcacheAddr[1:0]*8 ) +:8]);
      LhEn   : oMemRdData = $signed(DcacheData[(DcacheAddr[1]  *16) +:16]);
      LwEn   : oMemRdData = $signed(DcacheData);
      LbuEn  : oMemRdData = $unsigned(DcacheData[(DcacheAddr[1:0]*8 ) +:8]);
      LhuEn  : oMemRdData = $unsigned(DcacheData[(DcacheAddr[1]  *16) +:16]);
      default: oMemRdData = '0;
    endcase
  end
//assign oMem2.ExResult5 = oMemRdData;
assign oMem2.ExResult[5] = oMemRdData;
endmodule: MemRd
