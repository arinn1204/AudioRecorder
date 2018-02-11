// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.4 (lin64) Build 1071353 Tue Nov 18 16:47:07 MST 2014
// Date        : Fri Jan 23 18:52:01 2015
// Host        : aaron-All-Series running 64-bit Ubuntu 14.10
// Command     : write_verilog -force -mode synth_stub
//               /home/aaron/Dropbox/EE324/AudioRecorder/project_1/project_1.srcs/sources_1/ip/Clock/Clock_stub.v
// Design      : Clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Clock(CLK_IN1, Clock100MHz, PWMClock, RESET)
/* synthesis syn_black_box black_box_pad_pin="CLK_IN1,Clock100MHz,PWMClock,RESET" */;
  input CLK_IN1;
  output Clock100MHz;
  output PWMClock;
  input RESET;
endmodule
