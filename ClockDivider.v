`timescale 1ns / 1ps

module ClockDivider(
    input Clock,
    input Reset,
    output reg ClockDiv
    );
	 
	 parameter BUSSIZE = 12;
	 parameter LIMIT = 5000;
	
	
	 reg [BUSSIZE:0] Counter = 'b0;
	
	 always @ (posedge Clock, negedge Reset)
	 begin
		if(Reset == 1'b0)
			Counter <= 'b0;
		else if (Counter == LIMIT-1)
			Counter <= 'b0;
		else
			Counter <= Counter + 1'b1;
	 end
	 
	 always @ (posedge Clock, negedge Reset)
	 begin
		if(Reset == 1'b0)
			ClockDiv <= 1'b0;
		else if (Counter == LIMIT - 1)
			ClockDiv <= ~ClockDiv;
		else
			ClockDiv <= ClockDiv;
	 end


endmodule
