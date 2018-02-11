`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:00 12/07/2014 
// Design Name: 
// Module Name:    ReadMemory 
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
module ReadMemory(
	input Clock,
	input Reset,
	input Enable,
	input [22:0] Count,
	
	inout [15:0] Data,
	
	output [22:0] Address,
	output ChipEnable,
	output OutputEnable,
	output WriteEnable,
	output UpperByte,
	output LowerByte,
	output AddressValid,
	
	output [11:0] DataOut
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


assign ChipEnable = (pState == S0 || pState == S8) ? 1'b1 : 1'b0;
assign WriteEnable = 1'b1;
assign OutputEnable = (pState == S6) ? 1'b0 : 1'b1;
assign LowerByte = (pState >= S1 && pState < S8) ? 1'b0 : 1'b1;
assign UpperByte = (pState >= S1 && pState < S8) ? 1'b0 : 1'b1;
assign Address = Counter;
assign DataOut = (pState == S8) ? Data : 16'b0;


always @ (posedge Clock)
	pState <= (~Reset) ? S0 : nState;
	
	
always @ (posedge Clock)
	begin
		if(~Reset)
			Counter <= 23'b0;
		else if (pState == S8)
			Counter <= Counter + 1'b1;
		else
			Counter <= Counter;
	end



endmodule
