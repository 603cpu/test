
module OrCell#
(parameter 
  INPUTNUM = 7
)(
  input [INPUTNUM-1:0] In,
  input [INPUTNUM-1:0] En,
  output Out
);

`ifdef ZOR
  genvar i;
  generate
    for(i=0;i<7;i=i+1)begin
      Ass U_Ass(.in(In[i]),.En(En[i]),.out(Out));
    end
  endgenerate
`else 
  assign Out = |In;
`endif
endmodule

