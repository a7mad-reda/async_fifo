#---------------------------------------------------------------------
# User-defined variables for logical library setup
#---------------------------------------------------------------------
set ADDITIONAL_SEARCH_PATH        "../libs/mw_lib/sc/LM \
				   ./rtl ./scripts \
				   ./mapped ./unmapped ./rtl "          ;#  Directories containing logic libraries,
                                                                         #  logic design, script files, mapped files, RTL files.
set TARGET_LIBRARY_FILES          sc_max.db                   		;#  Logic cell library file
set SYMBOL_LIBRARY_FILES          sc.sdb                      		;#  Symbol library file

#---------------------------------------------------------------------
# User-defined variables for physical library setup in dc_setup.tcl
#---------------------------------------------------------------------
#set MW_DESIGN_LIB                 MY_DESIGN_LIB 	        	;#  User-defined Milkyway design library name

#set MW_REFERENCE_LIB_DIRS         ../libs/mw_lib/sc         		;#  Milkyway physical cell libraries

#set TECH_FILE                     ../libs/tech/cb13_6m.tf          	;#  Milkyway technology file
	
#set TLUPLUS_MAX_FILE              ../libs/tlup/cb13_6m_max.tluplus  	;#  Max TLUPlus file

#set MAP_FILE                      ../libs/tlup/cb13_6m.map          	;#  Mapping file for TLUplus
