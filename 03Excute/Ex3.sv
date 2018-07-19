import ZionDataType::*;
module Ex3
(
  ExIfs.Ex iExData,
  output CpuType oResult 
);
  //This module is write for DIV
  CpuType  DivS1, DivS2;
  CpuType Quo, Rem;

  assign DivS1  =  iExData.DeS1Sign ? (~iExData.DeS1 + 1'b1) : iExData.DeS1;
  assign DivS2  =  iExData.DeS2Sign ? (~iExData.DeS2 + 1'b1) : iExData.DeS2;

  CpuType DivRes, RemRes; 
  wire QuoSign     = iExData.DeS1Sign ^ iExData.DeS2Sign;
  wire RemSign     = iExData.DeS1Sign;
  assign DivRes  = QuoSign ? (~Quo + 1'b1) : Quo;
  assign RemRes  = RemSign ? (~Rem + 1'b1) : Rem;

  DW_div  #(.a_width ($bits(CpuType)),
          .b_width ($bits(CpuType)),
          .tc_mode (0), //unsigned division
          .rem_mode(1))
        U0_DW_div(
          .a          (DivS1),
          .b          (DivS2),
          .quotient   (Quo),
          .remainder  (Rem),
          .divide_by_0()
        );

  CpuType Ex3ResTmp;
  assign Ex3ResTmp = RemRes & {$bits(CpuType){iExData.DivOpEn[0]}} |
                     DivRes & {$bits(CpuType){iExData.DivOpEn[1]}} ;
  

assign oResult = Ex3ResTmp ;
endmodule