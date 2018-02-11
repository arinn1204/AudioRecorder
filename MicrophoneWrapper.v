`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:45:35 11/15/2014 
// Design Name: 
// Module Name:    AudioRecorder 
// Project Name:   Audio Recorder
// Target Devices: Digilent Nexys 4, Digilent Pmod Microphone
// Tool versions: Xilinx ISE 2013
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AudioRecorder(
	/**************************************
							INPUTS
	**************************************/
    input SystemClock,
    input btnCpuReset,
	 input MISO,
	 input Play,
	 input Stop,
	 input Record,
	 
	 /**************************************
							INOUTS
	**************************************/
	
	 inout [15:0] MemDB,
	 
	 /**************************************
							OUTPUTS
	**************************************/
	
	 output [22:0] MemAdr,
	 output RamOEn,
	 output RamWEn,
	 output RamCLK,
	 output RamADVn,
	 output RamCEn,
	 output RamUBn,
	 output RamLBn,
	 output RamCRE,
    output ampPWM,
    output ampSD,
	 output nSS,
	 output sCLK,
	 
	 output RedR,
	 output GreenR,
	 output Idle
    );
	 
	 localparam PWMBITS = 12;
	 
	 wire Clock_2_5MHz, Clock_10_KHz, Clock100MHz, PWMClock;
	 wire StartPlay, StartRecord, StopPlaying, StartSample;
	 wire [11:0] SoundData, Data;
	 wire [PWMBITS-1:0] RecordedSound;
	 reg [PWMBITS-1:0] PWMData;
	 reg SyncStopRead, SyncMemFull;
	 wire Done, MemFull, StopReading;
	 
	 wire ControllerReset;
	 assign ControllerReset = btnCpuReset & ~MemFull & ~StopReading;
	 
	 assign RamCLK = 1'b0;
	 
	 Clock RunClocks   (
	 .CLK_IN1(SystemClock),
    .Clock100MHz(Clock100MHz), 
    .PWMClock(PWMClock),
    .RESET(~btnCpuReset)
	 ); 

	 
	 ClockDivider #(20,4) SampleClock (
    .Clock(Clock100MHz), 
    .Reset(btnCpuReset), 
    .ClockDiv(Clock_2_5MHz)
    );
	
	 ClockDivider #(50,5) ControllerClock (
    .Clock(Clock100MHz), 
    .Reset(btnCpuReset), 
    .ClockDiv(Clock_10_KHz)
    );
	
	AudioController ControllerSM (
    .Clock(Clock_10_KHz), 
    .Reset(ControllerReset), 
    .Play(Play), 
    .Record(Record), 
    .Stop(Stop),
	 .MemoryFull(MemFull),
	 .StopReading(StopReading),
    .StartPlay(StartPlay), 
    .StartRecord(StartRecord),
	 .StopPlaying(StopPlaying)
    );
	 /*
	 TriColorControl IdleColors (
    .Clock(SystemClock), 
    .Reset(btnCpuReset), 
    .Enable(StopPlaying), 
    .Led(Idle)
    );*/


	assign RedR = StartRecord;
	assign GreenR = StartPlay;
	assign Idle = StopPlaying;
	assign StartSample = Clock_10_KHz;
	
	 PModMic Microphone (
    .SPIClock(Clock_2_5MHz), 
    .Reset(btnCpuReset), 
    .MISO(MISO), 
	 .Start(StartSample),
	 .DataReady(Done),
    .nSS(nSS), 
    .SoundData(SoundData)
    );
	 
	 /*************************************************************
					Syncing the Data to prevent Tearing
	 **************************************************************/
	 
	 reg [11:0] TempData;
	 
	 always @ (posedge Clock100MHz)
	 begin
		if(Done)
			TempData <= SoundData;
		else
			TempData <= TempData;
	end
	
	assign Data = TempData;
	 
	wire EnableOut;
	 
	 MemoryController #(12,PWMBITS) CellRAMShit (
    .Clock(Clock100MHz), 
    .Reset(btnCpuReset), 
	 .DataReadyToWrite(Done),
	 .ReadEnable(StartPlay),
	 .WriteEnable(StartRecord),
	 .DataIn(Data),
    .MemDB(MemDB), 
	 .DataOut(RecordedSound),
    .MemAdr(MemAdr), 
    .RamOEn(RamOEn), 
    .RamWEn(RamWEn), 
    .RamADVn(RamADVn), 
    .RamCEn(RamCEn), 
    .RamUBn(RamUBn), 
    .RamLBn(RamLBn), 
    .RamCRE(RamCRE),
	 .MemoryFull(MemFull),
	 .StopRead(StopReading)
    );
	 
//	 	 WorkingMemoryController #(12,PWMBITS) CellRAMShit (
//    .Clock(Clock100MHz), 
//    .Reset(btnCpuReset), 
//	 .DataReadyToWrite(Done),
//	 .ReadEnable(StartPlay),
//	 .WriteEnable(StartRecord),
//	 .DataIn(Data),
//    .MemDB(MemDB), 
//	 .DataOut(RecordedSound),
//    .MemAdr(MemAdr), 
//    .RamOEn(RamOEn), 
//    .RamWEn(RamWEn), 
//    .RamADVn(RamADVn), 
//    .RamCEn(RamCEn), 
//    .RamUBn(RamUBn), 
//    .RamLBn(RamLBn), 
//    .RamCRE(RamCRE),
//	 .MemoryFull(MemFull),
//	 .StopRead(StopReading)
//    );
	
	 
	 /*********************************************
		Latch The Data In Case The PWM Isn't Ready for it yet
	 **********************************************/
	 always @ (posedge PWMClock)
	 begin
		if(EnableOut)
			PWMData = RecordedSound;
		else
			PWMData = PWMData;
	 end
	 
	 PWMWrapper #(PWMBITS) PWM (
    .Clock(PWMClock), 
    .btnCpuReset(btnCpuReset), 
    .Switch(PWMData), 
	 .EnableOut(EnableOut),
    .JA(ampPWM)
    );
	 

	assign sCLK = Clock_2_5MHz;
	assign ampSD = 1'b1;




endmodule
