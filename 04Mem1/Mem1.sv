//this module is include SramWrap and AlignBytesSel
//SramWrap is used as data memory,
//AlignBytesSel is used to choose which word
import BasicParam::*;
import ZionDataType::*;
module Mem1
#(parameter
  CACHE_WIDTHE = 6,
  CACHE_DEEPTHE = 6
  //DATA_FILE = "data.sv"
)(
  // input clk, 
  De1Ifs.Mem1         iDe1Data,
  //ExMem1Ifs.Mem1      iMem1Data,
  DcacheInputIfs.Mem1 iDcacheBus,
  Mem1Mem2Ifs.Mem1    oMem1,
 
  //input logic [2**CACHE_WIDTHE-1:0] iMemData,
  output logic oCen,
  output logic oWrEn,
  output logic [CACHE_DEEPTHE-1:0] oAddr,
  output logic [2**CACHE_WIDTHE-1:0] oWrData,
  output logic [2**CACHE_WIDTHE-1:0] oWrMask
);

  // CpuType MemRdData;
  // SramWrap #(.BITS(2**CACHE_WIDTHE),
  //            .WORDS(2**CACHE_DEEPTHE),
  //            .ADRESS_WIDTH(CACHE_DEEPTHE),
  //            .FILE(DATA_FILE))
  //          U_SramDCache(
  //            .clk(clk),
  //            .adress(iDcacheBus.addr),
  //            .cen(iDe1Data.MemEn),
  //            .wen(iDcacheBus.WrEn),
  //            .din(iDcacheBus.WrData),
  //            .mask(iDcacheBus.WrMask),
  //            .dout(MemRdData)
  //          );
  
  
  //assign oMem1.MemRdData = iMemData;
  //assign oMem1.MemAddr = iMem1Data.MemAddr;

  assign oAddr = iDcacheBus.addr;
  assign oCen = iDe1Data.MemEn;
  assign oWrEn = iDcacheBus.WrEn;
  assign oWrData = iDcacheBus.WrData;
  assign oWrMask = iDcacheBus.WrMask;


  

endmodule: Mem1


