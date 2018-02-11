`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:49:19 12/12/2014
// Design Name:   AudioRecorder
// Module Name:   C:/Users/Aaron/Dropbox/EE324/AudioRecorder/TotalSim.v
// Project Name:  AudioRecorder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AudioRecorder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TotalSim;

	// Inputs
	reg SystemClock;
	reg btnCpuReset;
	reg MISO;
	reg Play;
	reg Stop;
	reg Record;

	// Outputs
	wire [22:0] MemAdr;
	wire RamOEn;
	wire RamWEn;
	wire RamCLK;
	wire RamADVn;
	wire RamCEn;
	wire RamUBn;
	wire RamLBn;
	wire RamCRE;
	wire ampPWM;
	wire ampSD;
	wire nSS;
	wire sCLK;
	wire RedR;
	wire GreenR;
	wire Idle;

	// Bidirs
	wire [15:0] MemDB;

	// Instantiate the Unit Under Test (UUT)
	AudioRecorder TotalSim (
		.SystemClock(SystemClock), 
		.btnCpuReset(btnCpuReset), 
		.MISO(MISO), 
		.Play(Play), 
		.Stop(Stop), 
		.Record(Record), 
		.MemDB(MemDB), 
		.MemAdr(MemAdr), 
		.RamOEn(RamOEn), 
		.RamWEn(RamWEn), 
		.RamCLK(RamCLK), 
		.RamADVn(RamADVn), 
		.RamCEn(RamCEn), 
		.RamUBn(RamUBn), 
		.RamLBn(RamLBn), 
		.RamCRE(RamCRE), 
		.ampPWM(ampPWM), 
		.ampSD(ampSD), 
		.nSS(nSS), 
		.sCLK(sCLK), 
		.RedR(RedR), 
		.GreenR(GreenR), 
		.Idle(Idle)
	);
	
	    cellram CellRAM (
        .clk    (RamCLK),
        .adv_n  (RamADVn),
        .cre    (RamCRE),
        .o_wait (o_wait),
        .ce_n   (RamCEn),
        .oe_n   (RamOEn),
        .we_n   (RamWEn),
        .ub_n   (RamUBn),
        .lb_n   (RamLBn),
        .addr   (MemAdr),
        .dq     (MemDB)
    );
	
	localparam Data1 = 16'b1110101100100010;
	localparam Data2 = 16'b1101010101010101;
	localparam Data3 = 16'b1010101011100011;
	integer i;
	
	
	always
		#5 SystemClock = ~SystemClock;

	initial begin
		// Initialize Inputs
		SystemClock = 0;
		btnCpuReset = 0;
		MISO = 0;
		Play = 0;
		Stop = 0;
		Record = 0;
		#150000;
		// Wait 100 ns for global reset to finish
		#100 btnCpuReset = 1;
		Record = 1;
		#4000 Record = 0;
	
//	while(1) begin
		for (i=15;i>=0;i=i-1)
			#400 MISO = Data1[i];
			
		for (i=15;i>=0;i=i-1)
			#400 MISO = Data2[i];
			
		for (i=15;i>=0;i=i-1)
			#400 MISO = Data3[i];
//		end
			
		#100000 Stop = 1;
		#10000 Stop = 0;
		
		#100000 Play = 1;
		#10000 Play = 0;
		//#10000 $finish;
        
		// Add stimulus here

	end
      
endmodule

