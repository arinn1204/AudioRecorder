`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:10 12/07/2014 
// Design Name: 
// Module Name:    WriteMemory 
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
module WriteMemory(
   input Clock,
	input Reset,
	input Enable,
	input [11:0] DataIn,
	input [22:0] Count,
	
	inout [15:0] RamData,
	
	output [22:0] Address,
	output ChipEnable,
	output OutputEnable,
	output WriteEnable,
	output UpperByte,
	output LowerByte,
	output AddressValid
    );
	 
	 reg [3:0] nState, pState;
	 reg [22:0] Counter;
	 localparam S0 = 'b0, S1 = 'd1, S2 = 'd2, S3 = 'd3, S4 = 'd4, S5 = 'd5, S6 = 'd6, S7= 'd7, S8 = 'd8;
	 
	 initial begin
		nState = S0;
		pState = S0;
		Counter = 23'b0;
	 end
	 
	 
	 always @ (pState, Enable)
		begin
			case (pState)
				S0:
					begin
						if (Enable)
							nState = S1;
						else
							nState = S0;
					end
				S1:
					begin
						nState = S2;
					end
				S2:
					begin
						nState = S3;
					end
				S3:	
					begin
						nState = S4;
					end
				S4:
					begin
						nState = S5;
					end
				S5:
					begin
						nState = S6;
					end
				S6:
					begin
						nState = S7;
					end
				S7:
					begin
						nState = S8;
					end
				S8:
					begin
						nState = S0;
					end
			default:
				nState = Rest;
			endcase
		end




endmodule
