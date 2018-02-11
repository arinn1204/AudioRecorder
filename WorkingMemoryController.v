`timescale 1ns / 1ps


module WorkingMemoryController(
    input Clock,
    input Reset,
	 input DataReadyToWrite,
	 input ReadEnable,
	 input WriteEnable,
	 
	 input [INCOMINGDATA - 1:0] DataIn,
	 inout [15:0] MemDB,
	 output reg [OUTGOINGDATA - 1:0] DataOut,
	 
	 output [22:0] MemAdr,
	 output reg RamOEn,
	 output reg RamWEn,
	 output RamADVn,
	 output reg RamCEn,
	 output RamUBn,
	 output RamLBn,
	 output RamCRE,
	 
	 output reg StopRead,
	 output MemoryFull
    );
	 
	 parameter INCOMINGDATA = 12;
	 parameter OUTGOINGDATA = 8;
	 
	 
	 localparam LEADINGONES = 16-INCOMINGDATA;
	 localparam LOWERLIMIT = 16-LEADINGONES;
	 localparam COMPLEADINGONES = {LEADINGONES{1'b1}};
	 localparam HundredNS = 4'd10;
	 localparam MAXMEMORY = 10'h400;
	 
	 
	 
	 reg [INCOMINGDATA - 1:0] TempData;
	 
	 reg [1:0] nState, pState;
	 reg [2:0] AddrValCounter;
	 reg [15:0] Data;
	 reg [3:0] StateCounter;
	 
	 reg CounterFullFlag;
	 reg [2:0] DataEdge;
	 
	 wire DataRE;
	 
	 reg [22:0] Counter;
	 
	 
	 localparam Rest = 2'd0;
	 localparam Read = 2'b01, Write = 2'b10;
	 
	 initial begin
		nState = Rest;
		pState = Rest;
		Counter = 23'b0;
		DataEdge = 3'b0;
		CounterFullFlag = 1'b0;
		AddrValCounter = 3'b0;
	 end
	 
	 
	 always @ (posedge Clock)
		DataEdge <= {DataEdge[1:0],DataReadyToWrite};
		
	assign DataRE = (DataEdge[2:1] == 2'b10);
	 
	
always @ (posedge Clock)
	begin
		if(~Reset)
			Counter <= 23'b0;
		else if (Counter == MAXMEMORY - 1)
			Counter <= 23'b0;
		else if ((~WriteEnable && ~ReadEnable) && pState == Rest)
			Counter <= 23'b0;
		else if (StateCounter == HundredNS && (WriteEnable || ReadEnable))
			Counter <= Counter + 1'b1;
		else
			Counter <= Counter;
	end
	
		 
	assign MemAdr = Counter;
	
always @ (posedge Clock)
	begin
		if(~Reset)
			CounterFullFlag <= 1'b0;
		else if (Counter == MAXMEMORY - 1)
			CounterFullFlag <= 1'b1;
		else
			CounterFullFlag <= 1'b0;
	end
	
	assign MemoryFull = CounterFullFlag;

	
always @ (posedge Clock)
	begin
		if(StateCounter == 4'hF)
			StateCounter <= 4'b0;
		else if (pState == Read || pState == Write)
			StateCounter <= StateCounter + 1'b1;
		else
			StateCounter <= 4'b0;
	end
	 
	 always @ (pState, ReadEnable, WriteEnable, CounterFullFlag, StateCounter, DataRE)
		begin
			case (pState)
				Rest:
					begin
						if (ReadEnable && ~CounterFullFlag && DataRE)
							nState = Read;
						else if (WriteEnable && ~CounterFullFlag && DataRE)
							nState = Write;
						else
							nState = Rest;
					end
				Read:
					begin
						if(StateCounter == HundredNS)
							nState = Rest;
						else
							nState = Read;
					end	
				Write:
					begin
						if(StateCounter == HundredNS)
							nState = Rest;
						else
							nState = Write;
					end
			default:
				nState = Rest;
			endcase
		end

always @ (posedge Clock)
	pState <= (~Reset) ? Rest : nState;
	
	
	 
		 always @ (pState, StateCounter)
			begin
								//////////WRITE OPERATION///////////
				if (pState == Write)
					RamOEn = 1'b0;
								/////////READ OPERATION/////////////
				else if (StateCounter >= 4'd8 && StateCounter <= HundredNS)
					RamOEn = 1'b0;
				else
					RamOEn = 1'b1;
			end
			
		always @ (pState, StateCounter)
			begin
				//////////////////WRITE OPERATION//////////////
				if((StateCounter >= 4'd5 && StateCounter <= HundredNS) && pState == Write)
					RamWEn = 1'b0;
				/////////////////READ OPERATION////////////////
				else if (pState == Read)
					RamWEn = 1'b1;
				else
					RamWEn = 1'b1;
			end
		always @ (StateCounter)
			begin
			//////////////WRITE OPERATION/////////////
			if(StateCounter > 4'b0 && StateCounter <= HundredNS)
				RamCEn = 1'b0;
			else
				RamCEn = 1'b1;
			end
		
		 
	 assign RamUBn = 1'b0;
	 assign RamLBn = 1'b0;
	 assign RamCRE = 1'b0;
	 assign RamADVn = 1'b0;

	 always @ (posedge Clock)
		TempData <= (pState == Rest) ? DataIn : TempData;
		
		
		
	 
	 always @ (posedge Clock, negedge Reset)
		begin
			if(~Reset)
				DataOut <= 'b0;
			else if (StateCounter == 4'd10 && pState == Read)
				DataOut <= MemDB[OUTGOINGDATA-1:0];
			else if (pState == Write)
				DataOut <= 'b0;
			else
				DataOut <= DataOut;
		end
	 
	 
	 always @ (StateCounter, pState, TempData, WriteEnable)
		begin
			if((StateCounter == 4'd9 || StateCounter == 4'd10) && pState == Write && WriteEnable)
				Data = TempData;
			else if ((StateCounter == 4'd9 || StateCounter == 4'd10) && pState == Write && ~WriteEnable)
				Data = {{LEADINGONES{1'b1}},TempData};
			else
				Data = 16'bZ;
		end

	 assign  MemDB = Data;
	
		always @ (StateCounter, MemDB, pState)
			begin
				if((StateCounter == 4'd9 || StateCounter == 4'd10) && (pState == Read) && (MemDB[15:LOWERLIMIT] == COMPLEADINGONES))
					StopRead = 1'b1;
				else
					StopRead = 1'b0;
			end
	 
	 

	

endmodule
