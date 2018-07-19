import ZionDataType::*;
module Ex5
#(parameter
  CACHE_WIDTHE = 6,
  CACHE_DEEPTHE = 6
)(
  ExIfs.Ex iExData,
  InsBitDispatchIfl.Ex iIns,
  DcacheInputIfs.Ex oDcacheBus,
  output logic [11:0] Addr,
  output logic [1:0] MemAddr
  //ExMem1Ifs.Ex oExData

);
  //This module is write for laod and store
  CpuType S1Data,S2Data;
  assign S1Data = iExData.DeS1;
  assign S2Data = iExData.DeS2 & {$bits(CpuType){!iExData.MemOpEn[4]}} |
                  iIns.Simm    & {$bits(CpuType){ iExData.MemOpEn[4]}} ;

  CpuType MemAddrTemp;
  assign MemAddrTemp = S1Data + S2Data;
  

  CpuType MemData;
  assign MemData= iExData.DeS2 ;     //data
  assign MemAddr = MemAddrTemp[1:0] ;     //addr

  logic WrEn;
  // logic [CACHE_DEEPTHE-1:0] Wraddr;
  logic [2**CACHE_WIDTHE-1:0] WrMask;
  logic [2**CACHE_WIDTHE-1:0] WrData;


  MemWr #(.CACHE_WIDTHE(CACHE_WIDTHE),
          .CACHE_DEEPTHE(CACHE_DEEPTHE))
        U_MemWr(

          .iMemWrOpEn(iExData.MemOpEn),
          .iMemWrRes1(MemData),  
          .iMemWrRes2(MemAddrTemp[1:0]),
          .oMemWrdata(WrData),
          .oMemWrmask(WrMask),
          // .oMemWraddr(Wraddr),
          .oMemWrEn(WrEn)
        );

  //ODcacheBus connected data mmemory which is used for reading or writing data
  //the data comes from MemWr
  //assign oDcacheBus.cen    = iExData.MemOpEn[5];
  assign oDcacheBus.WrEn   = WrEn;
  assign oDcacheBus.WrData = WrData;
  assign oDcacheBus.WrMask = WrMask;

  //there is a select for address of data memory,
  //if write memory address comes from MemWr,
  //else(read memory) memory address comes from MemAddr
  logic [11:0] Addr ;
  
  assign Addr = MemAddrTemp[(CACHE_WIDTHE-3)+:CACHE_DEEPTHE] ;
  
  //assign oDcacheBus.Addr = Addr ;

  
endmodule




