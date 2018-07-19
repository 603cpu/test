module RsRd#(
  parameter ADDR_WIDTH    = 4,
            DATA_WIDTH    = 32
	)(
	input [ADDR_WIDTH-1:0] iRdAddr,
	output [DATA_WIDTH-1:0] oRdData,
	input  [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:1]
	);
	//wire [DATA_WIDTH-1:0] mem [NUM_WORDS-1:1];
  localparam NUM_WORDS = 2**ADDR_WIDTH;
	logic [DATA_WIDTH-1:0] DataTemp [NUM_WORDS-1:1];

	logic [31:1] oAddrOnehot;
  always_comb begin : Proc_OneHotGen
    for(int i = 1; i < NUM_WORDS; i++) begin
      if (iRdAddr == i)
        oAddrOnehot[i] = 1'b1;
      else
        oAddrOnehot[i] = 1'b0;
    end
  end
genvar j;
generate
	for(j=1;j<NUM_WORDS;j=j+1) begin
		assign DataTemp[j] =  mem[j] & {(DATA_WIDTH){oAddrOnehot[j]}}; 
	end
endgenerate

  assign oRdData  = 
                    DataTemp[15] | DataTemp[14] | DataTemp[13] | DataTemp[12] |
                    DataTemp[11] | DataTemp[10] | DataTemp[ 9] | DataTemp[ 8] |
                    DataTemp[ 7] | DataTemp[ 6] | DataTemp[ 5] | DataTemp[ 4] |
                    DataTemp[ 3] | DataTemp[ 2] | DataTemp[ 1] ;
endmodule