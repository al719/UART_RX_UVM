`timescale 1ns/1ps
interface UART_interface 
	#(parameter prescalar_width = 4,
	  parameter scaler_width = 5,
	  parameter DATA_WIDTH = 8,
	  parameter bit_count_width = 3,
	  parameter CLOCK_PERIOD = 5,
	  parameter CLOCK_PERIOD_TX = CLOCK_PERIOD * 16
	  ) (input bit CLK);
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////// ports  //////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////	

logic RX_IN;
logic[scaler_width-1:0] Prescale;
logic PAR_EN;
logic PAR_TYP;
logic RST;
logic[DATA_WIDTH-1:0] P_DATA;
logic[DATA_WIDTH-1:0] data;
logic data_valid;
bit clk_tr;
always #(CLOCK_PERIOD_TX/2) clk_tr = ~clk_tr;

modport Design (input RX_IN, Prescale, PAR_EN, PAR_TYP, CLK, RST,output  P_DATA , data_valid);
//modport Test (input P_DATA,data_valid, CLK,output RX_IN, Prescale, PAR_EN, PAR_TYP,RST);
//modport asert(input CLK , RST ,RX_IN ,Prescale , PAR_EN ,data_valid,P_DATA);
////////////////////////////////////////////////////////////////////////////////////////////////

endinterface 