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
    input I_scanner_done,
    input I_rst_user_button,
    input I_user_movement_leftRow, //direc/grip 1
    input I_user_movement_rightRow,//direc/grip 2
    input I_user_movement_topRow, //direc/grip 3
    input I_user_movement_bottomRow,//direc/grip 4

    input direction1_movement_done_controller,
    input direction2_movement_done_controller,
    input direction3_movement_done_controller,
    input direction4_movement_done_controller,
    input gripping1_movement_done_controller,
    input gripping2_movement_done_controller,
    input gripping3_movement_done_controller,
    input gripping4_movement_done_controller,

    output reg o_servo1_directional_controller,
    output reg o_servo2_directional_controller,
    output reg o_servo3_directional_controller,
    output reg o_servo4_directional_controller,
    output reg o_servo1_gripping_controller,
    output reg o_servo2_gripping_controller,
    output reg o_servo3_gripping_controller,
    output reg o_servo4_gripping_controller,
    output reg o_write_ready
);
//----------------------------------------------------
parameter STATE_IDLE            = 5'b00001;
parameter STATE_LEFT_MOVEMENT   = 5'b00010;
parameter STATE_TOP_MOVEMENT    = 5'b00100;
parameter STATE_BOTTOM_MOVEMENT = 5'b01000;
parameter STATE_RIGHT_MOVEMENT  = 5'b10000;
//---------------------------------------------------- 
assign leftRow      = (I_user_movement_leftRow)  ?1:0;
assign rightRow     = (I_user_movement_rightRow) ?1:0;
assign topRow       = (I_user_movement_topRow)   ?1:0;
assign bottomRow    = (I_user_movement_bottomRow)?1:0;
assign mtr_clk      = I_motor_clk;
assign scanner_done = I_scanner_done;
//---------------------------------------------------- 
reg       o_servo1_gripping_controller_next;
reg       o_servo2_gripping_controller_next;
reg       o_servo3_gripping_controller_next;
reg       o_servo4_gripping_controller_next;
reg       o_servo1_directional_controller_next;
reg       o_servo2_directional_controller_next;
reg       o_servo3_directional_controller_next;
reg       o_servo4_directional_controller_next;
reg       key,key1,key2,key3,key4,key5,key6,key7,key8;
reg       key_next, key1_next,key2_next,key3_next,
          key4_next,key5_next,key6_next,key7_next,
          key8_next,o_write_ready_next;
reg [4:0] current_state,current_state_next;
//---------------------------------------------------- 
always@(posedge mtr_clk or posedge I_rst_user_button)
begin
    if(I_rst_user_button)
    begin
    
        o_servo1_gripping_controller    <= 0;
        o_servo2_gripping_controller    <= 0;
        o_servo3_gripping_controller    <= 0;
        o_servo4_gripping_controller    <= 0;
        o_servo1_directional_controller <= 0;
        o_servo2_directional_controller <= 0;
        o_servo3_directional_controller <= 0;
        o_servo4_directional_controller <= 0;
        key                             <= 0;
        key1                            <= 0;
        key2                            <= 0;
        key3                            <= 0;
        key4                            <= 0;
        key5                            <= 0;
        key6                            <= 0;
        key7                            <= 0;
        key8                            <= 0;
        o_write_ready                   <= 1;
        current_state                   <= STATE_IDLE;

    end
    else
    begin     
        o_servo1_gripping_controller    <= o_servo1_gripping_controller_next;
        o_servo2_gripping_controller    <= o_servo2_gripping_controller_next;
        o_servo3_gripping_controller    <= o_servo3_gripping_controller_next;
        o_servo4_gripping_controller    <= o_servo4_gripping_controller_next;
        o_servo1_directional_controller <= o_servo1_directional_controller_next;
        o_servo2_directional_controller <= o_servo2_directional_controller_next;
        o_servo3_directional_controller <= o_servo3_directional_controller_next;
        o_servo4_directional_controller <= o_servo4_directional_controller_next;
        key                             <= key_next;
        key1                            <= key1_next;
        key2                            <= key2_next;
        key3                            <= key3_next;
        key4                            <= key4_next;
        key5                            <= key5_next;
        key6                            <= key6_next;
        key7                            <= key7_next;
        key8                            <= key8_next;
        o_write_ready                   <= o_write_ready_next;
        current_state                   <= current_state_next;
    end
