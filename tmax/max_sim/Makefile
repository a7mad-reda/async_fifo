LIB_FILE := -v ../../libs/mw_lib/tmax/core.v
NET_FILE := ../../syn/mapped_scan/async_fifo.v

sim_parallel: remove
	for mode in TM1 TM2 TM3 TM4 ; \
	do \
	vcs -full64 -override_timescale=1ns/1ns \
	    ${LIB_FILE} \
	    ${NET_FILE} \
	    ./parallel/$${mode}/pat_parallel_tb.v \
	    +tetramax \
	    +delay_mode_zero \
	    +define+tmax_rtp=1 \
	    +define+tmax_msg=1  \
	    +define+tmax_fsdb \
	    -debug_access+dmptf \
	    -o pat_parallel_simv_$${mode} \
	    -l logs/$${mode}/compile_parallel.log ;\
	done
	for mode in TM1 TM2 TM3 TM4 ; \
	do ./pat_parallel_simv_$${mode} ; \
	done

sim_serial: remove
	for mode in TM1 TM2 TM3 TM4 ; \
	do \
	vcs -full64 -override_timescale=1ns/1ns \
	    ${LIB_FILE} \
	    ${NET_FILE} \
	    ./serial/$${mode}/pat_serial_tb.v \
	    +tetramax \
	    +define+tmax_rtp=1 \
	    +define+tmax_msg=1  \
	    +define+tmax_fsdb \
	    -debug_access+dmptf \
	    -o pat_serial_simv_$${mode} \
	    -l logs/$${mode}/compile_serial.log ;\
	done
	for mode in TM1 TM2 TM3 TM4 ; \
	do ./pat_serial_simv_$${mode} ; \
	done

debug:
	verdi -ssf novas.fsdb &

remove:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'pt' ! -name 'sdf' \
	! -name 'logs' ! -name 'serial' ! -name 'parallel' \
	! -name '.' ! -name '..' -exec rm -rf {} +

clean:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'pt' ! -name 'sdf' \
	! -name 'logs' ! -name 'serial' ! -name 'parallel' \
	! -name '.' ! -name '..' -exec rm -rf {} +

