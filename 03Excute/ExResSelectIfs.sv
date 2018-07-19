import ZionDataType::*;
interface ExResSelectIfs
#(
  INPUTNUM = 7,
  BITWIDTH = 32
  )(
  // input CpuType iMemRes,
  // DeExIfl.Ex iDeData,
  // ExWbIfl.Ex oExData
  //ExMem1Ifl.Ex oExMem1Data
);
//   CpuType ExResult0;
//   CpuType ExResult1;
//   CpuType ExResult2;
//   CpuType ExResult3;
//   CpuType ExResult4;
//   CpuType ExResult5;
//   CpuType ExResult6;



// modport MultiOrCellUnitIN(input ExResult0,input ExResult1,input ExResult2,input ExResult3,
// 													input ExResult4,input ExResult5,input ExResult6);
// modport Ex(output ExResult0,output ExResult1,output ExResult2,
// 					 output ExResult3,output ExResult4,output ExResult6);
// modport Mem2(output ExResult5);


  CpuType ExResult[INPUTNUM-1:0];
  

modport MultiOrCellUnitIN(input ExResult);
modport Ex(output ExResult);
modport Mem2(output ExResult);

endinterface :ExResSelectIfs
