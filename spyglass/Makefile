gui_cdc: clean
	spyglass -project cdc.prj 

gui_lint: clean
	spyglass -project lint.prj

batch_cdc: clean
	spyglass -shell -tcl cdc.tcl

batch_lint: clean
	spyglass -shell -tcl lint.tcl

help:
	spyglass -quickstart

clean:
#	remove all except
	find ! -name 'Makefile' ! -name 'run.f' ! -name 'lint.prj' ! -name 'cdc.prj' \
	! -name 'constraints.sgdc' ! -name 'constraints.sgdc' ! -name 'waiver_file.awl' \
	! -name 'lint.tcl' ! -name 'cdc.tcl' ! -name '.' ! -name '..' -exec rm -rf {} +	

