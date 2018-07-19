module RfWrap
#(parameter
  ADDR_WIDTH    = 4,
  DATA_WIDTH    = 32
)(
  input logic clk,
  input logic rstn,
  input logic WrEn,
  input logic [3:0]	WrAddr,
  input logic [31:0]	WrData,
  input logic [3:0]	RdAddrA,
  input logic [3:0]	RdAddrB,
  output logic [31:0]	RdDataA, RdDataB
);

  // logic	[31:0]	RfReg[32];
  // assign	RdDataA = (RdAddrA==5'b0) ? '0 : RfReg[RdAddrA];
  // assign  RdDataB = (RdAddrB==5'b0) ? '0 : RfReg[RdAddrB];
  
  // always_ff @(posedge clk or negedge rstn) begin : proc_RfReg
  //   if(~rstn) begin
  //     RfReg[0] <= '0;
  //     for (int i = 1; i < 32; i++)
  //       RfReg[i] <= 32'h0;
  //   end else begin
  //     if(WrEn)
  //       RfReg[WrAddr] <= WrData;
  //     else
  //       RfReg[WrAddr] <= RfReg[WrAddr];
  //   end
  // end

  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:1];

  RegFileLatch U_RegFileLatch(
                .clk(clk),
                .rstn(rstn),
                //Write port
                .iWrEn(WrEn),
                .iWrAddr(WrAddr),
                .iWrData(WrData),
                //output mem
                .mem(mem)
              );

  RsRd U_Rs1Rd (.iRdAddr(RdAddrA),
                .oRdData(RdDataA),
                .mem    (mem));

  RsRd U_Rs2Rd (.iRdAddr(RdAddrB),
                .oRdData(RdDataB),
                .mem    (mem));
  
endmodule
