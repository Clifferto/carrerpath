xvlog --incr --relax ../$1.srcs/sources_1/new/$1.v ../$1.srcs/sim_1/new/tb_$1.v
xelab --debug all --top tb_$1 --snapshot top --incr --relax
xsim top --tclbatch ../../sim_launcher_cfg.tcl
xsim --gui top.wdb
