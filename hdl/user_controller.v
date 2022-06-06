`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2022 10:15:26 PM
// Design Name: 
// Module Name: user_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 

// left column   top row  right column
    //       // // //     //
    //                    //
    //                    //
//           // // //
//           bottom row    
 
// Revision:
// Revision 0.01 - File Created

//////////////////////////////////////////////////////////////////////////////////
module user_controller
(
    input I_sys_clk,
    input I_motor_clk,
    input motor_clk_posedge,
    input I_scanner_done,
    input I_rst_user_button,
    input I_user_movement_leftRow,
    input I_user_movement_rightRow,
    input I_user_movement_topRow,
    input I_user_movement_bottomRow,

    input direction1_movement_done_controller,
    input direction2_movement_done_controller,
    input direction3_movement_done_controller,
    input direction4_movement_done_controller,
    input gripping1_movement_done_controller,
    input gripping2_movement_done_controller,
    input gripping3_movement_done_controller,
    input gripping4_movement_done_controller,

    output reg o_write_ready,
    output reg gripper1_orientation_indicator      = 0,
    output reg gripper2_orientation_indicator      = 0,
    output reg gripper3_orientation_indicator      = 0,
    output reg gripper4_orientation_indicator      = 0,
    output reg directional1_orientation_indicator  = 0,
    output reg directional2_orientation_indicator  = 0,
    output reg directional3_orientation_indicator  = 0,
    output reg directional4_orientation_indicator  = 0,
    output reg o_servo1_directional_controller     = 0,
    output reg o_servo2_directional_controller     = 0,
    output reg o_servo3_directional_controller     = 0,
    output reg o_servo4_directional_controller     = 0,
    output reg o_servo1_gripping_controller        = 0,
    output reg o_servo2_gripping_controller        = 0,
    output reg o_servo3_gripping_controller        = 0,
    output reg o_servo4_gripping_controller        = 0
);

//------------------------------------------------------------------------------------

parameter STATE_IDLE            = 5'b00001;
parameter STATE_LEFT_MOVEMENT   = 5'b00010;
parameter STATE_TOP_MOVEMENT    = 5'b00100;
parameter STATE_BOTTOM_MOVEMENT = 5'b01000;
parameter STATE_RIGHT_MOVEMENT  = 5'b10000;

//------------------------------------------------------------------------------------

assign leftRow      = (I_user_movement_leftRow)   ? 1 : 0;
assign rightRow     = (I_user_movement_rightRow)  ? 1 : 0;
assign topRow       = (I_user_movement_topRow)    ? 1 : 0;
assign bottomRow    = (I_user_movement_bottomRow) ? 1 : 0;
assign mtr_clk      = I_motor_clk;
assign scanner_done = I_scanner_done;

//------------------------------------------------------------------------------------

reg [8:0] key;
reg [8:0] key_next;
reg [4:0] current_state,current_state_next;
reg       o_write_ready_next;

reg       gripper1_orientation_indicator_next;
reg       gripper2_orientation_indicator_next;
reg       gripper3_orientation_indicator_next;
reg       gripper4_orientation_indicator_next;
reg       directional1_orientation_indicator_next;
reg       directional2_orientation_indicator_next;
reg       directional3_orientation_indicator_next;
reg       directional4_orientation_indicator_next;
reg       o_servo1_gripping_controller_next;
reg       o_servo2_gripping_controller_next;
reg       o_servo3_gripping_controller_next;
reg       o_servo4_gripping_controller_next;
reg       o_servo1_directional_controller_next;
reg       o_servo2_directional_controller_next;
reg       o_servo3_directional_controller_next;
reg       o_servo4_directional_controller_next;

//---------------------Sequential Logic----------------------------------------------
always@(posedge I_sys_clk or posedge I_rst_user_button)
begin
    if(I_rst_user_button)
    begin

        o_servo1_gripping_controller       <= 0;
        o_servo2_gripping_controller       <= 0;
        o_servo3_gripping_controller       <= 0;
        o_servo4_gripping_controller       <= 0;
        o_servo1_directional_controller    <= 0;
        o_servo2_directional_controller    <= 0;
        o_servo3_directional_controller    <= 0;
        o_servo4_directional_controller    <= 0;
        gripper1_orientation_indicator     <= 0; // 0 = initially closed
        gripper2_orientation_indicator     <= 0; // 0 = initially closed
        gripper3_orientation_indicator     <= 0; // 0 = initially opened
        gripper4_orientation_indicator     <= 0; // 0 = initially closed
        directional1_orientation_indicator <= 0;
        directional2_orientation_indicator <= 0;
        directional3_orientation_indicator <= 0;
        directional4_orientation_indicator <= 0;
        key[0]                             <= 0;
        key[1]                             <= 0;
        key[2]                             <= 0;
        key[3]                             <= 0;
        key[4]                             <= 0;
        key[5]                             <= 0;
        key[6]                             <= 0;
        key[7]                             <= 0;
        key[8]                             <= 0;
        o_write_ready                      <= 1;
        current_state                      <= STATE_IDLE;

    end
    else
    begin
        o_servo1_gripping_controller           <= o_servo1_gripping_controller_next;
        o_servo2_gripping_controller           <= o_servo2_gripping_controller_next;
        o_servo3_gripping_controller           <= o_servo3_gripping_controller_next;
        o_servo4_gripping_controller           <= o_servo4_gripping_controller_next;
        o_servo1_directional_controller        <= o_servo1_directional_controller_next;
        o_servo2_directional_controller        <= o_servo2_directional_controller_next;
        o_servo3_directional_controller        <= o_servo3_directional_controller_next;
        o_servo4_directional_controller        <= o_servo4_directional_controller_next;
        gripper1_orientation_indicator         <= gripper1_orientation_indicator_next;
        gripper2_orientation_indicator         <= gripper2_orientation_indicator_next;
        gripper3_orientation_indicator         <= gripper3_orientation_indicator_next;
        gripper4_orientation_indicator         <= gripper4_orientation_indicator_next;
        directional1_orientation_indicator     <= directional1_orientation_indicator_next;
        directional2_orientation_indicator     <= directional2_orientation_indicator_next;
        directional3_orientation_indicator     <= directional3_orientation_indicator_next;
        directional4_orientation_indicator     <= directional4_orientation_indicator_next;
        key[0]                                 <= key_next[0];
        key[1]                                 <= key_next[1];
        key[2]                                 <= key_next[2];
        key[3]                                 <= key_next[3];
        key[4]                                 <= key_next[4];
        key[5]                                 <= key_next[5];
        key[6]                                 <= key_next[6];
        key[7]                                 <= key_next[7];
        key[8]                                 <= key_next[8];
        o_write_ready                          <= o_write_ready_next;
        current_state                          <= current_state_next;

    end
end

//-------------------------Combinatorial Logic--------------------------------------------
always@(*)
begin
    o_servo1_gripping_controller_next          = o_servo1_gripping_controller;
    o_servo2_gripping_controller_next          = o_servo2_gripping_controller;
    o_servo3_gripping_controller_next          = o_servo3_gripping_controller;
    o_servo4_gripping_controller_next          = o_servo4_gripping_controller;
    o_servo1_directional_controller_next       = o_servo1_directional_controller;
    o_servo2_directional_controller_next       = o_servo2_directional_controller;
    o_servo3_directional_controller_next       = o_servo3_directional_controller;
    o_servo4_directional_controller_next       = o_servo4_directional_controller;
    gripper1_orientation_indicator_next        = gripper1_orientation_indicator;
    gripper2_orientation_indicator_next        = gripper2_orientation_indicator;
    gripper3_orientation_indicator_next        = gripper3_orientation_indicator;
    gripper4_orientation_indicator_next        = gripper4_orientation_indicator;
    directional1_orientation_indicator_next    = directional1_orientation_indicator;
    directional2_orientation_indicator_next    = directional2_orientation_indicator;
    directional3_orientation_indicator_next    = directional3_orientation_indicator;
    directional4_orientation_indicator_next    = directional4_orientation_indicator;
    key_next[0]                                = key[0];
    key_next[1]                                = key[1];
    key_next[2]                                = key[2];
    key_next[3]                                = key[3];
    key_next[4]                                = key[4];
    key_next[5]                                = key[5];
    key_next[6]                                = key[6];
    key_next[7]                                = key[7];
    key_next[8]                                = key[8];
    o_write_ready_next                         = o_write_ready;
    current_state_next                         = current_state;

    case(current_state)
    //------------------------------------------------------------------------------------
    STATE_IDLE: //00001
    begin
        if(scanner_done == 1)
        begin

            if(leftRow == 1)
            begin
                directional1_orientation_indicator_next    = 0;
                o_write_ready_next                         = 0;
                key_next[0]                                = 1;
                current_state_next                         = STATE_LEFT_MOVEMENT;

            end

            if(topRow == 1)
            begin
                directional3_orientation_indicator_next    = 0;
                o_write_ready_next                         = 0;
                key_next[0]                                = 1;
                current_state_next                         = STATE_TOP_MOVEMENT;

            end

            if(bottomRow == 1)
            begin
                directional4_orientation_indicator_next    = 0;
                o_write_ready_next                         = 0;
                key_next[0]                                = 1;
                current_state_next                         = STATE_BOTTOM_MOVEMENT;

            end

            if(rightRow == 1)
            begin
                directional2_orientation_indicator_next    = 0;
                o_write_ready_next                         = 0;
                key_next[0]                                = 1;
                current_state_next                         = STATE_RIGHT_MOVEMENT;
            end
        end

    end
    //------------------------------------------------------------------------------------
    STATE_LEFT_MOVEMENT: //00010
    begin
        if(motor_clk_posedge == 1)
        begin
            if(key[0] == 1)
            begin

                o_write_ready_next                         = 0;
                o_servo1_gripping_controller_next          = 0;
                o_servo1_directional_controller_next       = 1; //90 degrees right
                directional1_orientation_indicator_next    = 1;
                key_next[0]                                = 0;
                key_next[1]                                = 1;

            end

            if(key[1] == 1)
            begin

                key_next[1] = 0;
                key_next[2] = 1;

            end

            if(direction1_movement_done_controller == 1 && key[2] == 1)
            begin

                o_servo1_directional_controller_next   = 0;
                o_servo1_gripping_controller_next      = 1; // opened @90 degrees
                gripper1_orientation_indicator_next    = 1;
                key_next[2]                            = 0;
                key_next[3]                            = 1;

            end

            if(key[3] == 1)
            begin

                key_next[3] = 0;
                key_next[4] = 1;

            end

            if(gripping1_movement_done_controller == 1 && key[4] == 1)
            begin

                o_servo1_gripping_controller_next         = 0;
                o_servo1_directional_controller_next      = 1;//90 degrees right
                directional1_orientation_indicator_next   = 0;
                key_next[4]                               = 0;
                key_next[5]                               = 1;

            end

            if(key[5] == 1)
            begin

                key_next[5] = 0;
                key_next[6] = 1;

            end

            if(direction1_movement_done_controller == 1 && key[6] == 1)
            begin

                o_servo1_directional_controller_next   = 0;
                o_servo1_gripping_controller_next      = 1; //closed @180 degrees
                gripper1_orientation_indicator_next    = 0;
                key_next[6]                            = 0;
                key_next[7]                            = 1;

            end

            if(key[7] == 1)
            begin

                key_next[7]   = 0;
                key_next[8] = 1;

            end

            if(gripping1_movement_done_controller == 1 && key[8] == 1)
            begin

                o_servo1_gripping_controller_next   = 0;
                key_next[8]                         = 0;
                o_write_ready_next                  = 1;
                current_state_next                  = STATE_IDLE;

            end
       end
      end
    //------------------------------------------------------------------------------------
    STATE_TOP_MOVEMENT: //00100
    begin
        if(motor_clk_posedge == 1)
        begin
            if(key[0] == 1)
            begin

                o_write_ready_next                      = 0;
                o_servo3_gripping_controller_next       = 1; //closed @180 degrees
                gripper3_orientation_indicator_next     = 1;
                o_servo3_directional_controller_next    = 0;
                key_next[0]                             = 0;
                key_next[1]                             = 1;

            end

            if(key[1] == 1)
            begin

                key_next[1] = 0;
                key_next[2] = 1;

            end

            if(gripping3_movement_done_controller == 1 && key[2] == 1)
            begin

                o_servo3_directional_controller_next      = 1;// 90 degrees right
                directional3_orientation_indicator_next   = 1;
                o_servo3_gripping_controller_next         = 0;
                key_next[2]                               = 0;
                key_next[3]                               = 1;

            end

            if(key[3] == 1)
            begin

                key_next[3] = 0;
                key_next[4] = 1;

            end

            if(direction3_movement_done_controller == 1 && key[4] == 1)
            begin

                o_servo3_directional_controller_next   = 0;
                o_servo3_gripping_controller_next      = 1;//opened @90 degrees
                gripper3_orientation_indicator_next    = 0;
                key_next[4]                            = 0;
                key_next[5]                            = 1;

            end

            if(key[5] == 1)
            begin

                key_next[5] = 0;
                key_next[6] = 1;

            end

            if(gripping3_movement_done_controller == 1 && key[6] == 1)
            begin

                o_servo3_directional_controller_next      = 1; //90 degrees right, open @180
                directional3_orientation_indicator_next   = 0;
                o_servo3_gripping_controller_next         = 0;
                key_next[6]                               = 0;
                key_next[7]                               = 1;

            end

            if(key[7] == 1)
            begin

                key_next[7] = 0;
                key_next[8] = 1;

            end

            if(direction3_movement_done_controller == 1 && key[8] == 1)
            begin

                o_servo3_directional_controller_next   = 0;
                key_next[8]                            = 0;
                o_write_ready_next                     = 1;
                current_state_next                     = STATE_IDLE;

            end
        end
    end
    //------------------------------------------------------------------------------------
    STATE_BOTTOM_MOVEMENT: //01000
    begin
        if(motor_clk_posedge == 1)
        begin
            if(key[0] == 1)
            begin

                o_write_ready_next                         = 0;
                o_servo4_gripping_controller_next          = 0;
                o_servo4_directional_controller_next       = 1; //90 degrees right
                directional4_orientation_indicator_next    = 1;
                key_next[0]                                = 0;
                key_next[1]                                = 1;

            end

            if(key[1] == 1)
            begin

                key_next[1] = 0;
                key_next[2] = 1;

            end

            if(direction4_movement_done_controller == 1 && key[2] == 1)
            begin

                o_servo4_directional_controller_next   = 0;
                o_servo4_gripping_controller_next      = 1; // opened @90 degrees
                gripper4_orientation_indicator_next    = 1;
                key_next[2]                            = 0;
                key_next[3]                            = 1;

            end

            if(key[3] == 1)
            begin

                key_next[3] = 0;
                key_next[4] = 1;

            end

            if(gripping4_movement_done_controller == 1 && key[4] == 1)
            begin

                o_servo4_gripping_controller_next         = 0;
                o_servo4_directional_controller_next      = 1;//90 degrees right
                directional4_orientation_indicator_next   = 0;
                key_next[4]                               = 0;
                key_next[5]                               = 1;

            end

            if(key[5] == 1)
            begin

                key_next[5] = 0;
                key_next[6] = 1;

            end

            if(direction4_movement_done_controller == 1 && key[6] == 1)
            begin

                o_servo4_directional_controller_next   = 0;
                o_servo4_gripping_controller_next      = 1; //closed @180 degrees
                gripper4_orientation_indicator_next    = 0;
                key_next[6]                            = 0;
                key_next[7]                            = 1;

            end

            if(key[7] == 1)
            begin

                key_next[7] = 0;
                key_next[8] = 1;

            end

            if(gripping4_movement_done_controller == 1 && key[8] == 1)
            begin

                o_servo4_gripping_controller_next      = 0;
                key_next[8]                            = 0;
                o_write_ready_next                     = 1;
                current_state_next                     = STATE_IDLE;

            end
        end
    end
    //------------------------------------------------------------------------------------
    STATE_RIGHT_MOVEMENT: //10000
    begin
        if(motor_clk_posedge == 1)
        begin
            if(key[0] == 1)
            begin

                o_write_ready_next                         = 0;
                o_servo2_gripping_controller_next          = 0;
                o_servo2_directional_controller_next       = 1; //90 degrees right
                directional2_orientation_indicator_next    = 1;
                key_next[0]                                = 0;
                key_next[1]                                = 1;

            end

            if(key[1] == 1)
            begin

                key_next[1] = 0;
                key_next[2] = 1;

            end

            if(direction2_movement_done_controller == 1 && key[2] == 1)
            begin

                o_servo2_directional_controller_next   = 0;
                o_servo2_gripping_controller_next      = 1; // opened @90 degrees
                gripper2_orientation_indicator_next    = 1;
                key_next[2]                            = 0;
                key_next[3]                            = 1;

            end

            if(key[3] == 1)
            begin

                key_next[3] = 0;
                key_next[4] = 1;

            end

            if(gripping2_movement_done_controller == 1 && key[4] == 1)
            begin

                o_servo2_gripping_controller_next         = 0;
                o_servo2_directional_controller_next      = 1;//opened @180 degrees
                directional2_orientation_indicator_next   = 0;
                key_next[4]                               = 0;
                key_next[5]                               = 1;

            end

            if(key[5] == 1)
            begin

                key_next[5] = 0;
                key_next[6] = 1;

            end

            if(direction2_movement_done_controller == 1 && key[6] == 1)
            begin

                o_servo2_directional_controller_next   = 0;
                o_servo2_gripping_controller_next      = 1; //closed @180 degrees
                gripper2_orientation_indicator_next    = 0;
                key_next[6]                            = 0;
                key_next[7]                            = 1;

            end

            if(key[7] == 1)
            begin

                key_next[7] = 0;
                key_next[8] = 1;

            end

            if(gripping2_movement_done_controller == 1 && key[8] == 1)
            begin

                o_servo2_gripping_controller_next      = 0;
                key_next[8]                            = 0;
                o_write_ready_next                     = 1;
                current_state_next                     = STATE_IDLE;

            end
        end
    end
    //------------------------------------------------------------------------------------
    default:
    begin

        current_state_next = STATE_IDLE;

    end
    //------------------------------------------------------------------------------------
    endcase
end
//----------------------------------------------------------------------------------------
endmodule
