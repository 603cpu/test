module RegFileLatch
#(
  parameter ADDR_WIDTH    = 4,
  parameter DATA_WIDTH    = 32
)
(
  // Clock and Reset
  input  logic                   clk,
  input  logic                   rstn,

  //output mem
  output logic [DATA_WIDTH-1:0]  mem [2**ADDR_WIDTH-1:1],

/*
  //Read port R1
  input  logic [ADDR_WIDTH-1:0]  iRdAddr0,
  output logic [DATA_WIDTH-1:0]  oRdData0,

  //Read port R2
  input  logic [ADDR_WIDTH-1:0]  iRdAddr1,
  output logic [DATA_WIDTH-1:0]  oRdData1,
*/

  // Write port W1
  input  logic [ADDR_WIDTH-1:0]   iWrAddr,
  input  logic [DATA_WIDTH-1:0]   iWrData,
  input  logic                    iWrEn
);

  localparam    NUM_WORDS = 2**ADDR_WIDTH;

  // logic [DATA_WIDTH-1:0] mem[NUM_WORDS-1:1];

  // assign oRdData0 = (iRdAddr0=='0)? '0 : mem[iRdAddr0];
  // assign oRdData1 = (iRdAddr1=='0)? '0 : mem[iRdAddr1];
  
  logic [NUM_WORDS-1:1] WrOnehot;
  always_comb begin : Proc_WrOneHotGen
    for(int i = 1; i < NUM_WORDS; i++) begin
      if ( (iWrEn == 1'b1 ) && (iWrAddr == i) )
        WrOnehot[i] = 1'b1;
      else
        WrOnehot[i] = 1'b0;
    end
  end

  logic [NUM_WORDS-1:1] WrOnehotLatch;
  always_latch begin
    for(int i = 1; i < NUM_WORDS; i++) begin
      if (~clk)
        WrOnehotLatch[i] = WrOnehot[i];
    end
  end

  logic [DATA_WIDTH-1:0] DataTemp;
  always_latch begin
    if (~clk)
      DataTemp = iWrData;
  end

  wire [NUM_WORDS-1:1] WrVld = {(NUM_WORDS-1){clk}} & WrOnehotLatch;

  always_latch begin : Proc_RegFileLatch
    for(int i = 1; i < NUM_WORDS; i++) begin
      if(WrVld[i] == 1'b1)
        mem[i] = DataTemp;
    end
  end

 // //read
 //  logic [31:1] oAddrOnehot0, oAddrOnehot1;
 //  always_comb begin : Proc_OneHotGen0
 //    for(int i = 1; i < NUM_WORDS; i++) begin
 //      if (iRdAddr0 == i)
 //        oAddrOnehot0[i] = 1'b1;
 //      else
 //        oAddrOnehot0[i] = 1'b0;
 //    end
 //  end

 //  always_comb begin : Proc_OneHotGen1
 //    for(int i = 1; i < NUM_WORDS; i++) begin
 //      if (iRdAddr1 == i)
 //        oAddrOnehot1[i] = 1'b1;
 //      else
 //        oAddrOnehot1[i] = 1'b0;
 //    end
 //  end
 //  //
 //  logic [DATA_WIDTH-1:0] DataTemp0 [NUM_WORDS-1:1];
 //  logic [DATA_WIDTH-1:0] DataTemp1 [NUM_WORDS-1:1];
 //  genvar j;
 //  generate
 //    for(j = 1; j < NUM_WORDS; j++)
 //      assign DataTemp0[j] = {(DATA_WIDTH){oAddrOnehot0[j]}} & mem[j];
 //  endgenerate

 //  generate
 //    for(j = 1; j < NUM_WORDS; j++)
 //      assign DataTemp1[j] = {(DATA_WIDTH){oAddrOnehot1[j]}} & mem[j];
 //  endgenerate
 //  //output data0
 //  assign oRdData0 = DataTemp0[31] | DataTemp0[30] | DataTemp0[29] | DataTemp0[28] |
 //                    DataTemp0[27] | DataTemp0[26] | DataTemp0[25] | DataTemp0[24] |
 //                    DataTemp0[23] | DataTemp0[22] | DataTemp0[21] | DataTemp0[20] |
 //                    DataTemp0[19] | DataTemp0[18] | DataTemp0[17] | DataTemp0[16] |
 //                    DataTemp0[15] | DataTemp0[14] | DataTemp0[13] | DataTemp0[12] |
 //                    DataTemp0[11] | DataTemp0[10] | DataTemp0[ 9] | DataTemp0[ 8] |
 //                    DataTemp0[ 7] | DataTemp0[ 6] | DataTemp0[ 5] | DataTemp0[ 4] |
 //                    DataTemp0[ 3] | DataTemp0[ 2] | DataTemp0[ 1] ;
 //  //output data1
 //  assign oRdData1 = DataTemp1[31] | DataTemp1[30] | DataTemp1[29] | DataTemp1[28] |
 //                    DataTemp1[27] | DataTemp1[26] | DataTemp1[25] | DataTemp1[24] |
 //                    DataTemp1[23] | DataTemp1[22] | DataTemp1[21] | DataTemp1[20] |
 //                    DataTemp1[19] | DataTemp1[18] | DataTemp1[17] | DataTemp1[16] |
 //                    DataTemp1[15] | DataTemp1[14] | DataTemp1[13] | DataTemp1[12] |
 //                    DataTemp1[11] | DataTemp1[10] | DataTemp1[ 9] | DataTemp1[ 8] |
 //                    DataTemp1[ 7] | DataTemp1[ 6] | DataTemp1[ 5] | DataTemp1[ 4] |
 //                    DataTemp1[ 3] | DataTemp1[ 2] | DataTemp1[ 1] ;

endmodule: RegFileLatch
