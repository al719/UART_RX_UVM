module UART_RX (UART_interface.Design uart_if);

wire enable,data_sample_enable,sampled_bit;
wire[uart_if.bit_count_width-1:0] bit_cnt;
wire[uart_if.prescalar_width-1:0] edge_cnt;
wire par_err, strt_glitch,stp_err;
wire parity_check_en,start_check_en,stop_check_en;
wire deserial_enable;
wire parity_bit;
wire disable_bit_cnt;
wire dis_err;
edge_bit_counter #(.prescalar_width(uart_if.prescalar_width),
						   .bit_width_count(uart_if.bit_count_width))
				 EDGE_U0 (
						.clk(uart_if.CLK),
						.rst(uart_if.RST),
						.enable(enable), // from FSM
						.bit_count(bit_cnt),//to FSM
						.edge_count(edge_cnt),// to sampling
						.disable_bit_count(disable_bit_cnt)
						);
data_sampling 	#(.prescalar_WIDTH(uart_if.prescalar_width),
				  .scaler(uart_if.scaler_width))		
				
				sampling (
						.clk(uart_if.CLK),
						.rst(uart_if.RST),
						.edge_count(edge_cnt),
						.data_sample_en(data_sample_enable), // from FSM
						.prescalar(uart_if.Prescale),
						.RX_IN(uart_if.RX_IN),
						.sampled_bit(sampled_bit) //to checker blocks + deserial
						);

FSM_RX #(.bit_count_width(uart_if.bit_count_width),
		 .edge_cnt_width(uart_if.prescalar_width),
		 .prescale_width (uart_if.scaler_width)
		 )

				controller (
					.RX_IN(uart_if.RX_IN),
					.clk(uart_if.CLK),
					.rst(uart_if.RST),
					.parity_enable(uart_if.PAR_EN),
					.bit_cnt(bit_cnt),
					.parity_error(par_err),
					.start_glitch(strt_glitch),
					.stop_error(stp_err),
					.dat_samp_en(data_sample_enable),
					.enable(enable),
					.strt_chk_en(start_check_en),
					.stp_chk_en(stop_check_en),
					.par_chk_en(parity_check_en),
					.data_valid(uart_if.data_valid),
					.des_en(deserial_enable),
					.edge_cnt(edge_cnt),
					.disable_bit_count(disable_bit_cnt),
					.disable_parity_err(dis_err),
					.Prescalar(uart_if.Prescale)
					);
deserializer #(.edge_width(uart_if.prescalar_width),.scaler_width(uart_if.scaler_width),.data_width(uart_if.DATA_WIDTH))
					deserial (
						.clk(uart_if.CLK),
						.rst(uart_if.RST),
						.parity_type(uart_if.PAR_TYP),
						.sampled_bit(sampled_bit),
						.des_en(deserial_enable),
						.P_data(uart_if.P_DATA),
						.parity(parity_bit), // to parity check block
						.edge_count(edge_cnt),
						.prescale(uart_if.Prescale)
						);

parity_chk par_checker(
						.rst(uart_if.RST),
						.clk(uart_if.CLK),
						.parity_bit(parity_bit),
						.par_chk_en(parity_check_en),
						.sampled_bit(sampled_bit),
						.par_err(par_err),
						.disable_err(dis_err)
						);

strt_chk start_checker(
						//.clk        (uart_if.CLK),
						//.rst        (uart_if.RST),
						.sampled_bit(sampled_bit),
						.strt_chk_en(start_check_en),
						.strt_err(strt_glitch)
						);

stp_chk stop_checker(
					//.clk        (uart_if.CLK),
					//.rst        (uart_if.RST),
					.sampled_bit(sampled_bit),
					.stp_chk_en(stop_check_en),
					.stp_chk_err(stp_err)
					);

endmodule 