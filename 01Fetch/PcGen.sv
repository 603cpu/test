///////////////////////////////////////////////////////////////////
//This module is used for generating PC used to fetch Instructions
///////////////////////////////////////////////////////////////////
import ZionDataType::*;
module PcGen
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 6,
  START_PC = 'h200
)(
  // SysIf.in SIf,
  input  wire  clk,
  input  wire  rstn,
  output CpuType oCurrentPC,
  output CpuType oPcAdd4,
  BjBusIfs.Fe  iBjBus,
  output logic [CACHE_DEEPTHE-1:0] oInsAddr,
  output logic oRstingBlk
);

  localparam RST_PC = START_PC - 4;

  //===========================================================
  CpuType pc;
  CpuType NextPc;

  always_ff @(posedge clk or negedge rstn) begin : proc_PcGen
    if(~rstn) begin
      pc <= RST_PC;
    // end else begin
    //   if(iPipeCtrl.FeStl) begin
    //     pc <= pc;
      end else begin
        pc <= NextPc;
      //end
    end
  end
  //notice that NextPc represent address of next instruction ,so NextPc = pc + 4(instruction is four bytes)
  //when jump is taken the NextPC is jump address
  CpuType PcAdd4;
  assign PcAdd4 = pc + 'd4;
  wire   CpuResetting = pc==RST_PC;
  assign NextPc = (CpuResetting)? START_PC : ((iBjBus.FeBjEn)? iBjBus.BjPc : PcAdd4);
  assign oCurrentPC = pc ;
  //when the instruction is load or store, it needs to stall one cycle,
  //and the instruction fetched by current PC
  // assign InsAddr = (iPipeCtrl.FeStl & ~CpuResetting)? pc[(CACHE_WIDTHE-3)+:CACHE_DEEPTHE] :
  //                                                     NextPc[(CACHE_WIDTHE-3)+:CACHE_DEEPTHE];
  assign oInsAddr =  NextPc[(CACHE_WIDTHE-3)+:CACHE_DEEPTHE];                           
  assign oRstingBlk = !CpuResetting;
  assign oPcAdd4 = PcAdd4;
endmodule: PcGen
