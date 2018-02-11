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
    output StartPlay,
    output StartRecord
    );
	 
	 wire Play_T, Record_T, Stop_T;
	 
	 DeBouncer PlayBounce (
    .Clock(Clock), 
    .Reset(Reset), 
    .DataIn(Play), 
    .DataOut(Play_T)
    );
	 
	 DeBouncer RecordBounce (
    .Clock(Clock), 
    .Reset(Reset), 
    .DataIn(Record), 
    .DataOut(Record_T)
    );
	 
	 DeBouncer StopBounce (
    .Clock(Clock), 
    .Reset(Reset), 
    .DataIn(Stop), 
    .DataOut(Stop_T)
    );
	 
	 
	 







endmodule
