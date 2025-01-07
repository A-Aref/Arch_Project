vsim work.cpu
add wave -position insertpoint  \
sim:/cpu/clk
add wave -position insertpoint  \
sim:/cpu/rst
add wave -position insertpoint  \
sim:/cpu/Input
add wave -position insertpoint  \
sim:/cpu/Output
add wave -position insertpoint  \
sim:/cpu/PC
add wave -position insertpoint  \
sim:/cpu/Stack_Pointer
add wave -position insertpoint  \
sim:/cpu/epc_out
add wave -position insertpoint  \
sim:/cpu/Flags_OUT
force -freeze sim:/cpu/Input 0000000000000000 0
force -freeze sim:/cpu/rst 1 0
force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
run
mem load -i {D:/Old Data/Term1_year3/Com_Arch/assembler/output.mem} -format mti /cpu/Int_Mem/MEM
force -freeze sim:/cpu/rst 0 0
run