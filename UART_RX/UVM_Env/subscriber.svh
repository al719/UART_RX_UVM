import uvm_pkg::*;
`include "uvm_macros.svh"
import tr::seq_item_tr;
class my_subscriber extends uvm_subscriber #(seq_item_tr); /* base class*/;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
seq_item_tr cvg_collected;

//uvm_analysis_imp #(seq_item_tr,my_subscriber) item_collected_export;
/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(my_subscriber)



/*-------------------------------------------------------------------------------
-- covergroups
-------------------------------------------------------------------------------*/
covergroup g1;
		data_ : coverpoint cvg_collected.data//data
		{
			bins data_bin1[2] = {8'hce , 8'hd1};
			//bins data_max = {8'hff};
			//bins data_min = {8'h00};
		}
		parity_typ : coverpoint cvg_collected.parity_type {
		 bins even_type = {0};
		 bins odd_type = {1};
		}
		parity_en : coverpoint cvg_collected.parity_enable {
		 bins frame_with_parity = {1};
		 bins frame_without_parity = {0};
		}
		// rx : coverpoint cvg_collected.ser_in {
		//  bins glitch = (1=>0=>1);
		//  bins rx0 = {0};
		//  bins rx1 = {1};
		//  bins rx1_0 = (1=>0);
		//  bins rx0_1 = (0=>1);
		// }
		// rd : cross rx , data_
		// {
		// 	bins data0_rx01 = binsof(data_.data_bin1[0])&&binsof(rx.rx1_0);
		// 	bins data0_rx10 = binsof(data_.data_bin1[0])&&binsof(rx.rx0_1);
		// 	bins data1_rx01 = binsof(data_.data_bin1[1])&&binsof(rx.rx1_0);
		// 	bins data1_rx10 = binsof(data_.data_bin1[1])&&binsof(rx.rx0_1);
		// 	bins datamax_rx01 = binsof(data_.data_max)&&binsof(rx.rx1_0);
		// 	bins datamin_rx10 = binsof(data_.data_min)&&binsof(rx.rx0_1);
		// 	bins datamax_rx10 = binsof(data_.data_max)&&binsof(rx.rx0_1);
		// 	bins datamin_rx01 = binsof(data_.data_min)&&binsof(rx.rx1_0);
		// 	//bins misc = default; 
		// }
		vd : coverpoint cvg_collected.data_valid
		{
		  bins valid = {1};
		  bins notvalid = {0};
		  bins v_nv = (1=>0);
		  bins nv_v = (0=>1);
		  bins vnv = (0=>1=>0);
		}
		// chk : cross vd , rx {
		// 	bins stop_correct = binsof(vd.vnv)  && binsof(rx.rx1);
		// 	bins stop_error = binsof(vd.vnv) && binsof(rx.rx0);
		// }
		
		out_data : coverpoint cvg_collected.P_data
		{
			bins data_out[2] = {8'hce ,8'hd1};
			bins min = {8'h00};
			bins max = {8'hff};
			bins data0_1 = (8'hce => 8'hd1);
			bins data1_0 = (8'hd1 => 8'hce);
			bins data0_0 = (8'hce => 8'hce);
			bins data1_1 = (8'hd1 => 8'hd1);
		}

		pd : cross parity_typ , out_data
		{
			bins data0_type0 = binsof(out_data.data_out[0])&&binsof(parity_typ.even_type);
			bins data0_type1 = binsof(out_data.data_out[0])&&binsof(parity_typ.odd_type);
			bins data1_type0 = binsof(out_data.data_out[1])&&binsof(parity_typ.even_type);
			bins data1_type1 = binsof(out_data.data_out[1])&&binsof(parity_typ.odd_type);
			//bins misc = default;
		}

		pvd : cross out_data , vd 
		{
			bins data0_v = binsof(out_data.data_out[0])  && binsof(vd.vnv);
			bins data0_nv = binsof(out_data.data_out[0])  && binsof(vd.notvalid); // error
			bins data1_v = binsof(out_data.data_out[1])  && binsof(vd.vnv);
			bins data1_nv =   binsof(out_data.data_out[1]) && binsof(vd.notvalid); // error 
			bins data0_0_vnv = binsof(out_data.data0_0) && binsof(vd.vnv);
			bins data1_1_vnv = binsof(out_data.data1_1) && binsof(vd.vnv); 
			bins data0_1_vnv = binsof(out_data.data0_1) && binsof(vd.vnv);
			bins data1_0_vnv = binsof(out_data.data1_0) && binsof(vd.vnv);
		}
		dd : cross out_data , data_ 
		{
			bins eq_data0 = binsof(out_data.data_out[0]) && binsof(data_.data_bin1[0]);
			bins eq_data1 = binsof(out_data.data_out[1]) && binsof(data_.data_bin1[1]);
			//bins eq_datamin = binsof(out_data.min) && binsof(data_.data_min);
			//bins eq_datamax = binsof(out_data.max) && binsof(data_.data_max);
		}
		// vrxdout : cross  vd , rx ,out_data
		// {
		// 	bins data0_0v_rx1_0 = binsof(out_data.data0_0) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data0_0) &&
		// 	bins data1_1v_rx1_0 = binsof(out_data.data1_1) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data1_1) &&
		// 	bins data0_1v_rx1_0 = binsof(out_data.data0_1) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data0_1) &&
		// 	bins data1_0v_rx1_0 = binsof(out_data.data1_0) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data1_0) &&
		// }
	endgroup

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "subscriber", uvm_component parent=null);
		super.new(name, parent);
		g1 = new();
		cvg_collected = new();
		//item_collected_export = new("item_collected_export",this);
	endfunction : new

	virtual function void write(seq_item_tr t);
		cvg_collected = t;
		g1.sample();
	endfunction

endclass : my_subscriber