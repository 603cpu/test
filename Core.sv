module Core 
#(parameter
	CACHE_WIDTHE  = 5,
	CACHE_DEEPTHE = 12,
  LAST_PC       = 32'h2b4,
  INS_FILE      = "ins_file.sv",
  DATA_FILE     = "data_file.sv"
)(
  input logic ClkMax,
  SysIf.in SIf,
  output  logic clkFe,
  output  logic clkMem,
  //input  logic clkWb,
  //input  wire                          rstn,
  ICacheIfs.Core ICache,
  //DCacheIfs.Core DCache
  input logic [31:0] MemData,
  DcacheInputIfs.Ex DcacheBus,
  output logic MemEn,
  output logic [11:0] Addr
  // output logic [CACHE_DEEPTHE-1   : 0] oInsAddr,
  // input  logic [2**CACHE_WIDTHE-1 : 0] iInsData,

  // input  wire  [2**CACHE_WIDTHE-1 : 0] iMemData,
  // output logic                         oCen,
  // output logic                         oWrEn,
  // output logic [CACHE_DEEPTHE-1   : 0] oAddr,
  // output logic [2**CACHE_WIDTHE-1 : 0] oWrMask,
  // output logic [2**CACHE_WIDTHE-1 : 0] oWrData,
  //Phase Control signals
);
	
  //logic clkWb;
  //logic [1:0] CtrlRf;
  logic CtrlRf;
  logic [3:0] CtrlDe2;
  logic [6:0] CtrlEx;
  logic  CtrlMemRd;
  logic  CtrlWb;
  //Fetch
  FeIfs     I_FeData();

  //Decode
  De1Ifs    I_De1Data();
  De2Ifs    I_De2Data();

  //Excute
  ExIfs     I_ExData();
  //ExMem1Ifs   I_ExMem1();
 
 
  //Mem
  Mem1Mem2Ifs I_Mem1Mem2();
  OrCellWbIfs I_OrCellWb();
  
  //////
  BjBusIfs   I_BjBus();

  //RfWbBusIfs I_WbBus();
  // DcacheInputIfs #(.CACHE_WIDTHE (CACHE_WIDTHE),
  //                  .CACHE_DEEPTHE(CACHE_DEEPTHE))
  //                I_DcacheBus();

   
  assign I_BjBus.FeBjEn = I_BjBus.ExBjEn & I_De1Data.BJEn;
  //Fetch always on
  logic RstingBlk;

  Fetch #(.CACHE_WIDTHE (CACHE_WIDTHE),
          .CACHE_DEEPTHE(CACHE_DEEPTHE)
        )
        U_Fetch(
          // .SIf      (SIf),
          .clk      (clkFe),
          .rstn     (SIf.rstn),
          .iBjBus   (I_BjBus),
          .oFeData  (I_FeData),
          .oInsAddr (ICache.InsAddr),
          .oRstingBlk (RstingBlk)
        );
   ICache #(.CACHE_WIDTHE (CACHE_WIDTHE),
            .CACHE_DEEPTHE(CACHE_DEEPTHE)
            //.INS_FILE     (INS_FILE)
            )
        U_ICache(
          // .SIf      (SIf),
          // .clk        (clkFe),
          // .rstn       (SIf.rstn),
          .iInsData   (ICache.InsData),
          .iRstingBlk (RstingBlk),
          .oFeData    (I_FeData)
        );
  //Decode
  InsBitDispatchIfl I_InsBitDispatch();

  InsBitDispatch U_InsBitDispatch(
                  .oIns   (I_InsBitDispatch),
                  .iFeData(I_FeData)
    );  

  Decode1 U_Decode1(.iIns(I_InsBitDispatch),
                    .oDe1Data (I_De1Data),
                    .De1ExData(I_ExData),
                    .MemEn(MemEn)
                   );
  Decode2 U_Decode2(
                  .iIns   (I_InsBitDispatch),
                  .oDe2(I_De2Data),
                  .De2ExData(I_ExData)
    );
  Sof U_Sof(
            .clk     (clkFe),
            .rstn    (SIf.rstn),
            .WbData  (I_OrCellWb.OrCellWbData),
            .iIns    (I_InsBitDispatch),
            .iDe1Data(I_De1Data),
            .oSofData(I_ExData)
    );

 
  //Excute
  ExResSelectIfs I_ExResSelect();
  wire[31:0] bMemRes;
  logic [1:0] MemAddr;
  Excute #(.CACHE_WIDTHE (CACHE_WIDTHE),
           .CACHE_DEEPTHE(CACHE_DEEPTHE))
         U_Excute(
                  .iExData    (I_ExData),
                  .iIns       (I_InsBitDispatch),
                  .iFe        (I_FeData),
                  .oEx(I_ExResSelect),
                  .oDcacheBus(DcacheBus),
                  .oBjBus(I_BjBus),
                  .Addr(Addr),
                  .MemAddr(MemAddr)
                  //.oExMem1Data(I_ExMem1)
                  );
  // Mem1 #(.CACHE_WIDTHE  (CACHE_WIDTHE),
  //        .CACHE_DEEPTHE(CACHE_DEEPTHE)
  //        //.DATA_FILE    (DATA_FILE)
  //        )
  //      U_Mem1(
  //        // .clk       (clkMem),
  //        .iDe1Data  (I_De1Data),
  //        //.iMem1Data (I_ExMem1),
  //        .iDcacheBus(I_DcacheBus),
  //        .oMem1     (I_Mem1Mem2),
         
  //        //.iMemData  (DCache.MemData),
  //        .oCen      (DCache.Cen),
  //        .oWrEn     (DCache.WrEn),
  //        .oAddr     (DCache.Addr),
  //        .oWrMask   (DCache.WrMask),
  //        .oWrData   (DCache.WrData)
  //      );
  
  MemRd U_MemRd(
                .iMem2Data(I_Mem1Mem2),
                .DcacheData(MemData),
                .DcacheAddr(MemAddr),
                .iRdOp(I_ExData),
                .oMem2(I_ExResSelect)
                );
  MultiOrCell U_MultiOrCell(
                .iDe1Data (I_De1Data),
                .iDe2Data (I_De2Data),
                .iFe(I_FeData),
                .OrCellIn(I_ExResSelect),
                .OrCellOut(I_OrCellWb)
    );
 
  // wire RfIso;
  // wire [3:0] De2Iso;
  wire ExIso;
  // wire MemRdIso;
  wire WbIso;
  PhaseCtrl U_PhaseCtrl(
              .ClkMax   (ClkMax),
              .SIf(SIf),
              .iDe1(I_De1Data),
              .iDe2(I_De2Data),
              .clkFe(clkFe),
              .clkMem(clkMem),
              //.clkWb(clkWb),
              .CtrlRf(CtrlRf),
              .CtrlDe2(CtrlDe2),
              .CtrlEx(CtrlEx),
              .CtrlMemRd(CtrlMemRd),
              .CtrlWb   (CtrlWb),
              //iso
              // .RfIso(RfIso),
              // .De2Iso(De2Iso),
              .ExIso(ExIso),
              // .MemRdIso(MemRdIso),
              .WbIso(WbIso)
            );
 #####################
  `ifdef AutoSim
  AutoSim #(.LAST_PC(LAST_PC))
          U_AutoSim(
            // .SIf      (SIf),
            .clk      (clkFe),
            .rstn     (SIf.rstn),

            .WbData   (I_OrCellWb.OrCellWbData),
            .iFe      (I_FeData),
            .iIns     (I_InsBitDispatch),
            .iDe1     (I_De1Data)
          );
  `endif

endmodule