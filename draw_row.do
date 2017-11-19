vlib work
vlog -timescale 1ns/1ns final_project.v
vsim draw
log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {resetn} 0
force {go} 0
force {x_in} 00000010
force {y_in} 10000010
run 4

force {go} 1
force {resetn} 1
run 120

force {go} 0
run 4
