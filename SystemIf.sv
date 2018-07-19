
interface SysIf;
  logic clk;
  logic rstn;

  modport in(input clk,input rstn);
  modport ClockGen(output clk);
  modport RstGen(output rstn);
  
endinterface: SysIf
