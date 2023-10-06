package tst_pkg;


`include "sequence.svh"
`include "env.svh"
`include "uvm_macros.svh"
import uvm_pkg::*;
class tst extends uvm_test;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	my_env menv;
	my_sequence my_seq;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(tst)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "tst", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		menv = my_env::type_id::create("menv",this);
		my_seq = my_sequence::type_id::create("my_seq");
	endfunction 

	task run_phase(uvm_phase phase);
	begin
		phase.raise_objection(this);
		my_seq.start(menv.ag.myseq);
		phase.drop_objection(this);
	end
	endtask : run_phase

endclass : tst

endpackage