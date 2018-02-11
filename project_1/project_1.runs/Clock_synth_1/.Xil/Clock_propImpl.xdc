set_property SRC_FILE_INFO {cfile:/home/aaron/Dropbox/EE324/AudioRecorder/project_1/project_1.srcs/sources_1/ip/Clock/Clock.xdc rfile:../../../project_1.srcs/sources_1/ip/Clock/Clock.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports CLK_IN1]] 0.1
