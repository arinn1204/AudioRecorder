`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:10 12/09/2014 
// Design Name: 
// Module Name:    TriColorControl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TriColorControl(
    input Clock,
    input Reset,
	 input Enable,
    output [2:0] Led
    );
	 
	 initial begin
		PWMCount = 6'b0;
		ShiftLed = 0;
		Counter = 'b0;
		LedClock = 1'b0;
		LEDCounter = 3'b0;
	 end
	 
	 reg [5:0] PWMCount;
	 reg ShiftLed;


	always @ (posedge Clock, negedge Reset)
		begin
			if(~Reset)
				PWMCount <= 6'b0;
			else if (PWMCount == 6'b111111)
				PWMCount <= 6'b0;
			else
				PWMCount <= PWMCount + 1'b1;
		end

	always @ (posedge Clock, negedge Reset)
		begin
			if(~Reset)
				ShiftLed <= 1'b0;
			else if (PWMCount == 6'b101111)
				ShiftLed <= 1'b1;
			else
				ShiftLed <= 1'b0;
		end


	parameter LIMIT = 3571429;
	parameter BUSWIDTH = 21;
	
	
	reg [BUSWIDTH:0] Counter;
	reg LedClock;
	
	
	always @ (posedge Clock)
		begin
			if(Counter == LIMIT-1)
				Counter <= 'b0;
			else
				Counter <= Counter + 1'b1;
		end
	
	always @ (posedge Clock)
		begin
			if(Counter == LIMIT - 1)
				LedClock = 1'b0;
			else
				LedClock = ~LedClock;
		end
		
		
	reg [2:0] LEDCounter;
	always @ (posedge LedClock)
		begin
			if(~Reset)
				LEDCounter <= 3'b0;
			else if (ShiftLed && Enable)
				LEDCounter <= LEDCounter + 1'b1;
			else
				LEDCounter <= 3'b0;
		end

	assign Led = LEDCounter;



endmodule
