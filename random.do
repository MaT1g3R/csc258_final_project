vlib work
vlog -timescale 1ns/1ns final_project.v
vsim rng
log {/*}
add wave {/*}

force {clock} 1 0, 0 2 -r 4
force {need_rng} 1 0, 0 4 -r 252


force {reset_n} 0
run 252

force {reset_n} 1
run 12400000