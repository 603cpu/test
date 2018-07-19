module Decode2(
	InsBitDispatchIfl.De2 iIns,
	De2Ifs.De2 oDe2,
	ExIfs.De2 De2ExData
	);

	
	BJOpDecode U_BJOpDecode(
													.iIns(iIns),
													//.oDe2(oDe2),
													.De2ExData(De2ExData)
													);
	IntOpDecode U_IntOpDecode(
													.iIns(iIns),
													.oDe2(oDe2),
													.De2ExData(De2ExData)
						  						);
	MemOpDecode U_MemOpDecode(
													.iIns(iIns),
													.oDe2(oDe2),
													.De2ExData(De2ExData)
													);
	MultDivOpDecode U_MultDivOpDecode(
													.iIns(iIns),
													.oDe2(oDe2),
													.De2ExData(De2ExData)
						  		  			);

endmodule