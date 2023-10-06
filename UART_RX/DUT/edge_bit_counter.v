module edge_bit_counter #(parameter prescalar_width = 4, parameter bit_width_count = 3)
						(
						input wire clk,
						input wire rst,
						input wire enable,
						input wire disable_bit_count,
						output reg[bit_width_count-1:0] bit_count,
						output reg[prescalar_width-1:0] edge_count
						);
wire cnt;
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		//bit_count <= 3'b000;
		edge_count<= {prescalar_width{1'b0}};
	end
	else if(enable) begin
		edge_count <= edge_count + 1;
	end
end
always @(posedge clk or negedge rst) begin
	if(!rst)
		bit_count <= 4'b0000;
	else if(cnt && !disable_bit_count)
		bit_count <= bit_count + 1;
	else if(disable_bit_count)
		bit_count <= 4'b0000;
end
assign cnt = (edge_count == {prescalar_width{1'b1}});
endmodule 