end 
//---------------------------------------------------- 
always@(*/*posedge mtr_clk or leftRow*/)
begin
    o_servo1_gripping_controller_next    = o_servo1_gripping_controller;
    o_servo2_gripping_controller_next    = o_servo2_gripping_controller;
    o_servo3_gripping_controller_next    = o_servo3_gripping_controller;
    o_servo4_gripping_controller_next    = o_servo4_gripping_controller;
    o_servo1_directional_controller_next = o_servo1_directional_controller;
    o_servo2_directional_controller_next = o_servo2_directional_controller;
    o_servo3_directional_controller_next = o_servo3_directional_controller;
    o_servo4_directional_controller_next = o_servo4_directional_controller;

    key_next                             = key;
    key1_next                            = key1;
    key2_next                            = key2;
    key3_next                            = key3;
    key4_next                            = key4;
    key5_next                            = key5;
    key6_next                            = key6;
    key7_next                            = key7;
    key8_next                            = key8;
    o_write_ready_next                   = o_write_ready;
    current_state_next                   = current_state;
    
    o_servo1_directional_controller_next = 0;
    o_servo1_gripping_controller_next    = 0;

    o_servo2_directional_controller_next = 0;
    o_servo2_gripping_controller_next    = 0;

    o_servo3_directional_controller_next = 0;
    o_servo3_gripping_controller_next    = 0;

    o_servo4_directional_controller_next = 0;
    o_servo4_gripping_controller_next    = 0;

    case(current_state)
    //----------------------------------------------------
    STATE_IDLE: //00001
    begin
        if(scanner_done == 1)
        begin

            if(leftRow == 1)
            begin

                key_next           = 1;
                current_state_next = STATE_LEFT_MOVEMENT;

            end

            if(topRow == 1)
            begin

                key_next           = 1;
                current_state_next = STATE_TOP_MOVEMENT;

            end

            if(bottomRow == 1)
            begin

                key_next           = 1;
                current_state_next = STATE_BOTTOM_MOVEMENT;

            end

            if(rightRow == 1)
            begin

                key_next           = 1;
                current_state_next = STATE_RIGHT_MOVEMENT;

            end
        end

    end
    //----------------------------------------------------
    STATE_LEFT_MOVEMENT: //00010
    begin
    
         if(key == 1)
         begin

            o_write_ready_next                   = 0;
            o_servo1_gripping_controller_next    = 0;
            o_servo1_directional_controller_next = 1; //90 degrees right
            key_next                             = 0;
            key1_next                            = 1;

         end

         if(key1 == 1)
         begin

            key1_next = 0;
            key2_next = 1;

         end

         if(direction1_movement_done_controller == 1 && key2 == 1)
         begin

            o_servo1_directional_controller_next = 0;
            o_servo1_gripping_controller_next    = 1; // opened @90 degrees
            key2_next                            = 0;
            key3_next                            = 1;

         end

         if(key3 == 1)
         begin

            key3_next = 0;
            key4_next = 1;

         end

         if(gripping1_movement_done_controller == 1 && key4 == 1)
         begin

            o_servo1_directional_controller_next = 1;//90 degrees right
            key4_next                            = 0;
            key5_next                            = 1;

         end

         if(key5 == 1)
         begin

            key5_next = 0;
            key6_next = 1;

         end

         if(direction1_movement_done_controller == 1 && key6 == 1)
         begin

            o_servo1_directional_controller_next = 0;
            o_servo1_gripping_controller_next    = 1; //closed @180 degrees
            key6_next                            = 0;
            key7_next                            = 1;

         end

         if(key7 == 1)
         begin

            key7_next = 0;
            key8_next = 1;

         end

         if(gripping1_movement_done_controller == 1 && key8 == 1)
         begin

            key8_next          = 0;
            o_write_ready_next = 1;
            current_state_next = STATE_IDLE;

         end
      end
    //----------------------------------------------------
    STATE_TOP_MOVEMENT: //00100
    begin

        if(key == 1)
        begin

            o_write_ready_next                   = 0;
            o_servo3_gripping_controller_next    = 1; //closed @180 degrees
            o_servo3_directional_controller_next = 0;
            key_next                             = 0;
            key1_next                            = 1;

        end

        if(key1 == 1)
        begin

            key1_next = 0;
            key2_next = 1;

        end

        if(gripping3_movement_done_controller == 1 && key2 == 1)
        begin

            o_servo3_directional_controller_next = 1;// 90 degrees right
            o_servo3_gripping_controller_next    = 0;
            key2_next                            = 0;
            key3_next                            = 1;

        end

        if(key3 == 1)
        begin

            key3_next = 0;
            key4_next = 1;

        end

        if(direction3_movement_done_controller == 1 && key4 == 1)
        begin

            o_servo3_gripping_controller_next = 1;//opened @90 degrees
            key4_next                         = 0;
            key5_next                         = 1;

        end

        if(key5 == 1)
        begin

            key5_next = 0;
            key6_next = 1;

        end

        if(gripping3_movement_done_controller == 1 && key6 == 1)
        begin

            o_servo3_directional_controller_next = 1; //90 degrees right, open @180
            o_servo3_gripping_controller_next    = 0;
            key6_next                            = 0;
            key7_next                            = 1;

        end

        if(key7 == 1)
        begin

            key7_next = 0;
            key8_next = 1;

        end

        if(direction3_movement_done_controller == 1 && key8 == 1)
        begin

            key8_next          = 0;
            o_write_ready_next = 1;
            current_state_next = STATE_IDLE;

        end
    end
    //----------------------------------------------------
    STATE_BOTTOM_MOVEMENT: //01000
    begin

        if(key == 1)
        begin

            o_write_ready_next                   = 0;
            o_servo4_gripping_controller_next    = 0;
            o_servo4_directional_controller_next = 1; //90 degrees right
            key_next                             = 0;
            key1_next                            = 1;

        end

        if(key1 == 1)
        begin

            key1_next = 0;
            key2_next = 1;

        end

        if(direction4_movement_done_controller == 1 && key2 == 1)
        begin

            o_servo4_directional_controller_next = 0;
            o_servo4_gripping_controller_next    = 1; // opened @90 degrees
            key2_next                            = 0;
            key3_next                            = 1;

        end

        if(key3 == 1)
        begin

            key3_next = 0;
            key4_next = 1;

        end

        if(gripping4_movement_done_controller == 1 && key4 == 1)
        begin

            o_servo4_directional_controller_next = 1;//90 degrees right
            key4_next                            = 0;
            key5_next                            = 1;

        end

        if(key5 == 1)
        begin

            key5_next = 0;
            key6_next = 1;

        end

        if(direction4_movement_done_controller == 1 && key6 == 1)
        begin

            o_servo4_directional_controller_next = 0;
            o_servo4_gripping_controller_next    = 1; //closed @180 degrees
            key6_next                            = 0;
            key7_next                            = 1;

        end

        if(key7 == 1)
        begin

            key7_next = 0;
            key8_next = 1;

        end

        if(gripping4_movement_done_controller == 1 && key8 == 1)
        begin

            key8_next          = 0;
            o_write_ready_next = 1;
            current_state_next = STATE_IDLE;

        end

    end
    //----------------------------------------------------
    STATE_RIGHT_MOVEMENT: //10000
    begin

        if(key == 1)
        begin

            o_write_ready_next                   = 0;
            o_servo2_gripping_controller_next    = 0;
            o_servo2_directional_controller_next = 1; //90 degrees right
            key_next                             = 0;
            key1_next                            = 1;

        end

        if(key1 == 1)
        begin

            key1_next = 0;
            key2_next = 1;

        end

        if(direction2_movement_done_controller == 1 && key2 == 1)
        begin

            o_servo2_directional_controller_next = 0;
            o_servo2_gripping_controller_next    = 1; // opened @90 degrees
            key2_next                            = 0;
            key3_next                            = 1;

        end

        if(key3 == 1)
        begin

            key3_next = 0;
            key4_next = 1;

        end

        if(gripping2_movement_done_controller == 1 && key4 == 1)
        begin

            o_servo2_directional_controller_next = 1;//opened @180 degrees
            key4_next                            = 0;
            key5_next                            = 1;

        end

        if(key5 == 1)
        begin

            key5_next = 0;
            key6_next = 1;

        end

        if(direction2_movement_done_controller == 1 && key6 == 1)
        begin

            o_servo2_directional_controller_next = 0;
            o_servo2_gripping_controller_next    = 1; //closed @180 degrees
            key6_next                            = 0;
            key7_next                            = 1;

        end

        if(key7 == 1)
        begin

            key7_next = 0;
            key8_next = 1;

        end

        if(gripping2_movement_done_controller == 1 && key8 == 1)
        begin

            key8_next          = 0;
            o_write_ready_next = 1;
            current_state_next = STATE_IDLE;

        end

    end
    //----------------------------------------------------
    default:
    begin

        current_state_next = STATE_IDLE;

    end
    //----------------------------------------------------
    endcase
end
//---------------------------------------------------- 
endmodule
