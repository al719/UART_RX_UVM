
import tr::*;
`include "uvm_macros.svh"
import uvm_pkg::*;
class my_score_board extends  uvm_scoreboard;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
uvm_event ev3;
virtual UART_interface dut_vif;
seq_item_tr mon_pkt;
uvm_analysis_imp #(seq_item_tr,my_score_board) item_collected_export;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(my_score_board)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "my_score_board", uvm_component parent=null);
		super.new(name, parent);
		item_collected_export = new("item_collected_export",this);
		mon_pkt = new();
	endfunction : new

	function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual UART_interface)::get(null, "", "dut_vif", dut_vif)) begin
      `uvm_fatal("", "uvm_config_db::get failed")
    end
  endfunction 

	virtual function void write(seq_item_tr mon_tr);
		mon_pkt = mon_tr;

	endfunction 

	virtual task run_phase(uvm_phase phase);
		// write your checker logic
		forever begin
			ev3.wait_trigger();
		@(posedge dut_vif.clk_tr) 
		if(mon_pkt.P_data == 8'hce || mon_pkt.P_data == 8'hd1)
			`uvm_info(get_type_name(),"Success through score board",UVM_LOW)
		else 
			`uvm_error(get_type_name(),"Failed through score board")
		// @(posedge mon_pkt.clk);
	end
	endtask
endclass : my_score_board