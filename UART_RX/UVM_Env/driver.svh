
import uvm_pkg::*;
`include "uvm_macros.svh"
import tr::seq_item_tr;

class my_driver extends uvm_driver #(seq_item_tr);
	`uvm_component_utils(my_driver)
	//seq_item_tr req;
	virtual UART_interface dut_vif;
	uvm_event ev1;
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db #(virtual UART_interface) :: get(this , "" , "dut_vif" , dut_vif))
			`uvm_fatal("","failed to read interface through driver");
	endfunction 

    task run_phase(uvm_phase phase);
	
	//super.run_phase(phase);

	forever begin  
		seq_item_port.get_next_item(req);
		`uvm_info(get_type_name(),$sformatf("Print : %s",req.sprint()),UVM_LOW)
		//$display("wr_rd = %b",dut_vif.wr_en);
		//$display("wr_rd = %h",dut_vif.W_data);
		//drive_strt_glch(req);

		drive_item(req);

		seq_item_port.item_done(req);
		ev1.trigger();
	end
	
	endtask 
	task drive_item(input seq_item_tr req);
		begin
		dut_vif.RST = req.rst;
		dut_vif.RX_IN = req.ser_in;
		dut_vif.PAR_EN= req.parity_enable;
		dut_vif.PAR_TYP = req.parity_type;
///////////////////////////////////////////////
if(dut_vif.PAR_EN) begin
			
			for(int i=0;i<10;i++) begin
				@(negedge dut_vif.clk_tr);
				dut_vif.RX_IN = req.data_with_parity[i];	
				dut_vif.data[i] = req.data_with_parity[i];		 
			end
		end
		else begin		 
			for(int i=0;i<9;i++) begin
				@(negedge dut_vif.clk_tr);
				dut_vif.RX_IN = req.data_without_parity[i];  	
				dut_vif.data[i] = req.data_without_parity[i];			
			end
		end

///////////////////////////////////////////////
	end
	@(negedge dut_vif.clk_tr);
	dut_vif.RX_IN = 1'b1;//req.ser_in;//
	endtask : drive_item

	task drive_strt_glch(input seq_item_tr req);
		begin 
		//dut_vif.Prescale = 5'b10000;
		// dut_vif.RST = 1'b0;
		// @(negedge dut_vif.CLK);
		//dut_vif.RST = 1'b1;
		dut_vif.RX_IN = 1'b1;
		//dut_vif.ser_in = req.RX_IN;
		@(negedge dut_vif.CLK);
		dut_vif.RX_IN = 1'b0;
		//dut_vif.ser_in = req.RX_IN;
		@(negedge dut_vif.CLK) ;
		dut_vif.RX_IN = 1'b1;
		//dut_vif.ser_in = req.RX_IN;
		//@(negedge dut_vif.clk_tr);
	end
    endtask

endclass