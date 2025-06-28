#--------------------------------------
# Files Directories
#--------------------------------------
RTL_PATH     = ../../../rtl
TB_PATH      = ../testbench
PACKAGE_PATH = ${TB_PATH}/packages
COV_PATH     = cov
SVA_PATH     = ../sva

PACKAGES     = ${PACKAGE_PATH}/fifo_tb_pkg.sv               \
               ${PACKAGE_PATH}/fifo_stimulus_pkg.sv         \
               ${PACKAGE_PATH}/fifo_env_pkg.sv              \
               ${PACKAGE_PATH}/fifo_test_pkg.sv

RLT_FILES    = ${RTL_PATH}/wptr_full.v                      \
               ${RTL_PATH}/rptr_empty.v                     \
               ${RTL_PATH}/sync.v                           \
               ${RTL_PATH}/sync_rst.v                       \
               ${RTL_PATH}/dpram.v                          \
               ${RTL_PATH}/reg_file.sv                      \
               ${RTL_PATH}/async_fifo.v

DUT          = ${RLT_FILES}                                 \
               ${TB_PATH}/DutWrapper/async_fifo_param.svh   \
               ${TB_PATH}/RdWrAgent/rd_wr_if.sv             \
               ${TB_PATH}/RstAgent/rst_if.sv                \
               ${TB_PATH}/CfgAgent/cfg_if.sv

SVA_FILES    = ${SVA_PATH}/fifo_sva.sv                      \
               ${SVA_PATH}/fifo_sva_bind.sv

HARNESS_TOP  = ${TB_PATH}/DutWrapper/async_fifo_test_top.sv

TEST_TOP     = ${PACKAGES}                                  \
               ${TB_PATH}/test.sv

TOP          = ${HARNESS_TOP} ${TEST_TOP} ${SVA_FILES}

#--------------------------------------
# Tool configuartions
#--------------------------------------
log             = test.log
verbosity       = UVM_MEDIUM
uvm_ver         = uvm-1.2
seed            = 1

# UVM Parameters
UVM_DEFINES     =  UVM_VERDI_COMPWAVE+UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
UVM_OPTIONS     =  UVM_TR_RECORD +UVM_LOG_RECORD 
# +UVM_TIMEOUT=1000000 // to add timeout for the test 1 unit = .1 ns
TRACE_OPTIONS   =  UVM_OBJECTION_TRACE                           \
                  +UVM_VERDI_TRACE="UVM_AWARE+RAL+TLM+IMP+HIER"  \
                  +UVM_VERDI_TRACE=COMPWAVE                      

# Coverage switches
comp_cov_switch = -covg_enable_cross_queue                       \
                  -cm line+cond+fsm+tgl+branch+assert            \
                  -cm_dir  ../cov_db/compile                     \
                  -cm_hier ../cov/cov_scope.txt

run_cov_switch  = -cm line+cond+fsm+tgl+branch+assert

comp_sva_switch = -assert enable_diag                            \
                  +define+ASSERT_ON                              \
                  -y ${VCS_HOME}/packages/sva_cg +libext+.sv     \
                  +incdir+${VCS_HOME}/packages/sva_cg

run_sva_switch  = +fsdb+sva_success

