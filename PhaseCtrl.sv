  
module PhaseCtrl
( 
  input ClkMax,
  SysIf.in SIf,
  De1Ifs.phasectrl iDe1,
  De2Ifs.phasectrl iDe2,

  output logic clkFe,
  output logic clkMem,

  output logic  CtrlRf,
  output logic [3:0] CtrlDe2,
  output logic [6:0] CtrlEx,
  output logic  CtrlMemRd,
  output logic  CtrlWb,
  //iso
  // output logic RfIso,
  // output logic [3:0] De2Iso,
  output logic ExIso,
  // output logic MemRdIso,
  output logic WbIso
);
  logic [1:0] State,NextState;

  parameter Fe = 2'b00,De2   = 2'b01,
            Ex = 2'b11,MemRd = 2'b10;

  // logic ClkPos;          
  // always@ (posedge SIf.clk or negedge SIf.rstn) begin
  //  if(~SIf.rstn )
  //    ClkPos <= 1'b0; 
  //  else
  //    ClkPos <= ClkMax;
  // end
  
  
  //always@ (posedge SIf.clk or negedge SIf.rstn) begin
  //  if(~SIf.rstn && ~ClkMax)
  //    ClkPos <= 1'b0; 
  //  else if(ClkMax)
  //    ClkPos <= 1'b1;
  //end
 
  

  logic clk;
  wire E = !((State ==Fe)&(NextState ==Fe));
  CKLNQD1 U_CKLH(
                .TE (1'b0),
                .CP(SIf.clk),
                .E  (E),
                .Q  (clk)
  );
  // CKAN2D1 U_CKAND(
  //                 .A1(E),
  //                 .A2(SIf.clk),
  //                 .Z (clk)
  //   );
  //wire clk = E & SIf.clk;
  always_ff @(posedge clk or negedge SIf.rstn)
    if (!SIf.rstn)
      State <= Fe;
    else 
      State <= NextState;

  logic LoadEn;
  assign LoadEn = iDe1.MemEn & !iDe2.StoreEn;

  always_comb
    case(State)
      Fe: 
        if (ClkMax)
          NextState = De2;
        else
          NextState = Fe;
      De2:
        NextState = Ex;
      Ex:
        if (LoadEn)
          NextState = MemRd;
        else 
          NextState = Fe;
      MemRd:
        NextState = Fe;
      default:
        NextState = Fe;
    endcase 

  always_comb
    if (!SIf.rstn) begin
      clkFe  = 0;
      clkMem = 0;
    end else begin 
      clkFe  = !State[1]  ;
      clkMem = !State[0]  ;
    end

  // always_ff @(posedge SIf.clk or negedge SIf.rstn)
  //   if (!SIf.rstn) begin
  //     clkFe  <= 0;
  //     clkMem <= 0;
  //     //clkWb  <= 0;
  //   end else begin 
  //     clkFe  <= (State == Ex) & (!LoadEn) | (State == MemRd)  ;
  //     clkMem <= (State == Ex) & iDe1.MemEn;
  //     //clkWb  <= (State == Ex) & (!LoadEn) | (State == MemRd);
  //   end
  

  logic De2En,ExEn;
  always_comb
    case(State)
      Fe:
        begin
          CtrlRf  <= 0;CtrlWb <= 0;
          ExEn <= 0;CtrlMemRd <= 0;
          De2En <= 0 ;
        end
      De2:
        begin
          CtrlRf <= iDe1.Rs2En;
          De2En <= 1;ExEn <= 0;CtrlMemRd <= 0;
          CtrlWb <= 0;
          
        end
      Ex:
      begin

        CtrlMemRd <= 0;De2En <= 1;ExEn <= 1;CtrlRf <= iDe1.Rs2En;
        
        if(!iDe1.MemEn)
            CtrlWb <= 1;
        else
            CtrlWb <= 0;
      end
      MemRd: 
        begin
          CtrlMemRd <= 1;De2En <= 1;ExEn <= 1;CtrlWb <= 1;CtrlRf <= 0;
        end
      default:
        begin
          CtrlRf <= 0; CtrlWb <= 0; 
          De2En <= 0;ExEn <= 0;CtrlMemRd <= 0;
        end
    endcase 

  //wire De2En = (State >= De2);
  assign CtrlDe2[0] = De2En & iDe1.IntEn ;
  assign CtrlDe2[1] = De2En & iDe1.MultDivEn ;
  assign CtrlDe2[2] = De2En & iDe1.MemEn;
  assign CtrlDe2[3] = De2En & iDe1.BJEn;

  //wire ExEn = (State >= Ex) ;
  assign CtrlEx[5] = ExEn & iDe1.MemEn ;
  assign CtrlEx[6] = ExEn & iDe1.BJEn ;
  
  assign CtrlEx[0] = ExEn & iDe2.BitEn  & iDe1.IntEn ;
  assign CtrlEx[1] = ExEn & iDe2.ShiftEn  & iDe1.IntEn ;
  assign CtrlEx[2] = ExEn & iDe2.MultEn & iDe1.MultDivEn ;
  assign CtrlEx[3] = ExEn & iDe2.DivEn & iDe1.MultDivEn;
  assign CtrlEx[4] = ExEn & iDe2.AddEn & iDe1.IntEn ;
  

  // assign RfIso = ~CtrlRf;
  // assign De2Iso = ~CtrlDe2;
  assign ExIso = ~CtrlEx[6];
  // assign MemRdIso = ~CtrlMemRd;
  assign WbIso = ~CtrlWb;
  
endmodule: PhaseCtrl
