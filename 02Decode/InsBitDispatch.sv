import ZionDataType::*;
module InsBitDispatch 
(
	InsBitDispatchIfl.out oIns,
	FeIfs.InsDispatch iFeData
	);

  CpuIns ins;
  assign ins = iFeData.Ins;
  assign {oIns.funct7, oIns.rs2  , oIns.rs1  , oIns.funct3, oIns.rd  , oIns.op }
        ={ins[31:25] , ins[23:20], ins[18:15], ins[14:12] , ins[11:7], ins[6:0]};
  //TBD: using unsigned()
  //Here, system function $signed and $unsigned which are used to sign extension
  assign oIns.shamt     = ins[24:20];
  assign oIns.Uimm      = $signed({ins[31:12],12'h000});
  assign oIns.UJimm     = $signed({ins[31],ins[19:12],ins[20],ins[30:21],1'b0});
  assign oIns.Simm      = $signed({ins[31:25],ins[11:7]});
  assign oIns.SBimm     = $signed({ins[31],ins[7],ins[30:25],ins[11:8],1'b0});
  assign oIns.IimmU     = $unsigned(ins[31:20]);
  assign oIns.IimmS     = $signed(ins[31:20]);

endmodule