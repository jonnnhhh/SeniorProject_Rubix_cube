`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jonathan Gonzalez
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
    input           I_sys_clk_top,
    input           I_on_board_reset_n,
    input           I_rx_serial_data,

    output          o_servo1_directional_output_top,
    output          o_servo2_directional_output_top,
    output          o_servo3_directional_output_top,
    output          o_servo4_directional_output_top,
    output          o_servo1_gripping_output_top,
    output          o_servo2_gripping_output_top,
    output          o_servo3_gripping_output_top,
    output          o_servo4_gripping_output_top
);

//------- Uart Module -------------------------------------------------------------------------------------------------------------------------------------------------------------

wire        uart_sys_clk;
wire        uart_rst;
wire        uart_enable;
wire        uart_rx_serial_data;

wire [7:0]  uart_read_data;
wire        uart_read_data_valid;

Wrapper_UART uart
(
    .I_sys_clk        (uart_sys_clk),
    .I_rst            (uart_rst),
    .I_enable         (uart_enable),
    .I_rx_serial_data (uart_rx_serial_data),
    .o_read_data      (uart_read_data),
    .o_read_data_valid(uart_read_data_valid)
);

//------- UART Check Module -------------------------------------------------------------------------------------------------------------------------------------------------------

wire        uart_check_sys_clk;
wire        uart_check_rst;
wire [7:0]  uart_check_write_data;
wire        uart_check_read_valid;

wire [6:0]  uart_check_write_enable;

UART_Check_data uart_check
(
    .I_sys_clk        (uart_check_sys_clk),
    .I_rst            (uart_check_rst),
    .I_write_data     (uart_check_write_data),
    .I_read_data_valid(uart_check_read_valid),

    .o_write_enable   (uart_check_write_enable)
);

//------- Cube Scanner Module -----------------------------------------------------------------------------------------------------------------------------------------------------

wire    cube_scanner_sys_clk;
wire    cube_scanner_rst_button;
wire    cube_scanner_start_button;
wire    cube_scanner_direction1_movement_done;
wire    cube_scanner_direction2_movement_done;
wire    cube_scanner_direction3_movement_done;
wire    cube_scanner_direction4_movement_done = 0;
wire    cube_scanner_gripping1_movement_done;
wire    cube_scanner_gripping2_movement_done;
wire    cube_scanner_gripping3_movement_done;
wire    cube_scanner_gripping4_movement_done  = 0;

wire    cube_scanner_gripper1_orientation_indicator;
wire    cube_scanner_gripper2_orientation_indicator;
wire    cube_scanner_gripper3_orientation_indicator;
wire    cube_scanner_directional1_orientation_indicator;
wire    cube_scanner_directional2_orientation_indicator;
wire    cube_scanner_directional3_orientation_indicator;
wire    cube_scanner_servo1_directional;
wire    cube_scanner_servo2_directional;
wire    cube_scanner_servo3_directional;
wire    cube_scanner_servo1_gripping;
wire    cube_scanner_servo2_gripping;
wire    cube_scanner_servo3_gripping;
wire    cube_scanner_motor_clk;
wire    cube_scanner_clk_posedge_detector;
wire    cube_scanner_scanner_done;

scanner cube_scanner
(
    .I_sys_clk                         (cube_scanner_sys_clk),
    .I_rst_button                      (cube_scanner_rst_button),
    .I_start_button                    (cube_scanner_start_button),

    //feedback signals
    .direction1_movement_done          (cube_scanner_direction1_movement_done),
    .direction2_movement_done          (cube_scanner_direction2_movement_done),
    .direction3_movement_done          (cube_scanner_direction3_movement_done),
    .gripping1_movement_done           (cube_scanner_gripping1_movement_done),
    .gripping2_movement_done           (cube_scanner_gripping2_movement_done),
    .gripping3_movement_done           (cube_scanner_gripping3_movement_done),

    .gripper1_orientation_indicator    (cube_scanner_gripper1_orientation_indicator),
    .gripper2_orientation_indicator    (cube_scanner_gripper2_orientation_indicator),
    .gripper3_orientation_indicator    (cube_scanner_gripper3_orientation_indicator),
    .directional1_orientation_indicator(cube_scanner_directional1_orientation_indicator),
    .directional2_orientation_indicator(cube_scanner_directional2_orientation_indicator),
    .directional3_orientation_indicator(cube_scanner_directional3_orientation_indicator),
    .o_servo1_directional              (cube_scanner_servo1_directional),
    .o_servo2_directional              (cube_scanner_servo2_directional),
    .o_servo3_directional              (cube_scanner_servo3_directional),
    .o_servo1_gripping                 (cube_scanner_servo1_gripping),
    .o_servo2_gripping                 (cube_scanner_servo2_gripping),
    .o_servo3_gripping                 (cube_scanner_servo3_gripping),
    .o_motor_clk                       (cube_scanner_motor_clk),
    .clk_posedge_detector              (cube_scanner_clk_posedge_detector),
    .scanner_done                      (cube_scanner_scanner_done)

);

//------- User controller Module --------------------------------------------------------------------------------------------------------------------------------------------------

wire user_controller_I_sys_clk;
wire user_controller_cube_scanner_motor_clk;
wire user_controller_cube_scanner_clk_posedge_detector;
wire user_controller_scanner_done;
wire user_controller_I_rst_user_button;
wire user_controller_I_user_movement_leftRow;
wire user_controller_I_user_movement_rightRow;
wire user_controller_I_user_movement_topRow;
wire user_controller_I_user_movement_bottomRow;
wire user_controller_direction1_movement_done;
wire user_controller_direction2_movement_done;
wire user_controller_direction3_movement_done;
wire user_controller_direction4_movement_done;
wire user_controller_gripping1_movement_done;
wire user_controller_gripping2_movement_done;
wire user_controller_gripping3_movement_done;
wire user_controller_gripping4_movement_done;

wire user_controller_write_ready;
wire user_controller_gripper1_orientation_indicator;
wire user_controller_gripper2_orientation_indicator;
wire user_controller_gripper3_orientation_indicator;
wire user_controller_gripper4_orientation_indicator;
wire user_controller_directional1_orientation_indicator;
wire user_controller_directional2_orientation_indicator;
wire user_controller_directional3_orientation_indicator;
wire user_controller_directional4_orientation_indicator;
wire user_controller_o_servo1_directional;
wire user_controller_o_servo2_directional;
wire user_controller_o_servo3_directional;
wire user_controller_o_servo4_directional;
wire user_controller_o_servo1_gripping;
wire user_controller_o_servo2_gripping;
wire user_controller_o_servo3_gripping;
wire user_controller_o_servo4_gripping;

user_controller user_controller
(
    .I_sys_clk                          (user_controller_I_sys_clk),
    .I_motor_clk                        (user_controller_cube_scanner_motor_clk),
    .motor_clk_posedge                  (user_controller_cube_scanner_clk_posedge_detector),
    .I_scanner_done                     (user_controller_scanner_done),
    .I_rst_user_button                  (user_controller_I_rst_user_button),
    .I_user_movement_leftRow            (user_controller_I_user_movement_leftRow),
    .I_user_movement_rightRow           (user_controller_I_user_movement_rightRow),
    .I_user_movement_topRow             (user_controller_I_user_movement_topRow),
    .I_user_movement_bottomRow          (user_controller_I_user_movement_bottomRow),

     //feedback                         signals
    .direction1_movement_done_controller(user_controller_direction1_movement_done),
    .direction2_movement_done_controller(user_controller_direction2_movement_done),
    .direction3_movement_done_controller(user_controller_direction3_movement_done),
    .direction4_movement_done_controller(user_controller_direction4_movement_done),
    .gripping1_movement_done_controller (user_controller_gripping1_movement_done),
    .gripping2_movement_done_controller (user_controller_gripping2_movement_done),
    .gripping3_movement_done_controller (user_controller_gripping3_movement_done),
    .gripping4_movement_done_controller (user_controller_gripping4_movement_done),

    .o_write_ready                      (user_controller_write_ready),
    .gripper1_orientation_indicator     (user_controller_gripper1_orientation_indicator),
    .gripper2_orientation_indicator     (user_controller_gripper2_orientation_indicator),
    .gripper3_orientation_indicator     (user_controller_gripper3_orientation_indicator),
    .gripper4_orientation_indicator     (user_controller_gripper4_orientation_indicator),
    .directional1_orientation_indicator (user_controller_directional1_orientation_indicator),
    .directional2_orientation_indicator (user_controller_directional2_orientation_indicator),
    .directional3_orientation_indicator (user_controller_directional3_orientation_indicator),
    .directional4_orientation_indicator (user_controller_directional4_orientation_indicator),
    .o_servo1_directional_controller    (user_controller_o_servo1_directional),
    .o_servo2_directional_controller    (user_controller_o_servo2_directional),
    .o_servo3_directional_controller    (user_controller_o_servo3_directional),
    .o_servo4_directional_controller    (user_controller_o_servo4_directional),
    .o_servo1_gripping_controller       (user_controller_o_servo1_gripping),
    .o_servo2_gripping_controller       (user_controller_o_servo2_gripping),
    .o_servo3_gripping_controller       (user_controller_o_servo3_gripping),
    .o_servo4_gripping_controller       (user_controller_o_servo4_gripping)
);

//------- Motor Logic Module -----------------------------------------------------------------------------------------------------------------------------------------------------


wire       motor_logic_direction1_movement_done;
wire       motor_logic_direction2_movement_done;
wire       motor_logic_direction3_movement_done;
wire       motor_logic_direction4_movement_done;
wire       motor_logic_gripping1_movement_done;
wire       motor_logic_gripping2_movement_done;
wire       motor_logic_gripping3_movement_done;
wire       motor_logic_gripping4_movement_done;

wire       motor_logic_directional1_duty_select;
wire       motor_logic_directional2_duty_select;
wire       motor_logic_directional3_duty_select;
wire       motor_logic_directional4_duty_select;
wire       motor_logic_grip1_duty_select;
wire       motor_logic_grip2_duty_select;
wire       motor_logic_grip3_duty_select;
wire       motor_logic_grip4_duty_select;
wire [2:0] motor_logic_directional1_duty_cycle_selected;
wire [2:0] motor_logic_directional2_duty_cycle_selected;
wire [2:0] motor_logic_directional3_duty_cycle_selected;
wire [2:0] motor_logic_directional4_duty_cycle_selected;
wire [2:0] motor_logic_grip1_duty_cycle_selected;
wire [2:0] motor_logic_grip2_duty_cycle_selected;
wire [2:0] motor_logic_grip3_duty_cycle_selected;
wire [2:0] motor_logic_grip4_duty_cycle_selected;

wire       motor_logic_o_servo1_directional_top;
wire       motor_logic_o_servo2_directional_top;
wire       motor_logic_o_servo3_directional_top;
wire       motor_logic_o_servo4_directional_top;
wire       motor_logic_o_servo1_gripping_top;
wire       motor_logic_o_servo2_gripping_top;
wire       motor_logic_o_servo3_gripping_top;
wire       motor_logic_o_servo4_gripping_top;

motor_logic #(.count_limit(2000))
S_directional_1
(
    .I_servo_pwm_EN         (motor_logic_o_servo1_directional_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_directional1_duty_cycle_selected),

    .o_servo_output         (o_servo1_directional_output_top),
    .movement_done          (motor_logic_direction1_movement_done)
);

motor_logic #(.count_limit(2000))
S_directional_2
(
    .I_servo_pwm_EN         (motor_logic_o_servo2_directional_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_directional2_duty_cycle_selected),

    .o_servo_output         (o_servo2_directional_output_top),
    .movement_done          (motor_logic_direction2_movement_done)
);

motor_logic #(.count_limit(2000))
S_directional_3
(
    .I_servo_pwm_EN         (motor_logic_o_servo3_directional_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_directional3_duty_cycle_selected),

    .o_servo_output         (o_servo3_directional_output_top),
    .movement_done          (motor_logic_direction3_movement_done)
);

motor_logic #(.count_limit(2000))
S_directional_4
(
    .I_servo_pwm_EN         (motor_logic_o_servo4_directional_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_directional4_duty_cycle_selected),

    .o_servo_output         (o_servo4_directional_output_top),
    .movement_done          (motor_logic_direction4_movement_done)
);

motor_logic #(.count_limit(2000))
S_gripping_1
(
    .I_servo_pwm_EN         (motor_logic_o_servo1_gripping_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_grip1_duty_cycle_selected),

    .o_servo_output         (o_servo1_gripping_output_top),
    .movement_done          (motor_logic_gripping1_movement_done)
);

motor_logic #(.count_limit(2000))
S_gripping_2
(
    .I_servo_pwm_EN         (motor_logic_o_servo2_gripping_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_grip2_duty_cycle_selected),

    .o_servo_output         (o_servo2_gripping_output_top),
    .movement_done          (motor_logic_gripping2_movement_done)
);

motor_logic #(.count_limit(2000))
S_gripping_3
(
    .I_servo_pwm_EN         (motor_logic_o_servo3_gripping_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_grip3_duty_cycle_selected),

    .o_servo_output         (o_servo3_gripping_output_top),
    .movement_done          (motor_logic_gripping3_movement_done)
);

motor_logic #(.count_limit(2000))
S_gripping_4
(
    .I_servo_pwm_EN         (motor_logic_o_servo4_gripping_top),
    .I_clk                  (cube_scanner_motor_clk),
    .I_duty_cycle_selected  (motor_logic_grip4_duty_cycle_selected),

    .o_servo_output         (o_servo4_gripping_output_top),
    .movement_done          (motor_logic_gripping4_movement_done)
);

//------- UART Assignments ------------------------------------------------------------------------------------------------------------------------------------------------------

assign uart_sys_clk                             = I_sys_clk_top;
assign uart_rst                                 = I_on_board_reset_n;
assign uart_enable                              = user_controller_write_ready;
assign uart_rx_serial_data                      = I_rx_serial_data;

//------- UART  Check Assignments -----------------------------------------------------------------------------------------------------------------------------------------------

assign uart_check_sys_clk                       = I_sys_clk_top;
assign uart_check_rst                           = I_on_board_reset_n;
assign uart_check_write_data                    = uart_read_data;
assign uart_check_read_valid                    = uart_read_data_valid;

assign I_user_movement_leftRow_top              = uart_check_write_enable[0];
assign I_user_movement_topRow_top               = uart_check_write_enable[1];
assign I_user_movement_bottomRow_top            = uart_check_write_enable[2];
assign I_user_movement_rightRow_top             = uart_check_write_enable[3];
assign I_start_button_top                       = uart_check_write_enable[4];
assign I_rst_button_top                         = uart_check_write_enable[5];
assign I_rst_user_button_top                    = uart_check_write_enable[6];

//------- Internals -------------------------------------------------------------------------------------------------------------------------------------------------------------

wire mux_select;

//------- Internal Signal Assignments--------------------------------------------------------------------------------------------------------------------------------------------

assign mux_select                = cube_scanner_scanner_done;

//------- Cube Scanner Assignments ----------------------------------------------------------------------------------------------------------------------------------------------

assign cube_scanner_sys_clk      = I_sys_clk_top;
assign cube_scanner_rst_button   = I_rst_button_top;
assign cube_scanner_start_button = I_start_button_top;

//------- User controller Assignments -------------------------------------------------------------------------------------------------------------------------------------------

assign user_controller_I_sys_clk                         = I_sys_clk_top;
assign user_controller_cube_scanner_motor_clk            = cube_scanner_motor_clk;
assign user_controller_cube_scanner_clk_posedge_detector = cube_scanner_clk_posedge_detector;
assign user_controller_scanner_done                      = cube_scanner_scanner_done;
assign user_controller_I_rst_user_button                 = I_rst_user_button_top;
assign user_controller_I_user_movement_leftRow           = I_user_movement_leftRow_top;
assign user_controller_I_user_movement_rightRow          = I_user_movement_rightRow_top;
assign user_controller_I_user_movement_topRow            = I_user_movement_topRow_top;
assign user_controller_I_user_movement_bottomRow         = I_user_movement_bottomRow_top;

//------- Motor Logic Assignments (MUX) -----------------------------------------------------------------------------------------------------------------------------------------

assign motor_logic_o_servo1_directional_top              = (mux_select) ? user_controller_o_servo1_directional                  : cube_scanner_servo1_directional;
assign motor_logic_o_servo2_directional_top              = (mux_select) ? user_controller_o_servo2_directional                  : cube_scanner_servo2_directional;
assign motor_logic_o_servo3_directional_top              = (mux_select) ? user_controller_o_servo3_directional                  : cube_scanner_servo3_directional;
assign motor_logic_o_servo4_directional_top              = (mux_select) ? user_controller_o_servo4_directional                  : 0;

assign motor_logic_o_servo1_gripping_top                 = (mux_select) ? user_controller_o_servo1_gripping                     : cube_scanner_servo1_gripping;
assign motor_logic_o_servo2_gripping_top                 = (mux_select) ? user_controller_o_servo2_gripping                     : cube_scanner_servo2_gripping;
assign motor_logic_o_servo3_gripping_top                 = (mux_select) ? user_controller_o_servo3_gripping                     : cube_scanner_servo3_gripping;
assign motor_logic_o_servo4_gripping_top                 = (mux_select) ? user_controller_o_servo4_gripping                     : 0;

assign motor_logic_directional1_duty_select              = (mux_select) ? user_controller_directional1_orientation_indicator    : cube_scanner_directional1_orientation_indicator;
assign motor_logic_directional2_duty_select              = (mux_select) ? user_controller_directional2_orientation_indicator    : cube_scanner_directional2_orientation_indicator;
assign motor_logic_directional3_duty_select              = (mux_select) ? user_controller_directional3_orientation_indicator    : cube_scanner_directional3_orientation_indicator;
assign motor_logic_directional4_duty_select              = (mux_select) ? user_controller_directional4_orientation_indicator    : 0;

assign motor_logic_grip1_duty_select                     = (mux_select) ? user_controller_gripper1_orientation_indicator        : cube_scanner_gripper1_orientation_indicator;
assign motor_logic_grip2_duty_select                     = (mux_select) ? user_controller_gripper2_orientation_indicator        : cube_scanner_gripper2_orientation_indicator;
assign motor_logic_grip3_duty_select                     = (mux_select) ? user_controller_gripper3_orientation_indicator        : cube_scanner_gripper3_orientation_indicator;
assign motor_logic_grip4_duty_select                     = (mux_select) ? user_controller_gripper4_orientation_indicator        : 0;

//Duty Cycle (directional servos): 0 degrees = 1, 90 degrees right = 3
assign motor_logic_directional1_duty_cycle_selected      = (motor_logic_directional1_duty_select == 0) ? 'd3   : 'd1;
assign motor_logic_directional2_duty_cycle_selected      = (motor_logic_directional2_duty_select == 0) ? 'd3   : 'd1;
assign motor_logic_directional3_duty_cycle_selected      = (motor_logic_directional3_duty_select == 0) ? 'd3   : 'd1;
assign motor_logic_directional4_duty_cycle_selected      = (motor_logic_directional4_duty_select == 0) ? 'd3   : 'd1;

//Duty Cycle (gripper servos): Open                                                                    = 1, close = 2
assign motor_logic_grip1_duty_cycle_selected             = (motor_logic_grip1_duty_select == 0)        ? 'd1   : 'd2;
assign motor_logic_grip2_duty_cycle_selected             = (motor_logic_grip2_duty_select == 0)        ? 'd1   : 'd2;
assign motor_logic_grip3_duty_cycle_selected             = (motor_logic_grip3_duty_select == 0)        ? 'd2   : 'd1;
assign motor_logic_grip4_duty_cycle_selected             = (motor_logic_grip4_duty_select == 0)        ? 'd1   : 'd2;

//------- Feedback Assignments (DEMUX) ------------------------------------------------------------------------------------------------------------------------------------------

assign cube_scanner_direction1_movement_done            = (mux_select==0) ? motor_logic_direction1_movement_done : 0;
assign cube_scanner_direction2_movement_done            = (mux_select==0) ? motor_logic_direction2_movement_done : 0;
assign cube_scanner_direction3_movement_done            = (mux_select==0) ? motor_logic_direction3_movement_done : 0;
assign cube_scanner_direction4_movement_done            = (mux_select==0) ? motor_logic_direction4_movement_done : 0;
assign user_controller_direction1_movement_done         = (mux_select==1) ? motor_logic_direction1_movement_done : 0;
assign user_controller_direction2_movement_done         = (mux_select==1) ? motor_logic_direction2_movement_done : 0;
assign user_controller_direction3_movement_done         = (mux_select==1) ? motor_logic_direction3_movement_done : 0;
assign user_controller_direction4_movement_done         = (mux_select==1) ? motor_logic_direction4_movement_done : 0;

assign cube_scanner_gripping1_movement_done             = (mux_select==0) ? motor_logic_gripping1_movement_done  : 0;
assign cube_scanner_gripping2_movement_done             = (mux_select==0) ? motor_logic_gripping2_movement_done  : 0;
assign cube_scanner_gripping3_movement_done             = (mux_select==0) ? motor_logic_gripping3_movement_done  : 0;
assign cube_scanner_gripping4_movement_done             = (mux_select==0) ? motor_logic_gripping4_movement_done  : 0;
assign user_controller_gripping1_movement_done          = (mux_select==1) ? motor_logic_gripping1_movement_done  : 0;
assign user_controller_gripping2_movement_done          = (mux_select==1) ? motor_logic_gripping2_movement_done  : 0;
assign user_controller_gripping3_movement_done          = (mux_select==1) ? motor_logic_gripping3_movement_done  : 0;
assign user_controller_gripping4_movement_done          = (mux_select==1) ? motor_logic_gripping4_movement_done  : 0;

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

endmodule
