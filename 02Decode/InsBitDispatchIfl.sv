//This is Instruction dispatch interface
//which dispatch the instruction and serves as decode module input port
import ZionDataType::*;
interface InsBitDispatchIfl;

  logic [ 6:0] funct7;
  logic [ 3:0] rs2;
  logic [ 3:0] rs1;
  logic [ 2:0] funct3;
  logic [ 6:0] op;
  logic [ 4:0] shamt;//for immediate shift:SLLI  SRLI  SRAI
  CpuType Uimm;
  CpuType UJimm;
  CpuType Simm;
  CpuType SBimm;
  CpuType IimmU;
  CpuType IimmS;
  RfDest  rd;
  
  modport De1(input op, input funct3, input funct7,input rd);
  modport De2(input op, input funct3, input funct7);
  modport Sof(input IimmU, input IimmS, input rs1, input rs2,input rd);
  modport Ex (input shamt, input Uimm, input UJimm, input Simm, input SBimm);
  modport AutoSim(input rd);
 // modport Wb (input rd);
  modport out(
              output op,    output funct7, output funct3,
              output rs2,   output rs1,    output rd,
              output shamt, output Uimm,   output UJimm,
              output Simm,  output SBimm,  output IimmU, output IimmS
            ); 
endinterface: InsBitDispatchIfl
