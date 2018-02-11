`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:28:49 12/09/2014
// Design Name:   MemoryController
// Module Name:   C:/Users/Aaron/Dropbox/EE324/AudioRecorder/RamController.v
// Project Name:  AudioRecorder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MemoryController
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RamController;

	// Inputs
	reg Clock;
	reg Reset;
	reg ReadEnable;
	reg WriteEnable;
	reg [INCOMINGDATA - 1:0] DataIn;

	// Outputs
	wire [OUTGOINGDATA - 1:0] DataOut;
	wire [22:0] MemAdr;
	wire RamOEn;
	wire RamWEn;
	wire RamADVn;
	wire RamCEn;
	wire RamUBn;
	wire RamLBn;
	wire RamCRE;
	wire StopReading;
	wire MemFull;

	// Bidirs
	wire [15:0] MemDB;
	
	parameter INCOMINGDATA = 12;
	parameter OUTGOINGDATA = 12;

	// Instantiate the Unit Under Test (UUT)
	MemoryController #(INCOMINGDATA,OUTGOINGDATA) MyRam (
		.Clock(Clock), 
		.Reset(Reset), 
		.ReadEnable(ReadEnable), 
		.WriteEnable(WriteEnable),  
		.DataIn(DataIn), 
		.MemDB(MemDB), 
		.DataOut(DataOut), 
		.MemAdr(MemAdr), 
		.RamOEn(RamOEn), 
		.RamWEn(RamWEn),
		.RamADVn(RamADVn), 
		.RamCEn(RamCEn), 
		.RamUBn(RamUBn), 
		.RamLBn(RamLBn), 
		.RamCRE(RamCRE),
		.StopRead(StopReading),
		.MemoryFull(MemFull)
	);
	
	cellram MicronSim (
        .clk    (1'b0),
        .adv_n  (RamADVn),
        .cre    (RamCRE),
        .o_wait (),
        .ce_n   (RamCEn),
        .oe_n   (RamOEn),
        .we_n   (RamWEn),
        .ub_n   (RamUBn),
        .lb_n   (RamLBn),
        .addr   (MemAdr),
        .dq     (MemDB)
    );
	
	always
		#5 Clock = ~Clock;

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		ReadEnable = 0;
		WriteEnable = 0;
		DataIn = 0;

		#100;
		Reset = 1;
		DataIn = 2050;
		#150000
		// Wait 100 ns for global reset to finish
		
		
		#5 WriteEnable = 1;
		
		#100 DataIn = 3214;
		
		#100 DataIn = 5312;
		
      
		#90 WriteEnable = 0;
		// Add stimulus here
		
		#100 ReadEnable = 1;
		
		#500 ReadEnable = 0;
		#300 $finish;

	end
      
endmodule

