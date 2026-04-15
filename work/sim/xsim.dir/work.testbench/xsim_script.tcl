set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {work.testbench} -testplusarg UVM_TESTNAME=baud_rate_test -testplusarg UVM_VERBOSITY=UVM_MEDIUM -testplusarg seed=1 -wdb {work.testbench.wdb} -autoloadwcfg -tclbatch {C:/Users/PC/Documents/UVM_uart/wave.tcl}
