compile: clean
	dc_shell -f scripts/dc.tcl | tee -i ./logs/syn.log
clean:
#	remove all except
	find -maxdepth 1 ! -name 'Makefile' ! -name 'common_setup.tcl' ! -name 'dc_setup.tcl' ! -name 'scripts' \
	! -name 'logs' ! -name 'mapped' ! -name '.synopsys_dc.setup' ! -name 'logs' ! -name 'rtl.f' \
	! -name 'mapped_scan' ! -name 'unmapped' ! -name 'reports' \
	! -name '.' ! -name '..' -exec rm -rf {} +	

