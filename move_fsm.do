vlib work
vlog -timescale 1ns/1ns final_project.v
vsim move_fsm
log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {resetn} 0
force {go} 0
force {y_in} 10000000
run 4

force {go} 1
force {resetn} 1
run 120

force {go} 0
run 4
