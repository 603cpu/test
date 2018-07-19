import ZionDataType::*;
module Ex2
(
  ExIfs.Ex iExData,
  output CpuType oResult 
);
  //This module is write for mult
  logic [(2*$bits(CpuType))-1 : 0] Product;
  CpuType MultS1, MultS2;
  assign MultS1 = iExData.DeS1Sign ? (~iExData.DeS1 + 1'b1) : iExData.DeS1;
  assign MultS2 = iExData.DeS2Sign ? (~iExData.DeS2 + 1'b1) : iExData.DeS2;

   DW02_mult #(.A_width($bits(CpuType)),
              .B_width($bits(CpuType)))
            U_DW02_mult(
              .A      (MultS1),
              .B      (MultS2),
              .TC     (1'b0), 
              .PRODUCT(Product)
            );
            
  logic [(2*$bits(CpuType))-1 : 0] MultRes;
  wire ProductSign = iExData.DeS1Sign ^ iExData.DeS2Sign;
  assign MultRes = ProductSign ? (~Product + 1'b1) : Product;

  CpuType Ex2ResTmp;
  assign Ex2ResTmp = MultRes[(2*$bits(CpuType)-1)-:$bits(CpuType)] & {$bits(CpuType){iExData.MultOpEn[0]}} |
                     MultRes[(  $bits(CpuType)-1)-:$bits(CpuType)] & {$bits(CpuType){iExData.MultOpEn[1]}} ;


 

assign oResult= Ex2ResTmp ;
endmodule