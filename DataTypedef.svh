
package ZionDataType;
  import BasicParam::*;
  //export BasicParam::*;
  typedef logic [31:0] CpuType;
  typedef logic [31:0] CpuIns;
  typedef logic [ 4:0] RfDest;
  typedef logic [ 4:0] RfRs;

  typedef enum logic [2:0] {
    NonUnit0    = 3'd0,
    IntUnit1    = 3'd1,
    MemUnit2    = 3'd2,
    MulDivUnit3 = 3'd3
  }ZionUnit;
  typedef logic [4:0] ZionOp;
  typedef logic [3:0] ZionMop;

  //here is the typedef data
  //these encodings are used to indicate the source of the s1,s2
  typedef enum logic [1:0] {
    Non = 2'b00,
    Imm = 2'b01,
    Int = 2'b10,
    Flt = 2'b11
  } OpSource;

  //function automatic int ZION_INS_BYTESE(input int NONE=0);
  function automatic int ZION_INS_BYTESE();
    return BITS_BYTESE($bits(CpuIns));
  endfunction

  //function automatic int ZION_CPU_BYTESE(input int NONE=0);
  function automatic int ZION_CPU_BYTESE();
    return BITS_BYTESE($bits(CpuType));
  endfunction

endpackage: ZionDataType
