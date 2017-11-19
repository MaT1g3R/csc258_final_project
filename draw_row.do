vlib work
vlog -timescale 1ns/1ns final_project.v
vsim draw
log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {resetn} 0
force {go} 0
force {x_in} 
run 4

