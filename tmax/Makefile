tmax_atpg: remove
	tmax -tcl tmax_atpg.tcl 

tmax_sim: clean
	tmax -tcl tmax_sim.tcl 

remove:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'tmax_atpg.tcl' ! -name '.tmaxtclrc' \
	! -name 'test_protocols' ! -name 'tmax_sim.tcl' ! -name 'max_sim' \
	! -name '.' ! -name '..' -exec rm -rf {} +

clean:
	#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'tmax_atpg.tcl' ! -name '.tmaxtclrc' \
	! -name 'logs' ! -name 'test_protocols' ! -name 'reports' ! -name 'imgs' ! -name 'tmax_sim.tcl' \
	! -name 'patterns' ! -name 'max_sim' ! -name '.' ! -name '..' -exec rm -rf {} +	

