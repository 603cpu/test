////////////////////////////////////////////////////////////////
//This module is used for fetching instructios
//Including PcGen, SramWrapIcache and InsFetching three modules
////////////////////////////////////////////////////////////////
import ZionDataType::*;
module ICache
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 12
  //INS_FILE = "ins.sv"
)(
  // SysIf.in SIf,
  // input  wire    clk,
  // input  wire    rstn,
  input logic [2**CACHE_WIDTHE-1   : 0] iInsData,
  input logic iRstingBlk,
  FeIfs.ICache   oFeData
);


  // logic [2**CACHE_WIDTHE-1:0] IcacheData;



  // SramWrap #(.BITS(2**CACHE_WIDTHE),
  //            .WORDS(2**CACHE_DEEPTHE),
  //            .ADRESS_WIDTH(CACHE_DEEPTHE),
  //            .FILE(INS_FILE))
  //          U_SramIcache(
  //            // .clk(SIf.clk),
  //            .clk(clk),
  //            .adress(iInsAddr),
  //            .cen(1'b1),
  //            .wen(1'b0),
  //            .din('0),
  //            .mask('0),
  //            .dout(IcacheData)
  //          );
  assign oFeData.Ins = iInsData & {$bits(iInsData){iRstingBlk}};
endmodule