urg_switch      = -dir    cov_db/*.vdb                           \
                  -dbname cov_db_merged.vdb                      \
                  -report ./cov_report                           \
                  -format both                                   \
                  -show tests                                    \
                  -elfile ${COV_PATH}/fifo_cov_exclusion.el      \
                  -plan   ${COV_PATH}/fifo_cov_vplan.hvp

# VCS switches
compile_switches = -sverilog -lca -debug_access+all+reverse -kdb \
                   ${comp_cov_switch}                            \
                   ${comp_sva_switch}                            \
                   +vcs+vcdpluson                                \
                   -timescale="1ns/100ps"                        \
                   -l comp.log                                   \
                   -ntb_opts ${uvm_ver}                          \
                   ${DUT} ${TOP}                                 \
                   +define+${UVM_DEFINES}+${defines}


runtime_switches = -l ${log}                                     \
                   +UVM_VERBOSITY=${verbosity}                   \
                   ${run_cov_switch}                             \
                   ${run_sva_switch}                             \
                   +${TRACE_OPTIONS}                             \
                   +${UVM_OPTIONS}

#--------------------------------------
# Test configuartions
#--------------------------------------
TEST_LIST = test_fifo_traffic     \
            test_fifo_traffic_cb  \
            test_reg_bfm          \
            test_reg_ral_auto     \
            test_reg_ral_directed

# Test specific buil-in RAL Reg sequnece of the following
# - uvm_reg_hw_reset_seq"       // Tests the hard reset values of registers. "LSB"
# - uvm_reg_single_access_seq"  // Verify accessibility through front and back door for a single register.
# - uvm_reg_access_seq"         // Verify accessibility through front and back door for all registers in reg model.
# - uvm_reg_bit_bash_seq        // Verifies the implementation of all registers by attempting to write 1’s and 0’s to every bit in it.
seq  = null
test = test_base

#--------------------------------------
# Make commands
#--------------------------------------
all: simv random

simv compile:
	mkdir compile
	cd compile; ralgen -full64 -uvm -t dut_regmodel ../testbench/CfgAgent/reg.ralf
	cd compile; vcs -full64  ${compile_switches}

run:
	@for tst in ${TEST_LIST}; do \
		mkdir $$tst; \
		cd $$tst; ../compile/simv +ntb_random_seed=${seed} +UVM_TESTNAME=$${tst} ${runtime_switches} -cm_dir ../cov_db/$${tst}_${seed} +seq=${seq} ; \
		cd - ; \
	done

random: simv
	@for tst in ${TEST_LIST}; do \
		mkdir $$tst; \
		cd $$tst; ../compile/simv +ntb_random_seed_automatic +UVM_TESTNAME=$${tst} ${runtime_switches} -cm_dir ../cov_db/$${tst}_${seed} +seq=${seq} ; \
		cd - ; \
	done

run_test: simv
	mkdir $test; \
	cd $test; ../compile/simv +ntb_random_seed_automatic +UVM_TESTNAME=${test} ${runtime_switches} -cm_dir ../cov_db/${test}_${seed} +seq=${seq} ; \
	cd - ;

cov_rpt: all
	urg -full64 ${urg_switch}
	konqueror ./cov_report/dashboard.html&

verdi_cov: cov_rpt
	verdi -cov -covdir cov_db_merged.vdb -elfile cov/fifo_cov_exclusion.el -plan cov/fifo_cov_vplan.hvp&

clean:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile'        \
	! -name 'cov' ! -name 'sva' ! -name 'testbench'          \
	! -name '.' ! -name '..' -exec rm -rf {} +


help:
	@echo  "======================================================================="
	@echo  "                                                                       "
	@echo  " USAGE #1: make target <seed=xxx> <verbosity=YYY>                      "
	@echo  "                                                                       "
	@echo  "  xxx is the random seed.  Can be any integer except 0. Defaults to 1  "
	@echo  "  YYY sets the verbosity filter.  Defaults to UVM_MEDIUM               "
	@echo  "                                                                       "
	@echo  " USAGE #2: make run_test <test=ZZZ>                                    "
	@echo  "  ZZZ selects the uvm test.       Defaults to test_base                "
	@echo  "                                                                       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " all             => Compile TB and DUT files and run all the tests     "
	@echo  " compile         => Compile TB and DUT files                           "
	@echo  " run             => Run the simulation with seed                       "
	@echo  " random          => Run the simulation with random seed                "
	@echo  " cov_rpt         => Run Coverage merge and generate reports            "
	@echo  " verdi_cov       => Run verdi with coverage results                    "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help            => Displays this message                              "
	@echo  " make            => Clean the files generated by the tools             "
	@echo  "======================================================================="
