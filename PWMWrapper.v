`timescale 1ns / 1ps
module PWMWrapper(
    input Clock,
    input btnCpuReset,
    input [PWMSIZE-1:0] Switch,
	 output EnableOut,
	 output reg JA
    );
	 
	 parameter PWMSIZE = 8;
	 localparam COUNTERLIMIT = 2**PWMSIZE;
	 
	 wire Reset = ~btnCpuReset;
	 reg  [PWMSIZE-1:0] Counter = 'b0;
	 
	 
	 always @ (posedge Clock)
	 begin
		if (Reset)
			Counter <= 'b0;
		else if(Counter == COUNTERLIMIT-1)
			Counter <= 'b0;
		else
			Counter <= Counter + 1'b1;
	 end
	 
	 assign EnableOut = (Counter == COUNTERLIMIT - 1) ? 1'b1 : 1'b0;
	 
	 always @ (Switch, Counter)
	 begin
		if(Switch > Counter)
			JA = 1'b1;
		else
			JA = 1'b0;
	 end
	 
		 
endmodule
