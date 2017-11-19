vlib work
vlog -timescale 1ns/1ns final_project.v
vsim y_counter
log {/*}
add wave {/*}

force {clk} 1 0, 0 2 -r 4
force {go} 1 0, 0 2 -r 8

force {y_in} 00001000
force {resetn} 0
run 4

force {resetn} 1
run 10000
