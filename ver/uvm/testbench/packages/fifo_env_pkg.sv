package fifo_env_pkg;

import fifo_tb_pkg::*;
import uvm_pkg::*;
import fifo_stimulus_pkg::*;


`include "../testbench/RdWrAgent/rd_wr_mon.sv"
`include "../testbench/RdWrAgent/rd_wr_drv.sv"
`include "../testbench/RdWrAgent/rd_wr_agnt.sv"

`include "../testbench/CfgAgent/cfg_mon.sv"
`include "../testbench/CfgAgent/cfg_drv.sv"
`include "../testbench/CfgAgent/cfg_agnt.sv"

`include "../testbench/RstAgent/rst_drv.sv"
`include "../testbench/RstAgent/rst_agnt.sv"

`include "../testbench/fifo_scoreboard.sv"

`include "../testbench/fifo_env.sv"

endpackage
