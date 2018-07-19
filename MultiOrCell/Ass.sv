module Ass(input in,
			input  En,
			output out);
assign out = (En) ? in : 1'bz;
endmodule