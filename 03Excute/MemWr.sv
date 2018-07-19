
//this module generate data addr mask and WrEn,
//and these signals connect to Excute module,
//Excute module will write the data to data memory.
//BytesWriterMask module is used to select some bytes(Byte halfword and word) are active.
import ZionDataType::*;
module MemWr
#(parameter
  CACHE_WIDTHE = 6,
  CACHE_DEEPTHE = 6
)(
  
  input        [4:0]           iMemWrOpEn, 
  input        CpuType         iMemWrRes1,
  input        [1:0]           iMemWrRes2,
  output                       oMemWrEn,
  // output [CACHE_DEEPTHE-1 : 0] oMemWraddr,
  output [2**CACHE_WIDTHE-1:0] oMemWrdata,
  output [2**CACHE_WIDTHE-1:0] oMemWrmask
);


  wire [2**CACHE_WIDTHE-1:0] DcacheLineNewData = '0 ;
  reg  [2**CACHE_WIDTHE-1:0] oResult,oMask;

  wire MemWrEn = iMemWrOpEn[4];
  wire SbEn = iMemWrOpEn[1];
  wire ShEn = iMemWrOpEn[2];
  wire SwEn = iMemWrOpEn[3];
  always_comb begin
    unique case(1'b1)
      SbEn :  for(int i=0;i<4;i=i+1) begin
                  if(iMemWrRes2[1:0] == i) begin         //Mem2Res2 == iAddr
                    oResult[i*8+:8] = iMemWrRes1[7:0];   //Mem2Res1 == iWrData
                    oMask[i*8+:8]   = {8{1'b0}};
                  end else begin
                    oResult[i*8+:8] = DcacheLineNewData[i*8+:8];
                    oMask[i*8+:8]   = {8{1'b1}};
                  end
                end

      ShEn :  for(int i=0;i<2;i=i+1) begin
                  if(iMemWrRes2[1] == i) begin
                    oResult[i*16+:16] = iMemWrRes1[15:0];
                    oMask[i*16+:16]   = {16{1'b0}};
                  end else begin
                    oResult[i*16+:16] = DcacheLineNewData[i*16+:16];
                    oMask[i*16+:16]   = {16{1'b1}};
                  end
                end

      SwEn :  begin
                oResult = iMemWrRes1[31:0];
                oMask   = {32{1'b0}};
              end

      default : begin
                  oResult = '0;
                  oMask   = '1;                  
                end
    endcase
  end
  
  assign {oMemWrdata,oMemWrmask} = {oResult,oMask};

  assign oMemWrEn = MemWrEn;
  // //the address is cacheline address
  // assign oMemWraddr = iMemWrRes2[(CACHE_WIDTHE-3)+:CACHE_DEEPTHE];

endmodule: MemWr
