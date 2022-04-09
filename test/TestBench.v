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
// 
//////////////////////////////////////////////////////////////////////////////////
module TestBench;
reg I_sys_clk_tb;
reg I_rst_button_tb;
reg I_start_button_tb;
reg I_rst_user_button_tb;
//reg I_sys_rst_tb;
reg I_user_movement_leftRow_tb = 0; 
reg I_user_movement_rightRow_tb = 0;
reg I_user_movement_topRow_tb = 0;
reg I_user_movement_bottomRow_tb = 0;
//reg I_rx_serial_data_wrapper_tb;

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
.I_sys_clk_top                  (I_sys_clk_tb),
.I_rst_button_top               (I_rst_button_tb),
.I_rst_user_button_top          (I_rst_user_button_tb),
.I_start_button_top             (I_start_button_tb),
//.I_sys_rst_top                  (I_sys_rst_tb),
.I_user_movement_leftRow_top    (I_user_movement_leftRow_tb),
.I_user_movement_rightRow_top   (I_user_movement_rightRow_tb),
.I_user_movement_topRow_top     (I_user_movement_topRow_tb),
.I_user_movement_bottomRow_top  (I_user_movement_bottomRow_tb),
//.I_rx_serial_data_wrapper_top   (I_rx_serial_data_wrapper_tb),

.o_servo1_directional_output_top(o_servo1_directional_output_tb),
.o_servo2_directional_output_top(o_servo2_directional_output_tb),
.o_servo3_directional_output_top(o_servo3_directional_output_tb),
.o_servo4_directional_output_top(o_servo4_directional_output_tb),
.o_servo1_gripping_output_top   (o_servo1_gripping_output_tb),
.o_servo2_gripping_output_top   (o_servo2_gripping_output_tb),
.o_servo3_gripping_output_top   (o_servo3_gripping_output_tb),
.o_servo4_gripping_output_top   (o_servo3_gripping_output_tb)
);

initial 

I_sys_clk_tb = 1;

always #5 I_sys_clk_tb =~I_sys_clk_tb;

initial begin

I_rst_button_tb = 1;
//---------------------------------
//USER
I_rst_user_button_tb = 1;

//---------------------------------

I_start_button_tb = 0;

//---------------------------------
//USER
//I_user_movement_leftRow_tb = 0;

//---------------------------------

#1
I_rst_button_tb = 0;

//---------------------------------
//USER
I_rst_user_button_tb = 0;

//---------------------------------

#1
I_rst_button_tb = 1;

//---------------------------------
//USER
I_rst_user_button_tb = 1;

//---------------------------------

#5
I_rst_button_tb = 0;
I_start_button_tb = 1;
//repeat(5) @(posedge I_sys_clk_tb);
#1500
I_start_button_tb = 0;

//---------------------------------
#1000
//USER
    I_rst_user_button_tb = 0;
    I_user_movement_leftRow_tb = 1; 
    I_user_movement_rightRow_tb = 1;
    I_user_movement_bottomRow_tb = 1;
#1600
I_user_movement_leftRow_tb = 0;
I_user_movement_rightRow_tb = 0;
I_user_movement_bottomRow_tb = 0;
wait(uut.M3.scanner_done);
#20

I_user_movement_leftRow_tb = 1;
#27000
I_user_movement_leftRow_tb = 0;
I_user_movement_rightRow_tb = 1;
#22000
I_user_movement_rightRow_tb = 0;
I_user_movement_topRow_tb = 1;
#22000
I_user_movement_topRow_tb = 0;
I_user_movement_bottomRow_tb = 1;
#22000
I_user_movement_bottomRow_tb = 0;
#22000
I_start_button_tb = 1;

end
endmodule
