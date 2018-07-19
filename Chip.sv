  module Chip
  #(parameter
  CACHE_WIDTHE  = 5,
  CACHE_DEEPTHE = 12,
  LAST_PC       = 32'h2b4,
  INS_FILE      = "ins_file.sv",
  DATA_FILE     = "data_file.sv"
)(input logic ClkMax,
  SysIf.in SIf
);

  logic clkFe;
  logic clkMem;
  ICacheIfs ICache();
  DcacheInputIfs DcacheBus();
  logic MemEn;
  logic [31:0] MemData;
  
  Core     #(
              .CACHE_WIDTHE (CACHE_WIDTHE),
              .CACHE_DEEPTHE(CACHE_DEEPTHE),
              .LAST_PC      (LAST_PC),
              .INS_FILE     (INS_FILE),
              .DATA_FILE    (DATA_FILE)
              )
           U_Core(
              .ClkMax(ClkMax),
              .SIf   (SIf),
              .clkFe (clkFe),
              .clkMem(clkMem),
              .ICache(ICache),
              .MemData(MemData),
              .DcacheBus(DcacheBus),
              .MemEn(MemEn),
              .Addr(DcacheBus.Addr)
             );
           
  SramWrap #(.BITS(2**CACHE_WIDTHE),
             .WORDS(2**CACHE_DEEPTHE),
             .ADRESS_WIDTH(CACHE_DEEPTHE),
             .FILE(INS_FILE))
           U_Icache(
             .clk(clkFe),
             .adress(ICache.InsAddr),
             .cen(1'b1),
             .wen(1'b0),
             .din('0),
             .mask('0),
             .dout(ICache.InsData)
           );
  
  SramWrap #(.BITS(2**CACHE_WIDTHE),
             .WORDS(2**CACHE_DEEPTHE),
             .ADRESS_WIDTH(CACHE_DEEPTHE),
             .FILE(DATA_FILE))
           U_DCache(
             .clk(clkMem),
             .adress(DcacheBus.Addr),
             .cen(MemEn),
             .wen(DcacheBus.WrEn),
             .din(DcacheBus.WrData),
             .mask(DcacheBus.WrMask),
             .dout(MemData)
           );


 endmodule 