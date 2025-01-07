

create_clock -name clk_50mhz -period 20ns [get_ports {clk}]
derive_clock_uncertainty

#set_false_path -from [get_ports {enable}] -to [get_registers {MY_DFF:u0|q}]
#set_false_path -from [get_ports {reset}] -to [get_registers {MY_DFF:u2|q}]
#
#set_false_path -to [get_ports {output[*]}]

