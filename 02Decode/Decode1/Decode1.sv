import ZionDataType::*;
module Decode1
(
	InsBitDispatchIfl.De1 iIns,
	De1Ifs.De1 oDe1Data,
	ExIfs.De1  De1ExData,
	output logic MemEn
	);


	/////////////////////////for  De1Ifs
	
	//Rs1En,Rs2En
	assign oDe1Data.Rs1En = !(iIns.op[2] & (iIns.op[3] | iIns.op[4]));
	assign oDe1Data.Rs2En = iIns.op[5] & !iIns.op[2];
  
	//AddEn
	// wire temp  = iIns.funct3 == 3'b000;
	// wire AddEn = AllInt & (iIns.op[2] | temp & (!iIns.op[5] | (iIns.op[5] & !iIns.funct7[5])));
	// assign oDe1Data.AddEn = AddEn;

	//int decode include normal add,bit op,shift op
	
	//mludiv decode
	wire MultDivEn = (iIns.op[5:2] == 4'b1100) & iIns.funct7[0];
	assign oDe1Data. MultDivEn = (iIns.op[5:2] == 4'b1100) & iIns.funct7[0];
	//mem decode
	assign MemEn = !iIns.op[6] & (iIns.op[4:2]==3'b000) & iIns.op[0];
	assign oDe1Data. MemEn = MemEn;
	//bj decode
	wire BJEn = iIns.op[6:5] == 2'b11;
	assign oDe1Data. BJEn = BJEn;
	//Int
	wire IntEn = iIns.op[4] & !MultDivEn;
	assign oDe1Data.IntEn = IntEn;

	//WbEn
	wire WbEn = (iIns.op[2] | iIns.op[4] | MemEn & !iIns.op[5]) & (iIns.rd != 0);
	assign oDe1Data.WbEn = WbEn;

	//S1Sign,S2Sign 
	wire IntS1UnSign = IntEn & (iIns.funct3==3'b011);
	wire BjS1UnSign = BJEn & iIns.funct3[1];
	wire MulDivS1UnSign = MultDivEn & ((iIns.funct3[1:0]==2'b11) | ({iIns.funct3[2],iIns.funct3[0]}==2'b11));
	wire S1Sign = !( IntS1UnSign | BjS1UnSign | MulDivS1UnSign);
	assign oDe1Data.S1Sign = S1Sign;

	wire MulDivS2Sign = (~iIns.funct3[2] & ~iIns.funct3[1]) | (iIns.funct3[2] & ~iIns.funct3[0]);
	assign oDe1Data.S2Sign = MulDivS2Sign & MultDivEn | S1Sign & !MultDivEn;

	//ImmEn to Sof

	wire IimmUEn = IntS1UnSign & !iIns.op[5];
	assign oDe1Data.IimmUEn = IimmUEn;
	
	wire MemIimmSEn  =  MemEn & !iIns.op[5];
	wire JalrIimmSEn = iIns.op[4:2]==3'b001;
	wire IntIimmSEn  = IntEn & !iIns.op[5] & !iIns.op[2] & !(iIns.funct3[1:0] == 2'b01) & !IimmUEn;

	assign oDe1Data.IimmSEn = MemIimmSEn | JalrIimmSEn | IntIimmSEn;
	//////////////////////for  ExIfs
	assign De1ExData.UimmEn  = iIns.op[2];
	assign De1ExData.UJimmEn = iIns.op[3];
	assign De1ExData.SBimmEn = !iIns.op[2];
	assign De1ExData.ShamtEn = !iIns.op[5];

	//assign De1ExData.AddOpEn = !iIns.op[5] & iIns.op[2];//AuiPc 

endmodule