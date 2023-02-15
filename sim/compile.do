vlib modelsim/work
vlib modelsim/msim

vmap work modelsim/work
vmap msim modelsim/msim

vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bcnt.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bin2gray.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/delayreg.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/esync.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/jksync.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/pdet.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bcnts.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bus_edet.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/dpram.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/gcnt.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/pulse.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bcntsync.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/dcfifo.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/dsync.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/gray2bin.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/mux.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/rsync.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/bdet.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/dcfifofsm.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/edet.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/jkl.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/ndet.sv"
vlog -work msim -64 -incr -sv "+incdir+../src/import/" "../src/import/usedcalc.sv"

vlog -work msim -64 -incr -sv "../src/axi_master_rd.sv"
vlog -work msim -64 -incr -sv "../src/axi_master_rd.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_frame_ctrl.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_pkg.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_interface.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_sync_gen.sv"
vlog -work msim -64 -incr -sv "../src/axi_pkg.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_line_buffer.sv"
vlog -work msim -64 -incr -sv "../src/adv7393_top.sv"
vlog -work msim -64 -incr -sv "../src/fifo_rd_dconv.sv"

vlog -work msim -64 -incr -sv "../src/adv7393_top_tb.sv"

