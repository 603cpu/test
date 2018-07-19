module MultiOrCell    //line or
#(parameter
  INPUTNUM = 7,
  BITWIDTH = 32
)(
  De1Ifs.OrCell iDe1Data,
  De2Ifs.OrCell iDe2Data,
  FeIfs.OrCell iFe,
  ExResSelectIfs.MultiOrCellUnitIN OrCellIn,
  OrCellWbIfs.OrCell OrCellOut
);
  wire [BITWIDTH-1:0] IN [INPUTNUM-1:0];
  wire [INPUTNUM-1:0] En;

  assign En[0] = iDe1Data.IntEn     & iDe2Data.BitEn;
  assign En[1] = iDe1Data.IntEn     & iDe2Data.ShiftEn;
  assign En[2] = iDe1Data.MultDivEn & iDe2Data.MultEn;
  assign En[3] = iDe1Data.MultDivEn & iDe2Data.DivEn;
  assign En[4] = iDe1Data.IntEn     & iDe2Data.AddEn;
  assign En[5] = iDe1Data.MemEn;
  assign En[6] = iDe1Data.BJEn ;

  //assign IN = OrCellIn.ExResult;
  
  assign IN[0] = OrCellIn.ExResult[0];
  assign IN[1] = OrCellIn.ExResult[1];
  assign IN[2] = OrCellIn.ExResult[2];
  assign IN[3] = OrCellIn.ExResult[3];
  assign IN[4] = OrCellIn.ExResult[4];
  assign IN[5] = OrCellIn.ExResult[5];
  assign IN[6] = iFe.PcAdd4;

  assign OrCellOut.OrCellWbData = IN[0] & {32{En[0]}} | IN[1] & {32{En[1]}} |IN[2] & {32{En[2]}} |
                                  IN[3] & {32{En[3]}} | IN[4] & {32{En[4]}} |IN[5] & {32{En[5]}} |
                                  IN[6] & {32{En[6]}} ;
  //assign  En=iExData.DeEn;
  
  // logic [INPUTNUM-1:0] InOrd[BITWIDTH];
  // wire [BITWIDTH-1:0] Out;
  // genvar i;
  // generate
  //   for(i=0;i<BITWIDTH;i=i+1)begin
  //     always_comb begin : proc_signal_re
  //       for(int j=0;j<INPUTNUM;j=j+1)begin
  //         InOrd[i][j] = IN[j][i];
  //       end
  //     end
  //     OrCell U_OrCell(.In(InOrd[i]),
  //                     .En(En),
  //                     .Out(Out[i])
  //                     );
  //   end
  // endgenerate

  // assign OrCellOut.OrCellWbData = Out;
endmodule