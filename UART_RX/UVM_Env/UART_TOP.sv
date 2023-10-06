`timescale 1ns/1ps
`include "uvm_macros.svh"
`include "tst.svh"
module UART_TOP();

import uvm_pkg::*;
import tst_pkg::*;

bit clk;

UART_interface uart_if(clk);
//////////////////////////////// clock generation
initial begin
	clk = 0;
	forever #2.5 clk = ~clk; 
end

initial begin
	uart_if.Prescale = 5'b10000;
	run_test("tst");
end

initial begin
	uart_if.RST = 1;
	#(uart_if.CLOCK_PERIOD);
	uart_if.RST = 0;
	#(uart_if.CLOCK_PERIOD);
	uart_if.RST = 1;
	
end

initial begin
	uvm_config_db#(virtual UART_interface)::set(null, "*", "dut_vif", uart_if);
	$dumpfile("test.vcd");
	$dumpvars(0,UART_TOP);
end
initial begin
	#1000000;

	$stop();
end


UART_RX 	   DUT(uart_if.Design);
//UART_TX_TB	   Driver(uart_if);
//bind UART_RX UART_AS asrt(uart_if);


endmodule