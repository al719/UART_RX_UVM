
`include "uvm_macros.svh"
import uvm_pkg::*;
import tr::seq_item_tr;

class my_sequencer extends uvm_sequencer#(seq_item_tr);
`uvm_component_utils(my_sequencer)

function new(string name = "sequencer",uvm_component parent);
	super.new(name,parent);
endfunction 


endclass 