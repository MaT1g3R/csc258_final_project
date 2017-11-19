vlib work
vlog -timescale 1ns/1ns final_project.v
vsim delay
log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4

force {resetn} 0
run 4

force {resetn} 1
run 1000
