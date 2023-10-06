
`include "uvm_macros.svh"
import uvm_pkg::*;
import tr::seq_item_tr;

class my_sequence extends uvm_sequence #(seq_item_tr);

`uvm_object_utils(my_sequence);

function  new(string name = "my_sequence");
	super.new(name);
endfunction 

virtual task body;
	forever begin 
	req = seq_item_tr::type_id::create("req");
	// start_item(req);
	// if(!req.randomize())
	// 	`uvm_fatal("my sequence","randomize failed");
	// finish_item(req);
	wait_for_grant(); // you wait for sequencer to get grant from drive for getting next item then the sequencer allow you to send new seq_item_tr
	if(!req.randomize()) 
		`uvm_fatal("Squence Random","Inside sequence through randomization")
	send_request(req);
	wait_for_item_done();
	get_response(req);
end 
endtask

endclass 