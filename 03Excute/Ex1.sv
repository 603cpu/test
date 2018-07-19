import ZionDataType::*;
module Ex1
(
	ExIfs.Ex iExData,
	InsBitDispatchIfl.Ex iIns,
	output CpuType oResult 
);

RfRs DeS2;
assign DeS2 = iExData.DeS2[4:0] | iIns.shamt & {$bits(DeS2){iExData.ShamtEn}};
//This module is write for <<,>>,>>>
wire [$bits(CpuType)-1:0] ResTemp[3];
assign ResTemp[0] = (iExData.DeS1 << DeS2)  & {32{iExData.ShiftOpEn[0]}};
assign ResTemp[1] = (iExData.DeS1 >> DeS2)  & {32{iExData.ShiftOpEn[1]}};
assign ResTemp[2] = ($signed(iExData.DeS1) >>> DeS2) & {32{iExData.ShiftOpEn[2]}};

//CpuType oResult;
assign oResult = ResTemp[0] | ResTemp[1] | ResTemp[2];


endmodule : Ex1