`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:54:03 09/17/2014 
// Design Name: 
// Module Name:    DeBouncer 
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
module DeBouncer(
    input Clock,
    input Reset,
    input DataIn,
    output DataOut
    );

reg [1:0] pState, nState;

localparam I0 = 2'b00;
localparam I1 = 2'b01;
localparam I3 = 2'b11;

always @ (DataIn, pState)
begin
	case (pState)
		I0:
			begin
				if(DataIn == 1'b1)
					nState = I1;
				else
					nState = I0;
			end
		I1:
			begin
				if(DataIn == 1'b1)
					nState = I3;
				else
					nState = I0;
			end
		I3:
			begin
				if(DataIn == 1'b1)
					nState = I3;
				else
					nState = I0;
			end
		default:
			nState = I0;
	endcase
end

always @ (posedge Clock, posedge Reset)
begin
	pState <= (Reset == 1'b1) ? I0 : nState;
end

assign DataOut = (pState == I3) ? 1'b1 : 1'b0;

endmodule
