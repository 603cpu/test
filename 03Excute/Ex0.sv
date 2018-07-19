import ZionDataType::*;
module Ex0
(
	ExIfs.Ex iExData,
	output CpuType oResult 
);
//This module is write or &,|,^,-
  logic signed [$bits(CpuType)+1-1:0] ExS1Extd, ExS2Extd;
  assign ExS1Extd = {iExData.DeS1Sign,iExData.DeS1};
  assign ExS2Extd = {iExData.DeS2Sign,iExData.DeS2};
  wire Slt_en = iExData.BitOpEn[4] && (ExS1Extd < ExS2Extd) ;

	wire [$bits(CpuType)-1:0] ResTemp[4];
	assign ResTemp[0] = (iExData.DeS1 & iExData.DeS2) & {32{iExData.BitOpEn[0]}};
	assign ResTemp[1] = (iExData.DeS1 | iExData.DeS2) & {32{iExData.BitOpEn[1]}};
	assign ResTemp[2] = (iExData.DeS1 ^ iExData.DeS2) & {32{iExData.BitOpEn[2]}};
	assign ResTemp[3] = (iExData.DeS1 - iExData.DeS2) & {32{iExData.BitOpEn[3]}};
							
	//CpuType oResult;
	assign oResult = ResTemp[0] | ResTemp[1] | ResTemp[2] | ResTemp[3] | $unsigned(Slt_en);


endmodule : Ex0