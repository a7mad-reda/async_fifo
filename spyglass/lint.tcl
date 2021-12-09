##Data Import Section

read_file -type sourcelist run.f
read_file -type sgdc constraints.sgdc
read_file -type awl waiver_file.awl

#design_reda
current_goal Design_Read -top async_fifo
link_design -force

##Goal Setup Section
current_methodology $SPYGLASS_HOME/GuideWare/latest/block/rtl_handoff

current_goal lint/lint_rtl -top async_fifo
run_goal

current_goal lint/lint_turbo_rtl -top async_fifo
run_goal

current_goal lint/lint_functional_rtl -top async_fifo
run_goal

current_goal lint/lint_abstract -top async_fifo
run_goal

current_goal adv_lint/adv_lint_struct -top async_fifo
run_goal

current_goal adv_lint/adv_lint_verify -top async_fifo
run_goal




