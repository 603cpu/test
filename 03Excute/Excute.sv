//Ex0 includes & ^ | - slt
//Ex1 includes >> << >>>
//Ex2 includes mul
//Ex3 includes div
//Ex4 includes auipc lui +
//Ex5 includes memory access
//Ex6 includes branch
import ZionDataType::*;

module Excute
#(parameter
  CACHE_WIDTHE = 5,
  CACHE_DEEPTHE = 12
)(
  ExIfs.Ex iExData,
  InsBitDispatchIfl.Ex iIns,
  FeIfs.Ex iFe,
  ExResSelectIfs.Ex oEx,

  DcacheInputIfs.Ex oDcacheBus,
  //ExMem1Ifs.Ex oExMem1Data,
  output logic [11:0] Addr,
  output [1:0] MemAddr,
  BjBusIfs.Ex oBjBus
  
 
);
  
  Ex0 U_BitUnit(
            .iExData(iExData),
            //.oResult(oEx.ExResult0)
            .oResult(oEx.ExResult[0])
            );
  
  Ex1 U_ShiftUnit(
            .iExData(iExData),
            .iIns(iIns),
            //.oResult(oEx.ExResult1)
            .oResult(oEx.ExResult[1])
            );  

  Ex2 U_MultUnit(
                .iExData(iExData),
                //.oResult(oEx.ExResult2)
               .oResult(oEx.ExResult[2])
                );
  Ex3 U_DivUnit(
  				      .iExData(iExData),
  				      //.oResult(oEx.ExResult3)
                .oResult(oEx.ExResult[3])
                );
  Ex4 U_AddUnit(
  		    	.iExData(iExData),
            .iIns(iIns),
            .iFe(iFe),
  			    //.oResult(oEx.ExResult4)
            .oResult(oEx.ExResult[4])
            );
 
  Ex5 #(.CACHE_WIDTHE(CACHE_WIDTHE),
        .CACHE_DEEPTHE(CACHE_DEEPTHE))
          U_MemUnit(
            .iExData(iExData),
            .iIns(iIns),
            .oDcacheBus(oDcacheBus),
            .Addr(Addr),
            .MemAddr(MemAddr)
            //.oExData(oExMem1Data)
          );
 
  Ex6 U_BjUnit(
  		    	.iExData(iExData),
            .iIns(iIns),
            .iFe(iFe),
            .oBjBus(oBjBus)
            //.oResult(oEx.ExResult6)
            //.oResult(oEx.ExResult[6])
            );

endmodule