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
//      2 issues:
//first, issue with possibly data sync
//(when first incoming bit is 1, data sync waits to be zero which causes delay in counting)
//second, shifting does not stop and eventually turns all to zero(unless that is wanted?)
//////////////////////////////////////////////////////////////////////////////////
module TestBench;
localparam  BAUD_RATE = 9600;
realtime BAUD_RATE_DELAY = 1e9/BAUD_RATE;
reg I_sys_clk_tb;
//reg I_rst_button_tb;
//reg I_start_button_tb;
//reg I_rst_user_button_tb;
reg I_on_board_reset_n_tb;
// reg I_user_movement_leftRow_tb = 0;
// reg I_user_movement_rightRow_tb = 0;
// reg I_user_movement_topRow_tb = 0;
// reg I_user_movement_bottomRow_tb = 0;
reg I_rx_serial_data_tb;

wire [6:0] debug_led_tb;
// wire o_servo1_directional_output_tb;
// wire o_servo2_directional_output_tb;
// wire o_servo3_directional_output_tb;
// wire o_servo4_directional_output_tb;
// wire o_servo1_gripping_output_tb;
// wire o_servo2_gripping_output_tb;
// wire o_servo3_gripping_output_tb;
// wire o_servo4_gripping_output_tb;

Top_level uut
(
.I_sys_clk_top                  (I_sys_clk_tb),
//.I_rst_button_top               (I_rst_button_tb),
//.I_rst_user_button_top          (I_rst_user_button_tb),
//.I_start_button_top             (I_start_button_tb),
.I_on_board_reset_n                  (I_on_board_reset_n_tb),
//.I_user_movement_leftRow_top    (I_user_movement_leftRow_tb),
//.I_user_movement_rightRow_top   (I_user_movement_rightRow_tb),
//.I_user_movement_topRow_top     (I_user_movement_topRow_tb),
//.I_user_movement_bottomRow_top  (I_user_movement_bottomRow_tb),
.I_rx_serial_data   (I_rx_serial_data_tb),

// .o_servo1_directional_output_top(o_servo1_directional_output_tb),
// .o_servo2_directional_output_top(o_servo2_directional_output_tb),
// .o_servo3_directional_output_top(o_servo3_directional_output_tb),
// .o_servo4_directional_output_top(o_servo4_directional_output_tb),
// .o_servo1_gripping_output_top   (o_servo1_gripping_output_tb),
// .o_servo2_gripping_output_top   (o_servo2_gripping_output_tb),
// .o_servo3_gripping_output_top   (o_servo3_gripping_output_tb),
// .o_servo4_gripping_output_top   (o_servo4_gripping_output_tb),
.debug_led                      (debug_led_tb)
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

//01110111 top bottom
repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 0;

repeat(16) @(posedge baudtick);
I_rx_serial_data_tb = 1;

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
#(BAUD_RATE_DELAY);

//start bit

// I_rx_serial_data_tb = 0;

// // top bottom
// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 1;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 0;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 0;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 1;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 1;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 0;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 0;

// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 1;

// //stop bit
// #(BAUD_RATE_DELAY);
// I_rx_serial_data_tb = 1;

// #(BAUD_RATE_DELAY);



//---------------------------------
// I_rst_button_tb      = 1;
// I_rst_user_button_tb = 1;
// I_start_button_tb    = 0;

// repeat(5) @(posedge I_sys_clk_tb);

// I_rst_button_tb      = 0;
// I_rst_user_button_tb = 0;

//---------------------------------
// @(posedge I_sys_clk_tb);
// I_start_button_tb = 1;
// @(posedge I_sys_clk_tb);
// I_start_button_tb = 0;

//---------------------------------
// #1000
// //USER
//     I_rst_user_button_tb = 0;
//     I_user_movement_leftRow_tb = 1;
//     I_user_movement_rightRow_tb = 1;
//     I_user_movement_bottomRow_tb = 1;
// #1600
// I_user_movement_leftRow_tb = 0;
// I_user_movement_rightRow_tb = 0;
// I_user_movement_bottomRow_tb = 0;

// wait(uut.cube_scanner.scanner_done);
// repeat(20) @(posedge I_sys_clk_tb);

// I_user_movement_leftRow_tb = 1;
// @(posedge I_sys_clk_tb);
// I_user_movement_leftRow_tb = 0;
// repeat(1) @(posedge I_sys_clk_tb);
// wait(uut.user_controller.o_write_ready);
// repeat(2) @(posedge I_sys_clk_tb);

// I_user_movement_rightRow_tb = 1;
// @(posedge I_sys_clk_tb);
// I_user_movement_rightRow_tb = 0;
// repeat(1) @(posedge I_sys_clk_tb);
// wait(uut.user_controller.o_write_ready);
// repeat(2) @(posedge I_sys_clk_tb);

// I_user_movement_topRow_tb = 1;
// @(posedge I_sys_clk_tb);
// I_user_movement_topRow_tb = 0;
// repeat(1) @(posedge I_sys_clk_tb);
// wait(uut.user_controller.o_write_ready);
// repeat(2) @(posedge I_sys_clk_tb);

// I_user_movement_bottomRow_tb = 1;
// @(posedge I_sys_clk_tb);
// I_user_movement_bottomRow_tb = 0;
// repeat(1) @(posedge I_sys_clk_tb);
// wait(uut.user_controller.o_write_ready);

// repeat(10) @(posedge I_sys_clk_tb);
// I_start_button_tb = 1;
// @(posedge I_sys_clk_tb);
// I_start_button_tb = 0;

end

task automatic uart_send_byte(
    input [7:0]         data
    // ref                 clock,
    // ref                 serial_data,
    // input integer       BAUD_RATE
);
    // realtime BAUD_RATE_DELAY = 1e9/BAUD_RATE;
begin

    I_rx_serial_data_tb = 1;
    repeat(20) @(posedge I_sys_clk_tb);

    I_rx_serial_data_tb = 0; // start bit
    #(BAUD_RATE_DELAY);

    for (integer i = 0; i <= 7; i = i+1) begin
        I_rx_serial_data_tb = data[i];
        #(BAUD_RATE_DELAY);
    end

    #(1) I_rx_serial_data_tb = 1; // Stop bit

    #(BAUD_RATE_DELAY);

end

endtask

endmodule
