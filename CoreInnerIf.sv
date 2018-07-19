
import ZionDataType::*;
interface FeIfs;
  CpuType Pc;
  CpuType PcAdd4;
  CpuIns Ins;
 
  modport Fe (output Pc,output PcAdd4 );
  modport ICache(output Ins);
  modport Ex (input  Pc);
  modport OrCell (input PcAdd4);
  modport InsDispatch(input  Ins);
  modport AutoSim(input  Pc,input  Ins);
  //modport Wb  (input PcAdd4);
endinterface : FeIfs


interface De1Ifs;
  logic WbEn;
  logic Rs1En,Rs2En; // Reg read enable
  logic S1Sign,S2Sign;
  logic IimmSEn,IimmUEn;
  
  logic IntEn,MultDivEn,MemEn,BJEn;
  
  modport De1(
              output Rs1En,output Rs2En,
              output S1Sign,output S2Sign,
              output IntEn,output MultDivEn,output MemEn,output BJEn,
              output IimmSEn,output IimmUEn,
              //output JumpEn, //for Pc+4
              
              output WbEn);

  modport Sof(input Rs1En,input Rs2En,
              input S1Sign,input S2Sign,
              input IimmSEn,input IimmUEn,
              input WbEn);

  modport OrCell(input IntEn,input MultDivEn,input MemEn,input BJEn);

  //modport Mem1(input MemEn);//for cen

  modport AutoSim(input WbEn);
  //modport Wb(input JumpEn);

  modport phasectrl(input WbEn,input IntEn,input MultDivEn,input MemEn,input BJEn,
                    input Rs1En,input Rs2En
                    );
endinterface: De1Ifs
 

interface De2Ifs;
  logic AddEn,MultEn,DivEn,BitEn,ShiftEn;
  logic StoreEn;

  modport De2(output AddEn,output MultEn,output DivEn,output BitEn,output ShiftEn,output StoreEn);
  modport OrCell(input AddEn,input MultEn,input DivEn,input BitEn,input ShiftEn);
  modport phasectrl(input AddEn,input MultEn,input DivEn,input BitEn,input ShiftEn,input StoreEn);
endinterface: De2Ifs


interface ExIfs;
  CpuType DeS1;
  CpuType DeS2;
  logic   DeS1Sign;
  logic   DeS2Sign;
  logic   UimmEn,SBimmEn,ShamtEn,UJimmEn;
  logic   AddOpEn;      //for AuiPc and Lui,normal Add
  logic [4:0] BitOpEn;  //for "& | ^ - slt"
  logic [2:0] ShiftOpEn;//for "<< >> >>>"
  logic [4:0] BjOpEn;   //for "Blt BGE BEQ BNE jump"
  logic [4:0] MemOpEn;  //for load and store:LS W H B Sign
  logic [1:0] MultOpEn,DivOpEn;

  modport Ex( input DeS1, input DeS2,
              input DeS1Sign,input DeS2Sign,
              input UimmEn,input SBimmEn,input ShamtEn,UJimmEn,
              input AddOpEn,input BitOpEn,input ShiftOpEn,
              input MultOpEn,input DivOpEn,input MemOpEn,input BjOpEn
             );

  modport Rd(input MemOpEn);

  modport De1(output UimmEn,output SBimmEn,output ShamtEn,output UJimmEn);

  modport Sof(output DeS1Sign,output DeS2Sign,output DeS1,output DeS2);

  modport De2(output AddOpEn,output BitOpEn,output ShiftOpEn,output MultOpEn,
              output DivOpEn,output MemOpEn,output BjOpEn);
endinterface:ExIfs

// interface ExMem1Ifs;
//   CpuType MemAddr;

//   modport Ex (output MemAddr);
//   modport Mem1 (input MemAddr);

// endinterface: ExMem1Ifs
/////////////////////////
interface Mem1Mem2Ifs;
  //CpuType MemAddr;
  CpuType MemRdData;

  modport Mem1 (output MemRdData);
  modport Mem2 (input MemRdData);

endinterface: Mem1Mem2Ifs


interface OrCellWbIfs;
  CpuType OrCellWbData;

  modport OrCell(output OrCellWbData);
  modport Wb(input OrCellWbData);
endinterface
////////////////////////
interface BjBusIfs;

  logic   ExBjEn,FeBjEn;
  CpuType BjPc;
  modport Ex  (output BjPc, output ExBjEn);
  modport Fe  (input  BjPc, input  FeBjEn);
 
endinterface: BjBusIfs
/////////////////////////////////////


interface DcacheInputIfs
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 12
);

  //logic cen;
  logic WrEn;
  logic [CACHE_DEEPTHE-1:0] Addr;
  logic [2**CACHE_WIDTHE-1:0] WrMask;
  logic [2**CACHE_WIDTHE-1:0] WrData;
  modport Ex( output WrEn, output Addr, output WrMask, output WrData);
  modport Mem1 (input WrEn, input Addr, input WrMask, input WrData);

endinterface: DcacheInputIfs

interface ICacheIfs
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 12
);
  logic [CACHE_DEEPTHE-1   : 0] InsAddr;
  logic [2**CACHE_WIDTHE-1 : 0] InsData;
  modport Core(output InsAddr,input InsData);
endinterface

// interface DCacheIfs
// #(parameter
//   CACHE_WIDTHE = 5,
//   CACHE_DEEPTHE = 12
// );
//   logic [2**CACHE_WIDTHE-1:0] MemData;
//   logic Cen;
//   logic WrEn;
//   logic [CACHE_DEEPTHE-1:0] Addr;
//   logic [2**CACHE_WIDTHE-1:0] WrData;
//   logic [2**CACHE_WIDTHE-1:0] WrMask;
//   modport Core(input MemData,output Cen,output WrEn,
//                output Addr,output WrData,output WrMask
//                );
// endinterface

// interface RfWbBusIfs;
//   //logic   WrEn;
//   RfDest  addr;
//   CpuType data;
//   modport Wb (output WrEn,output addr,  output data);
//   modport Sof  (/*input WrEn,input addr, */ input data);

// endinterface: RfWbBusIfs