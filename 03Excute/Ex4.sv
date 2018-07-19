import ZionDataType::*;
module Ex4
(
	ExIfs.Ex iExData,
	InsBitDispatchIfl.Ex iIns,
	FeIfs.Ex iFe,
	output CpuType oResult 
);
	//This module is write for add,addi,lui.AuiPc 
  CpuType S1Data,S2Data;

  assign S1Data = iExData.DeS1 | iIns.Uimm & {$bits(CpuType){iExData.UimmEn}};
  assign S2Data = iExData.DeS2 | iFe.Pc    & {$bits(CpuType){iExData.AddOpEn}};

  assign oResult = S1Data + S2Data;

endmodule