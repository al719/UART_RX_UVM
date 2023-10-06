
`include "agent.svh"
`include "score_board.svh"
`include "subscriber.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends  uvm_env;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	my_agent ag;
	my_score_board sb;
	my_subscriber cv;
	uvm_event ev5;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(my_env)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "my_env", uvm_component parent=null);
		super.new(name, parent);
		ev5 = new();
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		ag = my_agent::type_id::create("ag",this);
		sb = my_score_board::type_id::create("sb",this);
		cv = my_subscriber::type_id::create("cv",this);
	endfunction

	function void connect_phase(uvm_phase phase);
	 	ag.my_mon.item_collected_port.connect(sb.item_collected_export);
	 	ag.my_mon.item_collected_port.connect(cv.analysis_export);
	 	ag.my_mon.ev2 = ev5;
		sb.ev3 = ev5;
	 endfunction 

endclass : my_env