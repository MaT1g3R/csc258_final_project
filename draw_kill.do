vlib work
vlog -timescale 1ns/1ns final_project.v
vsim draw
log {/*}
add wave {/*}

force {clk} 0 0, 1 2 -r 4
force {go} 0
force {resetn} 0
force {key} 0
force {x_in} 00000100
force {y_in} 00000000

run 4

force {go} 1
force {resetn} 1
force {y_in} 00000001
run 4

force {y_in} 00000010
run 4

force {y_in} 00000011
run 4

force {y_in} 10001000
run 4

force {y_in} 00000001
run 4

force {y_in} 00000010
run 4

force {y_in} 00000011
run 4

force {y_in} 10001000
run 4

force {y_in} 00000001
run 4

force {y_in} 00000010
run 4

force {y_in} 00000011
run 4

force {y_in} 10001000
run 4
