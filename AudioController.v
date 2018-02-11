`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:03 12/03/2014 
// Design Name: 
// Module Name:    AudioController 
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
module AudioController(
    input Clock,
    input Reset,
    input Play,
	 input Record,
	 input Stop,
	 input MemoryFull,
	 input StopReading,
    output StartPlay,
    output StartRecord,
	 output StopPlaying
    );
	 
	 
	 reg [1:0] nState, pState;
	 //reg MemFull, StopReading;
	 
	 
	 localparam Idle = 2'b00, PlayRecorded = 2'b01, StartRecording = 2'b10;
	 
	 always @ (pState, Play, Record, Stop, StopReading, MemoryFull)
	 begin
		case (pState)
			Idle:
				begin
					if (Play)
						nState = PlayRecorded;
					else if (Record)
						nState = StartRecording;
					else
						nState = Idle;
				end
			PlayRecorded:
				begin
					if (Stop || StopReading)
						nState = Idle;
					else
						nState = PlayRecorded;
				end
			StartRecording:
				begin
					if (Stop || MemoryFull)
						nState = Idle;
					else
						nState = StartRecording;
				end
			default:
				nState = Idle;
		endcase
	 end

	always @ (posedge Clock, negedge Reset)
		pState <= (~Reset) ? Idle : nState;

	assign StartPlay = (pState == PlayRecorded) ? 1'b1 : 1'b0;
	assign StartRecord = (pState == StartRecording) ? 1'b1 : 1'b0;
	assign StopPlaying = (pState == Idle) ? 1'b1 : 1'b0;
	


endmodule
