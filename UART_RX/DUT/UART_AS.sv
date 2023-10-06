module UART_AS(UART_interface.asert asrt);

reg[asrt.prescalar_width-1:0] count;
always @(posedge asrt.CLK) begin
	if(!asrt.RST) begin
		count <= 0;
	end else begin
		count<= count + 1;
	end
end

property consecutive ;
@(posedge asrt.CLK) $rose(asrt.data_valid) && (asrt.P_DATA == 8'hce || asrt.P_DATA == 8'hd1) |-> $fell(asrt.RX_IN);
endproperty

conseq_as :assert property(consecutive);
conseq_cv :cover property(consecutive);

property valid ;
@(posedge asrt.CLK)  (asrt.P_DATA == 8'hce || asrt.P_DATA == 8'hd1) |-> (asrt.data_valid[->1]);
endproperty

valid_as :assert property(valid);
valid_cv :cover property(valid);

property conseq2 ; // check correct stop and consequence of frames
@(posedge asrt.CLK)  (asrt.P_DATA == 8'hce || asrt.P_DATA == 8'hd1) |-> (asrt.RX_IN throughout asrt.data_valid[->1] );
endproperty

conseq2_as :assert property(conseq2);
conseq2_cv :cover property(conseq2);

// property start ; // check correct stop and consequence of frames
// @(posedge asrt.CLK)  asrt.RX_IN |-> !asrt.RX_IN;
// endproperty

// strt_as :assert property(start);
// strt_cv :cover property(start);
endmodule 