vlib work
vlog -timescale 1ns/1ns final_project.v
vsim main
log {/*}
add wave {/*}

force {clk} 1 0, 0 2 -r 4
force {go} 1 0, 0 4 -r 252
force {colour_in} 101
force {x_in} 00010100

force {resetn} 0
run 252

force {resetn} 1
run 12400000