
`include "uvm_macros.svh"
import uvm_pkg::*;
import tr::seq_item_tr;

class my_monitor extends  uvm_monitor;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual UART_interface dut_vif;
	uvm_event ev1;
	uvm_event ev2;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(my_monitor)

 //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------

  uvm_analysis_port #(seq_item_tr) item_collected_port;
    seq_item_tr item_collected;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "my_monitor", uvm_component parent=null);
		super.new(name, parent);
		item_collected = new();
		item_collected_port = new("item_collected_port",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual UART_interface)::get(null, "", "dut_vif", dut_vif))
			`uvm_fatal("","doesn't read stimulus through monitor")
	endfunction 

	virtual task run_phase(uvm_phase phase);
		// monitor sampling
		// forever begin 
		
		// //item_collected.rst = dut_vif.rst;
		// item_collected.wr_en = dut_vif.wr_en;
		// item_collected.rd_en = dut_vif.rd_en;
		// //item_collected.W_data = dut_vif.W_data;
		// item_collected.R_data = dut_vif.R_data;
		// `uvm_info(get_type_name(),$sformatf("Print : %s Read_Data : 0x%h",item_collected.sprint(),item_collected.R_data),UVM_LOW)
		// item_collected_port.write(item_collected); // to send sampling from dut to score board
		// @(posedge dut_vif.clk);
	forever begin 
		ev1.wait_trigger();
		monitor_dut();
	  `uvm_info(get_type_name(),$sformatf("P_Data : 0x%h , data_valid = %b",item_collected.P_data,item_collected.data_valid),UVM_LOW)
		
		item_collected_port.write(item_collected); // to send sampling from dut to score board
		ev2.trigger();
	end 
	endtask : run_phase

	task monitor_dut;
		begin
				 @(posedge dut_vif.CLK);
				item_collected.rst = dut_vif.RST;
				item_collected.parity_type = dut_vif.PAR_TYP;
				item_collected.parity_enable = dut_vif.PAR_EN;
				item_collected.ser_in = dut_vif.RX_IN; // coverage
				item_collected.P_data = dut_vif.P_DATA; // coverage
				item_collected.data_valid =dut_vif.data_valid; // coverage
				item_collected.data = dut_vif.data; // should loop to collect it
			
		end
	endtask

endclass : my_monitor



////////////////////////////////////////////////////

