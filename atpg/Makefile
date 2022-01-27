#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#
#									#
#		*** ATPG Flow Automation  ***				#
#	1) make atpg " atpg flow for all modes and faults "		#
#	2) patterns validation 	< single fault & mode / time >		#
#	 -> make sim_serial " serial_simualtion "include sdf"		#
#	 -> make sim_paralel " parallel simulation "faster"		#
#	 -> make sim_debug " interactive debuging "			#
#	3) make pt_stuck " pre simulation STA "				#
#	 -> for shift and capture modes using tester clock		#
#	4) make pt_speed " at-speed STA "				#
#	 -> capture mode using fast_ate_clock or pll_clock		#
#	5) make ${fault} " run atpg flow for only ${fault} "		#
#									#
#-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-<-->-#

LIB_FILE := -v ../../libs/mw_lib/tmax/core.v
NET_FILE := ../../syn/mapped_scan/async_fifo.v

atpg: remove path_delay trans_sdd trans stuck iddq pt_stuck

path_delay: pt_speed
	tmax -tcl ./scripts/occ_bypass/01_path_delay.tcl
	tmax -tcl ./scripts/pll_based/01_path_delay.tcl
	make clean

trans_sdd: 
	tmax -tcl ./scripts/occ_bypass/02_trans_sdd.tcl
	tmax -tcl ./scripts/pll_based/02_trans_sdd.tcl
	make clean

trans: 
	tmax -tcl ./scripts/occ_bypass/03_trans.tcl
	tmax -tcl ./scripts/pll_based/03_trans.tcl
	make clean

stuck: 
	tmax -tcl ./scripts/occ_bypass/04_stuck.tcl
	tmax -tcl ./scripts/pll_based/04_stuck.tcl
	make clean

iddq: 
	tmax -tcl ./scripts/occ_bypass/05_iddq.tcl
	tmax -tcl ./scripts/pll_based/05_iddq.tcl
	make clean

pt_speed:  
	-pt_shell -f ./scripts/pll_based/T1_pt_at_speed.tcl | tee \
	-i ./logs/pt_at_speed_pll_based.log
	-pt_shell -f ./scripts/occ_bypass/T1_pt_at_speed.tcl | tee \
	-i ./logs/pt_at_speed_occ_bypass.log
	make clean

pt_stuck:  
	-pt_shell -f ./scripts/pll_based/T2_pt_stuck.tcl | tee \
	-i ./logs/pt_stuck_pll_based.log
	-pt_shell -f ./scripts/occ_bypass/T2_pt_stuck.tcl | tee \
	-i ./logs/pt_stuck_occ_bypass.log
	make clean


sim_parallel: 
	echo "OCC Modes : < occ_bypass / pll_based >" ; \
	echo -n "OCC_Mode = " ; \
	read occ_mode ; \
	echo "Fault : < stuck / trans / trans_sdd / path_delay >" ; \
	echo -n "Fault = " ; \
	read fault ; \
	echo "Test_Modes : < TM1 / TM2 / TM3 / TM4 >" ; \
	echo -n "Test_Mode = " ; \
	read mode ; \
	cd ./max_sim ; \
	find -maxdepth 1 ! -name 'parallel' ! -name 'serial' ! -name 'logs' \
	! -name '.' ! -name '..' -exec rm -rf {} + ; \
	vcs -full64 -R -override_timescale=1ns/1ns \
	    ${LIB_FILE} \
	    ${NET_FILE} \
	    ./parallel/$${occ_mode}/$${fault}/$${mode}/pat_parallel_tb.v \
	    +tetramax \
	    +delay_mode_zero \
	    +define+tmax_rtp=1 \
	    +define+tmax_msg=1  \
	    +define+tmax_fsdb \
	    -debug_access+dmptf \
	    -o pat_parallel_simv_$${mode} \
	    -l compile_parallel_$${mode}.log ; \
	./pat_parallel_simv_$${mode} 
	make clean

sim_serial: clean
	echo "OCC Modes : < occ_bypass / pll_based >" ; \
	echo -n "OCC_Mode = " ; \
	read occ_mode ; \
	echo "Fault : < stuck / trans / trans_sdd / path_delay >" ; \
	echo -n "Fault = " ; \
	read fault ; \
	echo "Test_Modes : < TM1 / TM2 / TM3 / TM4 >" ; \
	echo -n "Test_Mode = " ; \
	read mode ; \
	cd ./max_sim ; \
	find -maxdepth 1 ! -name 'parallel' ! -name 'serial' ! -name 'logs' \
	! -name '.' ! -name '..' -exec rm -rf {} + ; \
	vcs -full64 -R -override_timescale=1ns/1ns \
	    ${LIB_FILE} \
	    ${NET_FILE} \
	    ./serial/$${occ_mode}/$${fault}/$${mode}/pat_serial_tb.v \
	    +tetramax \
	    +define+tmax_rtp=1 \
	    +define+tmax_msg=1  \
	    +define+tmax_fsdb \
	    -debug_access+dmptf \
	    -o pat_serial_simv_$${mode} \
	    -l compile_serialv_$${mode}.log ;\
	./pat_serial_simv_$${mode} 
	make clean


sim_debug:
	cd ./max_sim ; \
	verdi -ssf novas.fsdb -play ../scripts/verdi_scr.cmd  &


remove:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name '.tmaxtclrc' \
	! -name 'dftc_protocols' ! -name 'scripts' ! -name 'logs'  \
	! -name '.' ! -name '..' -exec rm -rf {} +

clean:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name '.tmaxtclrc' ! -name 'occ_bypass_protocols' \
	! -name 'logs' ! -name 'dftc_protocols' ! -name 'reports' ! -name 'imgs' \
	! -name 'scripts' ! -name 'pt' ! -name 'faults' \
	! -name 'patterns' ! -name 'max_sim' ! -name '.' ! -name '..' -exec rm -rf {} +	

