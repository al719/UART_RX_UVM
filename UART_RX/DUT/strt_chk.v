module strt_chk(
				//input clk,
				//input rst,
				input wire sampled_bit,
				input wire strt_chk_en,
				output wire strt_err
				);

assign strt_err = (strt_chk_en) ? (sampled_bit^ 1'b0) : 1'b0;
// always @(posedge clk or negedge rst) begin
// 	if(!rst)
// 		strt_err <= 1'b0;
// 	else if(strt_chk_en)
// 		strt_err <= sampled_bit ^ 1'b0;
// 	else
// 		strt_err<= 1'b0;
// end
endmodule 