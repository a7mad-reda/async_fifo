top_module = async_fifo_tb

sim: clean analysis compilation simulation

debug: clean analysis compilation interactive_debug


clean:
#	remove all except
	find ! -name 'Makefile' ! -name 'run.f' ! -name 'fsdb_dump.tcl' \
	! -name 'signal.rc' ! -name 'verdi_scr.cmd' \
	! -name '.' ! -name '..' -exec rm -rf {} +	

analysis:
	vlogan -full64 -sverilog -l ana.log -kdb -f run.f
#	vhlan -full64  -l ana.log -kdb -f run.f #for vhdl analysis

compilation:
	vcs -full64 -sverilog -l comp.log $(top_module) -debug_access+all -kdb -lca \
	+warn=noLCA_FEATURES_ENABLED

simulation:
	./simv 
	
interactive_debug:
	./simv -ucli -i -do fsdb_dump.tcl
	verdi -ssf $(top_module).fsdb -play verdi_scr.cmd 
