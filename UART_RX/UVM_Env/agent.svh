//`include "seq_item.svh"
`include "driver.svh"
`include "monitor.svh"
 `include "sequencer.svh"
 `include "uvm_macros.svh"
import uvm_pkg::*;

class my_agent extends  uvm_agent;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	my_driver my_dv;
	my_sequencer myseq;
	my_monitor my_mon;
	//myMonitor mon_n;
	uvm_event ev;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(my_agent)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "my_agent", uvm_component parent=null);
		super.new(name, parent);
		ev = new();
	endfunction : new
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		my_mon = my_monitor::type_id::create("mon",this);
		myseq = my_sequencer::type_id::create("myseq",this);
		my_dv  = my_driver::type_id::create("my_dv",this);
		//mon_n = myMonitor::type_id::create("mon_n",this);
		my_mon.ev1 = ev;
		my_dv.ev1 = ev;
	endfunction 

	function void connect_phase(uvm_phase phase);
		//super.build_phase(phase);
		my_dv.seq_item_port.connect(myseq.seq_item_export);
	endfunction

endclass : my_agent