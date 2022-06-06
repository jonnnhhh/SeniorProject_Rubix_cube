`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2021 04:31:44 PM
// Design Name: 
// Module Name: TestBench
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
//////////////////////////////////////////////////////////////////////////////////
module TestBench;
reg I_sys_clk_tb;
reg I_on_board_reset_n_tb;
reg I_rx_serial_data_tb;

wire o_servo1_directional_output_tb;
wire o_servo2_directional_output_tb;
wire o_servo3_directional_output_tb;
wire o_servo4_directional_output_tb;
wire o_servo1_gripping_output_tb;
wire o_servo2_gripping_output_tb;
wire o_servo3_gripping_output_tb;
wire o_servo4_gripping_output_tb;

Top_level uut
(
.I_sys_clk_top                       (I_sys_clk_tb),
.I_on_board_reset_n                  (I_on_board_reset_n_tb),
.I_rx_serial_data                    (I_rx_serial_data_tb),

.o_servo1_directional_output_top     (o_servo1_directional_output_tb),
.o_servo2_directional_output_top     (o_servo2_directional_output_tb),
.o_servo3_directional_output_top     (o_servo3_directional_output_tb),
.o_servo4_directional_output_top     (o_servo4_directional_output_tb),
.o_servo1_gripping_output_top        (o_servo1_gripping_output_tb),
.o_servo2_gripping_output_top        (o_servo2_gripping_output_tb),
.o_servo3_gripping_output_top        (o_servo3_gripping_output_tb),
.o_servo4_gripping_output_top        (o_servo4_gripping_output_tb)
);

assign baudtick = uut.uart.rx_I_baud_tick;

initial 

I_sys_clk_tb = 1;

always #5 I_sys_clk_tb =~I_sys_clk_tb;

initial begin
I_rx_serial_data_tb = 1;
I_on_board_reset_n_tb = 1;

repeat(5) @(posedge I_sys_clk_tb);

I_on_board_reset_n_tb = 0;
//start bit
@(posedge baudtick);
I_rx_serial_data_tb = 0;

//01100010 scanner start button, hex:62
repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

//stop bit
repeat(16)@(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(50)@(posedge I_sys_clk_tb);

//start bit
@(posedge baudtick);
I_rx_serial_data_tb = 0;

//01100001 left movement, hex:61
repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

//stop bit
repeat(16)@(posedge baudtick);
I_rx_serial_data_tb = 1;

end

endmodule
