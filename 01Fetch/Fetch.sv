////////////////////////////////////////////////////////////////
//This module is used for fetching instructios
//Including PcGen, SramWrapIcache and InsFetching three modules
////////////////////////////////////////////////////////////////
import ZionDataType::*;
module Fetch
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 12,
  START_PC = 'h200
)(
  // SysIf.in SIf,
  input  wire    clk,
  input  wire    rstn,
  BjBusIfs.Fe    iBjBus,
  FeIfs.Fe     oFeData,
  output logic [CACHE_DEEPTHE-1   : 0] oInsAddr,
  output logic oRstingBlk
);

  CpuType CurrentPC;
  //logic [CACHE_DEEPTHE-1:0]   oInsAddr;
  //logic [2**CACHE_WIDTHE-1:0] IcacheData;
 

  PcGen #(.CACHE_WIDTHE(CACHE_WIDTHE),
          .CACHE_DEEPTHE(CACHE_DEEPTHE),
          .START_PC(START_PC))
        U_PcGen(
          // .SIf(SIf),
          .clk       (clk),
          .rstn      (rstn),
          .iBjBus    (iBjBus),
          .oPcAdd4   (oFeData.PcAdd4),
          .oCurrentPC(CurrentPC),
          .oInsAddr  (oInsAddr),
          .oRstingBlk(oRstingBlk)
        );
  

  // SramWrap #(.BITS(2**CACHE_WIDTHE),
  //            .WORDS(2**CACHE_DEEPTHE),
  //            .ADRESS_WIDTH(CACHE_DEEPTHE),
  //            .FILE(INS_FILE))
  //          U_SramIcache(
  //            // .clk(SIf.clk),
  //            .clk(clk),
  //            .adress(oInsAddr),
  //            .cen(1'b1),
  //            .wen(1'b0),
  //            .din('0),
  //            .mask('0),
  //            .dout(oFeData.FeIns)
  //          );
  assign oFeData.Pc = CurrentPC & {$bits(CurrentPC){oRstingBlk}};
endmodule: Fetch
