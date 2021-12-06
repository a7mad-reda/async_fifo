compile: clean
	dc_shell -f scripts/dc.tcl | tee -i syn.log
clean:
#	remove all except
	find ! -name 'Makefile' ! -name 'mapped' ! -name 'unmapped' ! -name 'scripts' \
	! -name 'dc.tcl' ! -name 'async_fifo.sdc' ! -name 'reports' ! -name '.synopsys_dc.setup' \
	! -name '.' ! -name '..' -exec rm -rf {} +	

