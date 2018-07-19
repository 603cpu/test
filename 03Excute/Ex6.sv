import ZionDataType::*;
module Ex6
( 
  ExIfs.Ex iExData,
  InsBitDispatchIfl.Ex iIns,
  FeIfs.Ex iFe,
	BjBusIfs.Ex oBjBus
  //output CpuType oResult
);

  logic signed [$bits(CpuType)+1-1:0] ExS1Extd, ExS2Extd;
  assign ExS1Extd = {iExData.DeS1Sign,iExData.DeS1};
  assign ExS2Extd = {iExData.DeS2Sign,iExData.DeS2};

  wire Branch_en = (iExData.BjOpEn[0] & ExS1Extd <  ExS2Extd)  |
                   (iExData.BjOpEn[1] & ExS1Extd >=  ExS2Extd) |
                   (iExData.BjOpEn[2] & iExData.DeS1 == iExData.DeS2) |
                   (iExData.BjOpEn[3] & iExData.DeS1 != iExData.DeS2) ;
  wire Jump_en = iExData.BjOpEn[4] ;

  CpuType S1Data,S2Data;

  wire JalEn  = iExData.UJimmEn;
  wire JalrEn = Jump_en & !JalEn;

  wire PcEn = JalEn | Branch_en;
  assign S1Data = iExData.DeS1 & {$bits(CpuType){JalrEn}}| iFe.Pc & {$bits(CpuType){PcEn}} ;
  assign S2Data = iExData.DeS2 & {$bits(CpuType){JalrEn}} | 
                  iIns.UJimm   & {$bits(CpuType){JalEn }} |
                  iIns.SBimm   & {$bits(CpuType){Branch_en}} ;

  assign oBjBus.ExBjEn = Jump_en | Branch_en;                                 
  assign oBjBus.BjPc = S1Data + S2Data;

  //assign oResult = iFe.PcAdd4 & {$bits(CpuType){Jump_en}};
endmodule 