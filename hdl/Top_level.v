`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2021 03:39:45 PM
// Design Name: 
// Module Name: Top_level
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
module Top_level
(
    input I_sys_clk_top,
    input I_rst_button_top,
    input I_rst_user_button_top,
    //input I_sys_rst_top,
    input I_start_button_top,
    input I_user_movement_leftRow_top,
    input I_user_movement_rightRow_top,
    input I_user_movement_topRow_top,
    input I_user_movement_bottomRow_top,
    //input I_rx_serial_data_wrapper_top,

    //output o_read_data_wrapper_top,

    output o_servo1_directional_output_top,
    output o_servo2_directional_output_top,
    output o_servo3_directional_output_top,
    output o_servo4_directional_output_top,
    output o_servo1_gripping_output_top,
    output o_servo2_gripping_output_top,
    output o_servo3_gripping_output_top,
    output o_servo4_gripping_output_top
);
//----------------------------------------------------
//might need to change these wires and condense it down to [6:0] and added assign for each bit position

wire o_servo1_directional_top_user;
wire o_servo2_directional_top_user;
wire o_servo3_directional_top_user;
wire o_servo4_directional_top_user;

wire o_servo1_gripping_top_user;
wire o_servo2_gripping_top_user;
wire o_servo3_gripping_top_user;
wire o_servo4_gripping_top_user;

//----------------------------------------------------
wire o_servo1_directional_top_scanning;
wire o_servo2_directional_top_scanning;
wire o_servo3_directional_top_scanning;
wire o_servo4_directional_top_scanning;

wire o_servo1_gripping_top_scanning;
wire o_servo2_gripping_top_scanning;
wire o_servo3_gripping_top_scanning;
wire o_servo4_gripping_top_scanning;
//----------------------------------------------------
wire direction1_movement_done_user;
wire direction2_movement_done_user;
wire direction3_movement_done_user;
wire direction4_movement_done_user;

wire gripping1_movement_done_user;
wire gripping2_movement_done_user;
wire gripping3_movement_done_user;
wire gripping4_movement_done_user;
//----------------------------------------------------
wire direction1_movement_done_scanning;
wire direction2_movement_done_scanning;
wire direction3_movement_done_scanning;
wire direction4_movement_done_scanning = 0;

wire gripping1_movement_done_scanning;
wire gripping2_movement_done_scanning;
wire gripping3_movement_done_scanning;
wire gripping4_movement_done_scanning = 0;
//----------------------------------------------------
wire o_servo1_directional_top;
wire o_servo2_directional_top;
wire o_servo3_directional_top;
wire o_servo4_directional_top;
wire o_servo1_gripping_top;
wire o_servo2_gripping_top;
wire o_servo3_gripping_top;
wire o_servo4_gripping_top;
wire direction1_movement_done;
wire direction2_movement_done;
wire direction3_movement_done;
wire direction4_movement_done;
wire gripping1_movement_done;
wire gripping2_movement_done;
wire gripping3_movement_done;
wire gripping4_movement_done;
wire w_scanner_clk_posedge_detector;
wire mux_select;
//----------------------------------------------------
// wire       I_uart_sys_clk;
// wire       I_uart_rst;
// wire       I_uart_enable;
// wire       I_uart_rx_serial_data;
// wire [7:0] o_uart_read_data;
// wire       o_uart_read_data_valid;

// Wrapper_UART M1
// (
//     .I_sys_clk        (I_uart_sys_clk),
//     .I_rst            (I_uart_rst),
//     .I_enable         (I_uart_enable),
//     .I_rx_serial_data (I_uart_rx_serial_data),
//     .o_read_data      (o_uart_read_data),
//     .o_read_data_valid(o_uart_read_data_valid)
// );

// //----------------------------------------------------
// wire [7:0] I_check_write_data;
// wire I_check_write_valid;
// wire [6:0] o_check_write_enable;

// UART_Check_data M2
// (
//     .I_sys_clk        (I_sys_clk_top),
//     .I_rst            (I_uart_rst),
//     .I_write_data     (I_check_write_data),
//     .I_read_data_valid(I_check_write_valid),

//     .o_write_enable   (o_check_write_enable)
// );


//----------------------------------------------------
scanner M3
(
    .I_sys_clk                   (I_sys_clk_top),
    .I_rst_button                (I_rst_button_top),
    .I_start_button              (I_start_button_top),
    //module outputs
    .o_servo1_directional        (o_servo1_directional_top_scanning/*o_servo1_directional_top*/),
    .o_servo2_directional        (o_servo2_directional_top_scanning/*o_servo2_directional_top*/),
    .o_servo3_directional        (o_servo3_directional_top_scanning/*o_servo3_directional_top*/),
    .o_servo1_gripping           (o_servo1_gripping_top_scanning/*o_servo1_gripping_top*/),
    .o_servo2_gripping           (o_servo2_gripping_top_scanning/*o_servo2_gripping_top*/),
    .o_servo3_gripping           (o_servo3_gripping_top_scanning/*o_servo3_gripping_top*/),
    .o_motor_clk                 (I_clk),
    .scanner_clk_posedge_detector(w_scanner_clk_posedge_detector),
    .scanner_done                (mux_select),
    //feedback                    signals
    .direction1_movement_done    (direction1_movement_done_scanning),
    .direction2_movement_done    (direction2_movement_done_scanning),
    .direction3_movement_done    (direction3_movement_done_scanning),
    .gripping1_movement_done     (gripping1_movement_done_scanning),
    .gripping2_movement_done     (gripping2_movement_done_scanning),
    .gripping3_movement_done     (gripping3_movement_done_scanning)
);
//----------------------------------------------------
user_controller M4
(
    .I_sys_clk                          (I_sys_clk_top),
    .I_motor_clk                        (I_clk), //might need to change to system clock
    .I_scanner_done                     (mux_select),
    .I_rst_user_button                  (I_rst_user_button_top),
    .I_user_movement_leftRow            (I_user_movement_leftRow_top),
    .I_user_movement_rightRow           (I_user_movement_rightRow_top),
    .I_user_movement_topRow             (I_user_movement_topRow_top),
    .I_user_movement_bottomRow          (I_user_movement_bottomRow_top),

    //feedback needed to communicate between module transitions
    //.gripping3_movement_done_scanner(gripping3_movement_done),
    //feedback inputs
    .direction1_movement_done_controller(direction1_movement_done_user),
    .direction2_movement_done_controller(direction2_movement_done_user),
    .direction3_movement_done_controller(direction3_movement_done_user),
    .direction4_movement_done_controller(direction4_movement_done_user),
    .gripping1_movement_done_controller (gripping1_movement_done_user),
    .gripping2_movement_done_controller (gripping2_movement_done_user),
    .gripping3_movement_done_controller (gripping3_movement_done_user),
    .gripping4_movement_done_controller (gripping4_movement_done_user),

    .o_servo1_directional_controller    (o_servo1_directional_top_user),
    .o_servo2_directional_controller    (o_servo2_directional_top_user),
    .o_servo3_directional_controller    (o_servo3_directional_top_user),
    .o_servo4_directional_controller    (o_servo4_directional_top_user),
    .o_servo1_gripping_controller       (o_servo1_gripping_top_user),
    .o_servo2_gripping_controller       (o_servo2_gripping_top_user),
    .o_servo3_gripping_controller       (o_servo3_gripping_top_user),
    .o_servo4_gripping_controller       (o_servo4_gripping_top_user)
);
//----------------------------------------------------
motor_logic #(.count_limit(6429),.duty_cycle(3))
S_directional_1
(
    .I_servo_pwm_EN(o_servo1_directional_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo1_directional_output_top),
    .movement_done (direction1_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_directional_2
(
    .I_servo_pwm_EN(o_servo2_directional_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo2_directional_output_top),
    .movement_done (direction2_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_directional_3
(
    .I_servo_pwm_EN(o_servo3_directional_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo3_directional_output_top),
    .movement_done (direction3_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_directional_4
(
    .I_servo_pwm_EN(o_servo4_directional_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo4_directional_output_top),
    .movement_done (direction4_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_gripping_1
(
    .I_servo_pwm_EN(o_servo1_gripping_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo1_gripping_output_top),
    .movement_done (gripping1_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_gripping_2
(
    .I_servo_pwm_EN(o_servo2_gripping_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo2_gripping_output_top),
    .movement_done (gripping2_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_gripping_3
(
    .I_servo_pwm_EN(o_servo3_gripping_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo3_gripping_output_top),
    .movement_done (gripping3_movement_done)
);

motor_logic #(.count_limit(6429),.duty_cycle(3))
S_gripping_4
(
    .I_servo_pwm_EN(o_servo4_gripping_top),
    .I_clk         (I_clk),
    .o_servo_output(o_servo4_gripping_output_top),
    .movement_done (gripping4_movement_done)
);

//----------------------------------------------------
//MUX for servos 
assign o_servo1_directional_top = (mux_select)?o_servo1_directional_top_user:o_servo1_directional_top_scanning; //servc 1
assign o_servo2_directional_top = (mux_select)?o_servo2_directional_top_user:o_servo2_directional_top_scanning; //servc 2
assign o_servo3_directional_top = (mux_select)?o_servo3_directional_top_user:o_servo3_directional_top_scanning; //servc 3
assign o_servo4_directional_top = (mux_select)?o_servo4_directional_top_user:0; //servc 4

assign o_servo1_gripping_top    = (mux_select)?o_servo1_gripping_top_user:o_servo1_gripping_top_scanning; //servo 5
assign o_servo2_gripping_top    = (mux_select)?o_servo2_gripping_top_user:o_servo2_gripping_top_scanning; //servo 6
assign o_servo3_gripping_top    = (mux_select)?o_servo3_gripping_top_user:o_servo3_gripping_top_scanning; //servo 7
assign o_servo4_gripping_top    = (mux_select)?o_servo4_gripping_top_user:0; //servo 8

//----------------------------------------------------
//DEMUX for movement dones
assign direction1_movement_done_scanning = (mux_select==0)?direction1_movement_done:0;
assign direction1_movement_done_user     = (mux_select==1)?direction1_movement_done:0;
assign direction2_movement_done_scanning = (mux_select==0)?direction2_movement_done:0;
assign direction2_movement_done_user     = (mux_select==1)?direction2_movement_done:0;
assign direction3_movement_done_scanning = (mux_select==0)?direction3_movement_done:0;
assign direction3_movement_done_user     = (mux_select==1)?direction3_movement_done:0;
assign direction4_movement_done_scanning = (mux_select==0)?direction4_movement_done:0;
assign direction4_movement_done_user     = (mux_select==1)?direction4_movement_done:0;

assign gripping1_movement_done_scanning  = (mux_select==0)?gripping1_movement_done:0;
assign gripping1_movement_done_user      = (mux_select==1)?gripping1_movement_done:0;
assign gripping2_movement_done_scanning  = (mux_select==0)?gripping2_movement_done:0;
assign gripping2_movement_done_user      = (mux_select==1)?gripping2_movement_done:0;
assign gripping3_movement_done_scanning  = (mux_select==0)?gripping3_movement_done:0;
assign gripping3_movement_done_user      = (mux_select==1)?gripping3_movement_done:0;
assign gripping4_movement_done_scanning  = (mux_select==0)?gripping4_movement_done:0;
assign gripping4_movement_done_user      = (mux_select==1)?gripping4_movement_done:0;
//----------------------------------------------------
//assign I_uart_sys_clk                = I_sys_clk_top;
//assign I_uart_rst                    = I_sys_rst_top;
//assign I_uart_enable                 = 1;
//assign I_uart_rx_serial_data         = I_rx_serial_data_wrapper_top;
//assign I_check_write_data            = o_uart_read_data;
//assign I_check_write_valid           = o_uart_read_data_valid;
//assign I_user_movement_leftRow_top   = o_check_write_enable[0];
//assign I_user_movement_topRow_top    = o_check_write_enable[1];
//assign I_user_movement_bottomRow_top = o_check_write_enable[2];
//assign I_user_movement_rightRow_top  = o_check_write_enable[3];
//assign I_start_button_top            = o_check_write_enable[4];
//assign I_rst_button_top              = o_check_write_enable[5];
//assign I_rst_user_button_top         = o_check_write_enable[6];

endmodule
