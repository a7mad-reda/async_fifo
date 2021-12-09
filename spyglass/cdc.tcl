##Data Import Section

read_file -type sourcelist run.f
read_file -type sgdc constraints.sgdc
read_file -type awl waiver_file.awl

#design_reda
current_goal Design_Read -top async_fifo
link_design -force

##Goal Setup Section

current_methodology $SPYGLASS_HOME/GuideWare/latest/block/rtl_handoff


current_goal cdc/cdc_setup_check -top async_fifo
run_goal

current_goal cdc/clock_reset_integrity -top async_fifo
run_goal

current_goal cdc/cdc_verify_struct -top async_fifo
run_goal

current_goal cdc/cdc_verify -top async_fifo
run_goal

current_goal cdc/cdc_abstract -top async_fifo
run_goal

current_goal rdc/rdc_verify_struct -top async_fifo
run_goal


