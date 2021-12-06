check: clean
	fm_shell -f fm.tcl | tee -i fm.log
check_script: clean
	fm_mk_script -output fm.tcl async_fifo.svf
clean:
#	remove all except
	find ! -name 'Makefile' ! -name 'async_fifo.svf' ! -name 'fm.tcl' ! -name 'fm.log' \
	! -name '.' ! -name '..' -exec rm -rf {} +	

