import ZionDataType::*;
module Sof
(	input clk,
	input rstn,
  input CpuType WbData,
	InsBitDispatchIfl.Sof iIns,
	De1Ifs.Sof iDe1Data,
	ExIfs.Sof  oSofData
	);
  //input Rs1En,input Rs2En,input S1Sign,input S2Sign,input IimmSEn,input IimmUEn
  // output DeS1Sign,output DeS2Sign,output DeS1,output DeS1
  // input IimmU, input IimmS, input rs1, input rs2
  // input data

 	
  logic [3:0] S1Addr,S2Addr;
	CpuType rs1,rs2;

  assign S1Addr = iIns.rs1 & {$bits(S1Addr){iDe1Data.Rs1En}};
  assign S2Addr = iIns.rs2 ;

  //The register file must be read after write.
  RfWrap U_RegFile(
           .clk(clk),
           .rstn(rstn),
           .WrEn(iDe1Data.WbEn),
           .WrAddr(iIns.rd[3:0]),
           .WrData(WbData),
           .RdAddrA(S1Addr),
           .RdAddrB(S2Addr),
           .RdDataA(rs1),
           .RdDataB(rs2)
         );

  assign oSofData.DeS1 = rs1;
  assign oSofData.DeS2 = rs2 & {$bits(rs2){iDe1Data.Rs2En}}
                        | iIns.IimmU & {$bits(rs2){iDe1Data.IimmUEn}}
                        | iIns.IimmS & {$bits(rs2){iDe1Data.IimmSEn}};

  //Sign
  assign oSofData.DeS1Sign = iDe1Data.S1Sign & oSofData.DeS1[$high(oSofData.DeS1)];
  assign oSofData.DeS2Sign = iDe1Data.S2Sign & oSofData.DeS2[$high(oSofData.DeS1)];
endmodule