-- Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2014.4 (lin64) Build 1071353 Tue Nov 18 16:47:07 MST 2014
-- Date        : Fri Jan 23 18:52:01 2015
-- Host        : aaron-All-Series running 64-bit Ubuntu 14.10
-- Command     : write_vhdl -force -mode synth_stub
--               /home/aaron/Dropbox/EE324/AudioRecorder/project_1/project_1.srcs/sources_1/ip/Clock/Clock_stub.vhdl
-- Design      : Clock
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clock is
  Port ( 
    CLK_IN1 : in STD_LOGIC;
    Clock100MHz : out STD_LOGIC;
    PWMClock : out STD_LOGIC;
    RESET : in STD_LOGIC
  );

end Clock;

architecture stub of Clock is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK_IN1,Clock100MHz,PWMClock,RESET";
begin
end;
