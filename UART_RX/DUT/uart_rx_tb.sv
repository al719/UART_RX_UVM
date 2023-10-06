`timescale 1ns/1ps

//////////////////////////////////////////////////////////
///////////////////////  class declaration ///////////////
//////////////////////////////////////////////////////////
class transaction;
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
	//bit parity_type,parity_enable;
	//bit[0:1] flag;
	constraint rst_ {
		rst dist {0:=5 , 1 := 95};
	}
	constraint data_ {
		if(parity_enable) {
			if(parity_type) {	
				(ser_in == 0) -> data_with_parity inside {10'h2ce , 10'h3d1};
				}
			else {
				(ser_in == 0) -> data_with_parity inside {10'h3ce , 10'h2d1};
				}
			}
		else {
			   (ser_in == 0) -> data_without_parity inside {9'h1ce , 9'h1d1};
				
			}
			solve ser_in before data_with_parity;
			solve ser_in before data_without_parity;
	}

	constraint parity {
		parity_enable dist {0:= 50 , 1:=50};
		parity_type dist {[0:1]:/100};
	}

	covergroup g1;
		data_ : coverpoint data
		{
			bins data_bin1[2] = {8'hce , 8'hd1};
			bins data_max = {8'hff};
			bins data_min = {8'h00};
		}
		parity_typ : coverpoint parity_type {
		 bins even_type = {0};
		 bins odd_type = {1};
		}
		parity_en : coverpoint parity_enable {
		 bins frame_with_parity = {1};
		 bins frame_without_parity = {0};
		}
		rx : coverpoint ser_in {
		 bins glitch = (1=>0=>1);
		 bins rx0 = {0};
		 bins rx1 = {1};
		 bins rx1_0 = (1=>0);
		 bins rx0_1 = (0=>1);
		}
		rd : cross rx , data_
		{
			bins data0_rx01 = binsof(data_.data_bin1[0])&&binsof(rx.rx1_0);
			bins data0_rx10 = binsof(data_.data_bin1[0])&&binsof(rx.rx0_1);
			bins data1_rx01 = binsof(data_.data_bin1[1])&&binsof(rx.rx1_0);
			bins data1_rx10 = binsof(data_.data_bin1[1])&&binsof(rx.rx0_1);
			bins datamax_rx01 = binsof(data_.data_max)&&binsof(rx.rx1_0);
			bins datamin_rx10 = binsof(data_.data_min)&&binsof(rx.rx0_1);
			bins datamax_rx10 = binsof(data_.data_max)&&binsof(rx.rx0_1);
			bins datamin_rx01 = binsof(data_.data_min)&&binsof(rx.rx1_0);
			//bins misc = default; 
		}
		vd : coverpoint data_valid
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
		pd : cross parity_typ , data_
		{
			bins data0_type0 = binsof(data_.data_bin1[0])&&binsof(parity_typ.even_type);
			bins data0_type1 = binsof(data_.data_bin1[0])&&binsof(parity_typ.odd_type);
			bins data1_type0 = binsof(data_.data_bin1[1])&&binsof(parity_typ.even_type);
			bins data1_type1 = binsof(data_.data_bin1[1])&&binsof(parity_typ.odd_type);
			//bins misc = default;
		}
		out_data : coverpoint P_data
		{
			bins data_out[2] = {8'hce ,8'hd1};
			bins min = {8'h00};
			bins max = {8'hff};
			bins data0_1 = (8'hce => 8'hd1);
			bins data1_0 = (8'hd1 => 8'hce);
			bins data0_0 = (8'hce => 8'hce);
			bins data1_1 = (8'hd1 => 8'hd1);
		}

		pvd : cross out_data , vd 
		{
			bins data0_v = binsof(out_data.data_out[0])  && binsof(vd.vnv);
			bins data0_nv = binsof(out_data.data_out[0])  && binsof(vd.notvalid);
			bins data1_v = binsof(out_data.data_out[1])  && binsof(vd.vnv);
			bins data1_nv =   binsof(out_data.data_out[1]) && binsof(vd.notvalid);
			bins data0_0_vnv = binsof(out_data.data0_0) && binsof(vd.vnv);
			bins data1_1_vnv = binsof(out_data.data1_1) && binsof(vd.vnv); 
			bins data0_1_vnv = binsof(out_data.data0_1) && binsof(vd.vnv);
			bins data1_0_vnv = binsof(out_data.data1_0) && binsof(vd.vnv);
		}
		dd : cross out_data , data_ 
		{
			bins eq_data0 = binsof(out_data.data_out[0]) && binsof(data_.data_bin1[0]);
			bins eq_data1 = binsof(out_data.data_out[1]) && binsof(data_.data_bin1[1]);
			bins eq_datamin = binsof(out_data.min) && binsof(data_.data_min);
			bins eq_datamax = binsof(out_data.max) && binsof(data_.data_max);
		}
		vrxdout : cross  vd , rx ,out_data
		{
			bins data0_0v_rx1_0 = binsof(out_data.data0_0) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data0_0) &&
			bins data1_1v_rx1_0 = binsof(out_data.data1_1) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data1_1) &&
			bins data0_1v_rx1_0 = binsof(out_data.data0_1) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data0_1) &&
			bins data1_0v_rx1_0 = binsof(out_data.data1_0) && binsof(vd.valid) && binsof(rx.rx1_0);//binsof(out_data.data1_0) &&
		}
	endgroup
	function new();
		g1 = new();
	endfunction 
	 
endclass

//////////////////////////////////////////////////////////
module UART_TX_TB(UART_interface.Test uart_if);

bit clk_tr;
//reg[9:0] data;
transaction uart;

initial begin
	$dumpfile("uart_rx.vcd");
	$dumpvars;
	uart = new();
	uart.g1.start();

	clk_tr = 0;
	
	//uart.flag = 2'b01;
	uart_if.Prescale = 5'b10000;
	uart_if.RST = 1'b0;

	@(negedge uart_if.CLK);
	uart_if.RST = 1'b1;
	uart_if.RX_IN = 1'b1;
	uart.ser_in = uart_if.RX_IN;
	@(negedge uart_if.CLK);
	uart_if.RX_IN = 1'b0;
	uart.ser_in = uart_if.RX_IN;
	@(negedge uart_if.CLK) ;
	uart_if.RX_IN = 1'b1;
	uart.ser_in = uart_if.RX_IN;
	repeat(2) @(negedge clk_tr);
	////////////////////////////////////////////////
	for (int i = 0; i < 5000; i++) begin
		@(negedge clk_tr);
		assert(uart.randomize());
		uart_if.RST = uart.rst;
		uart_if.RX_IN = uart.ser_in;
		uart_if.PAR_EN= uart.parity_enable;
		uart_if.PAR_TYP = uart.parity_type;
		// uart.parity_enable = uart_if.PAR_EN;
		// uart.parity_type = uart_if.PAR_TYP;
		if(uart_if.PAR_EN) begin
			
			for(int i=0;i<10;i++) begin
				@(negedge clk_tr);
				//assert(uart.randomize());
				//uart_if.RX_IN = uart.ser_in;
				//uart.data[i]= uart_if.RX_IN;
				
				uart.data[i] = uart.data_with_parity[i];
				uart_if.RX_IN = uart.data_with_parity[i];
				// if(i == 9) begin 
				// 		repeat(8) begin 
				// 		   @(posedge uart_if.CLK);
				// 		  	//uart.data_valid = uart_if.data_valid;
				// 		  	uart.ser_in = uart.data_with_parity[9];
						  	
				// 	  end 
				// end				 
			end
			//uart.ser_in = uart_if.RX_IN;
			uart.P_data = uart_if.P_DATA;
		end
		else begin
			 
			for(int i=0;i<9;i++) begin
				@(negedge clk_tr);
				//assert(uart.randomize());
				//uart_if.RX_IN = uart.ser_in;
				//uart.data[i]= uart_if.RX_IN;
				//uart.ser_in = uart.data_without_parity[i];
				uart.data[i] = uart.data_without_parity[i];
				uart_if.RX_IN = uart.data_without_parity[i];
				// if(i == 8) begin 
				// 	   repeat(8) begin 
				// 	   	@(posedge uart_if.CLK);
				// 	  	uart.ser_in = uart.data_without_parity[8];
					  	
				// 	  end 
				// end  				
			end
			//uart.ser_in = uart_if.RX_IN;
			uart.P_data = uart_if.P_DATA;
		end
	end
	
	$stop();
end
always @(posedge uart_if.CLK) begin 
	uart.data_valid = uart_if.data_valid;
	uart.ser_in = uart_if.RX_IN;
end 
always @(posedge uart_if.CLK) begin 
	uart.g1.sample();
end 
always #(uart_if.CLOCK_PERIOD_TX/2) clk_tr = ~clk_tr;
endmodule