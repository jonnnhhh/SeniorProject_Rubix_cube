`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Gonzalez
// 
// Create Date: 04/01/2022 11:23:05 AM
// Design Name: 
// Module Name: Wrapper_UART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Wrapper_UART #(parameter BAUD_RATE = 9600)
(
input        I_sys_clk,
input        I_rst,
input        I_enable,
input        I_rx_serial_data,

output [7:0] o_read_data,
output       o_read_data_valid
);

wire wire_tick;
wire baud_rate_gen_I_sys_clk;
wire baud_rate_gen_I_rst;
wire baud_rate_gen_I_enable;
wire baud_rate_gen_O_BaudRate_generator_tick;

//------- UART BaudGenerator --------------------------------------------

UART_BAUDRATE_GEN  #(.BAUD_RATE(BAUD_RATE))
M1 (
    .I_sys_clk                (baud_rate_gen_I_sys_clk),
    .I_rst                    (baud_rate_gen_I_rst),
    .I_enable                 (baud_rate_gen_I_enable),
    .O_BaudRate_generator_tick(baud_rate_gen_O_BaudRate_generator_tick)
);

//------- UART Rx -------------------------------------------------------

wire       rx_I_sys_clk;
wire       rx_I_rst;
wire       rx_I_rx_serial_data;
wire       rx_I_baud_tick;
wire [7:0] rx_o_read_data;
wire       rx_o_read_data_valid;

UART_RX M2
(
    .I_sys_clk        (rx_I_sys_clk),
    .I_rst            (rx_I_rst),
    .I_rx_serial_data (rx_I_rx_serial_data),
    .I_baud_tick      (rx_I_baud_tick),
    .o_read_data      (rx_o_read_data),
    .o_read_data_valid(rx_o_read_data_valid)
);

//------- UART Wrapper Assignments ---------------------------------------

assign baud_rate_gen_I_sys_clk = I_sys_clk;
assign baud_rate_gen_I_rst     = I_rst;
assign baud_rate_gen_I_enable  = 1;

assign rx_I_sys_clk            = I_sys_clk;
assign rx_I_rst                = I_rst;
assign rx_I_rx_serial_data     = I_rx_serial_data;
assign rx_I_baud_tick          = baud_rate_gen_O_BaudRate_generator_tick;
assign o_read_data             = rx_o_read_data;
assign o_read_data_valid       = rx_o_read_data_valid;

//-------------------------------------------------------------------------
endmodule
