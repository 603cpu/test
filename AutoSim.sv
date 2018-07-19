import ZionDataType::*;
module AutoSim
#(parameter
  START_PC = 'h200,
  LAST_PC = 32'h2b4
)(
  // SysIf.in SIf,
  input  wire  clk,
  input  wire  rstn,
  input CpuType WbData,
  FeIfs.AutoSim iFe,
  InsBitDispatchIfl.AutoSim iIns,
  De1Ifs.AutoSim iDe1

  //DeExIfl.AutoSim iMemWb,
  // MemWrBusIfs.in iMemWr,
  // RfWbBusIfs.in iRfWb,
  // PipeCtrlIfl.Sim iPipeCtrl
);

  CpuType SimRf[32];
  logic FprtEn;
  CpuType FprtPc,data;
  CpuIns FprtIns;
  // logic FprtMemWrEn;
  // logic [$bits(iMemWr.addr)-1:0] FprtMemWrAddr;
  // logic [$bits(iMemWr.data)-1:0] FprtMemWrData;
  // logic [$bits(iMemWr.mask)-1:0] FprtMemWrMask;
  always #1 data = WbData;
  always_ff @ (posedge clk or negedge rstn) begin : AutoSim_Rf
    if(~rstn) begin
      for(int i=0;i<32;i++) begin
          SimRf[i] <= '0;
      end
    end else begin
      for(int i=1;i<32;i++) begin
          SimRf[i] <= (iDe1.WbEn && iIns.rd==i)? data:SimRf[i];
      end
    end
  end

  always_ff @ (posedge clk or negedge rstn) begin : AutoSim_OtherData
    if(~rstn) begin
      {FprtEn,FprtPc,FprtIns/*,FprtMemWrEn,FprtMemWrAddr,FprtMemWrData,FprtMemWrMask*/} <= '0;
    // end else begin
      // if(iPipeCtrl.WbStl) begin
      //   {FprtEn,FprtPc,FprtIns,FprtMemWrEn,FprtMemWrAddr,FprtMemWrData,FprtMemWrMask} <= '0;
      end else if(iFe.Pc == '0) begin
        {FprtEn,FprtPc,FprtIns/*,FprtMemWrEn,FprtMemWrAddr,FprtMemWrData,FprtMemWrMask*/} <= '0;
      end else begin
        FprtEn <= 1'b1;
        FprtPc <= iFe.Pc;
        FprtIns <= iFe.Ins;
        // FprtMemWrEn <= iMemWr.WrEn;
        // FprtMemWrAddr <= iMemWr.addr;
        // FprtMemWrData <= iMemWr.data;
        // FprtMemWrMask <= iMemWr.mask;
      end
    //end
  end

  integer FinalResultfp;
  initial begin
    FinalResultfp = $fopen("FinalResult.txt");
    forever @ (posedge clk) begin
      // if(FprtPc == 32'h000002b4) begin
      if(FprtPc == LAST_PC) begin
          $fdisplay(FinalResultfp, "%h", FprtPc);
          $fclose(FinalResultfp);
          break;
      end
      else if(FprtEn) begin
        $fdisplay(FinalResultfp, "%h", FprtPc);
        //$fdisplay(FinalResultfp, "%h", FprtIns);
        //$fdisplay(FinalResultfp, "%h", FprtMemWrWrEn);
        //$fdisplay(FinalResultfp, "%h", FprtMemWrAddr);
        //$fdisplay(FinalResultfp, "%h", FprtMemWrData);
        //$fdisplay(FinalResultfp, "%h", FprtMemWrMask);
        for(int i=0;i<4;i++)begin
          for(int j=0;j<8;j++)begin
            $fwrite(FinalResultfp, "%h ", SimRf[i*8+j]);
          end
          $fwrite(FinalResultfp, "\n");
        end
      end
    end
  end

  //print start time and finish time
  integer FinishTime;
  initial begin
    FinishTime = $fopen("FinishTime.txt");
    forever @ (posedge clk) begin
      if(FprtPc == START_PC) begin
        $fdisplay(FinishTime, "%0t", $time);
      end else if(FprtPc == LAST_PC) begin
        $fdisplay(FinishTime, "%0t", $time);
        $fclose(FinishTime);
        break;
      end
    end
    $finish();
  end // initial

endmodule

