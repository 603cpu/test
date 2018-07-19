module SramWrap 
#(
  parameter BITS   = 32 ,
  WORDS  = 36 ,
  ADRESS_WIDTH = 5,
  FILE = "file.sv"
)(//input
  clk,
  adress,
  cen,
  wen,
  din,
  mask,
  //output
  dout
);
  
  input       clk;
  input       cen;
  input       wen;
  input   [ADRESS_WIDTH - 1 : 0]  adress; 
  input   [BITS - 1 : 0]       din;
  input   [BITS - 1 : 0]       mask;
  
  output  [BITS - 1 : 0]       dout;
  wire [31:0]  web = wen ? mask : '1;

  SHPA110_1024X1X32BM1 U_SHPA110_1024X1X32BM1(
    .A0(adress[0]),.A1(adress[1]),.A2(adress[2]),.A3(adress[3]),.A4(adress[4]),
    .A5(adress[5]),.A6(adress[6]),.A7(adress[7]),.A8(adress[8]),.A9(adress[9]),
    .DO0(dout[0]),.DO1(dout[1]),.DO2(dout[2]),.DO3(dout[3]),.DO4(dout[4]),
    .DO5(dout[5]),.DO6(dout[6]),.DO7(dout[7]),.DO8(dout[8]),.DO9(dout[9]),
    .DO10(dout[10]),.DO11(dout[11]),.DO12(dout[12]),.DO13(dout[13]),.DO14(dout[14]),
    .DO15(dout[0]),.DO16(dout[16]),.DO17(dout[17]),.DO18(dout[18]),
    .DO19(dout[19]),.DO20(dout[20]),.DO21(dout[21]),.DO22(dout[22]),
    .DO23(dout[23]),.DO24(dout[24]),.DO25(dout[25]),.DO26(dout[26]),
    .DO27(dout[27]),.DO28(dout[28]),.DO29(dout[29]),.DO30(dout[30]),
    .DO31(dout[31]),.DI0(din[0]),.DI1(din[1]),.DI2(din[2]),.DI3(din[3]),
    .DI4(din[4]),.DI5(din[5]),.DI6(din[6]),.DI7(din[7]),.DI8(din[8]),
    .DI9(din[9]),.DI10(din[10]),.DI11(din[11]),.DI12(din[12]),.DI13(din[13]),
    .DI14(din[14]),.DI15(din[15]),.DI16(din[16]),.DI17(din[17]),
    .DI18(din[18]),.DI19(din[19]),.DI20(din[20]),.DI21(din[21]),
    .DI22(din[22]),.DI23(din[23]),.DI24(din[24]),.DI25(din[25]),
    .DI26(din[26]),.DI27(din[27]),.DI28(din[28]),.DI29(din[29]),.DI30(din[30]),.DI31(din[31]),
    .CK(clk),.WEB0(web[0]),.WEB1(web[1]),.WEB2(web[2]),.WEB3(web[3]),
    .WEB4(web[4]),.WEB5(web[5]),.WEB6(web[6]),.WEB7(web[7]),.WEB8(web[8]),.WEB9(web[9]),
    .WEB10(web[10]),.WEB11(web[11]),.WEB12(web[12]),.WEB13(web[13]),
    .WEB14(web[14]),.WEB15(web[15]),.WEB16(web[16]),
    .WEB17(web[17]),.WEB18(web[18]),.WEB19(web[19]),.WEB20(web[20]),
    .WEB21(web[21]),.WEB22(web[22]),.WEB23(web[23]),
    .WEB24(web[24]),.WEB25(web[25]),.WEB26(web[26]),.WEB27(web[27]),
    .WEB28(web[28]),.WEB29(web[29]),.WEB30(web[30]),
    .WEB31(web[31]),.OE(1'b0),.CS(~cen)
    );

endmodule

