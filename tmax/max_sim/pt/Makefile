pt: remove_pt 
	pt_shell -f pt.tcl | tee -i ./logs/pt.log
	make clean

remove_pt:
#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'pt.tcl' ! -name 'reports' \
	! -name 'TM1' ! -name 'TM2' ! -name 'TM3' ! -name 'TM4' \
	! -name '.' ! -name '..' -exec rm -rf {} +	

clean:
#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'pt.tcl' ! -name 'reports' \
	! -name 'TM1' ! -name 'TM2' ! -name 'TM3' ! -name 'TM4' \
	! -name '.' ! -name '..' -exec rm -rf {} +
