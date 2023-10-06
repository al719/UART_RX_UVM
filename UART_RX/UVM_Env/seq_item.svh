package tr;
import uvm_pkg::*;
`include "uvm_macros.svh"
class seq_item_tr extends uvm_sequence_item;

// payload - control - configuration - analysis 
//rand bit rst;

rand bit rst;
rand bit parity_type;
rand bit parity_enable;
rand bit ser_in;
bit[7:0] data;
bit data_valid;
bit[7:0] P_data;
bit rx;
rand bit[9:0] data_with_parity;
rand bit[8:0] data_without_parity;
// Utility and Field Macros
`uvm_object_utils_begin(seq_item_tr)
	`uvm_field_int(rst , UVM_ALL_ON)
	`uvm_field_int(parity_type , UVM_ALL_ON)
	`uvm_field_int(parity_enable , UVM_ALL_ON)
	`uvm_field_int(ser_in , UVM_ALL_ON)
	`uvm_field_int(data_with_parity , UVM_ALL_ON)
	`uvm_field_int(data_without_parity , UVM_ALL_ON)
`uvm_object_utils_end

function new(string name = "seq_item_tr");
	super.new(name);
endfunction 

// write constraints

	//bit parity_type,parity_enable;
	//bit[0:1] flag;
	constraint rst_ {
		rst dist {0:=5 , 1 := 95};
	}
	constraint data_ {
		if(parity_enable) {
			if(parity_type) {	
				data_with_parity inside {10'h2ce , 10'h3d1};//(ser_in == 0) -> 
				}
			else {
				data_with_parity inside {10'h3ce , 10'h2d1};//(ser_in == 0) -> 
				}
			}
		else {
			   data_without_parity inside {9'h1ce , 9'h1d1};//(ser_in == 0) -> 
				
			}
			//solve ser_in before data_with_parity;
			//solve ser_in before data_without_parity;
	}

	constraint ser {
			ser_in ==0;//dist {0 := 50 , 1 := 50};
	}
	constraint parity {
		parity_enable dist {0:= 50 , 1:=50};
		parity_type dist {[0:1]:/100};
	}


endclass  : seq_item_tr 
endpackage