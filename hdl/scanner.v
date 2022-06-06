`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/20/2021 03:40:13 PM
// Design Name: 
// Module Name: scanner
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module scanner #(parameter MOTOR_CLOCK_FREQUENCY = 2000)
(
    input       I_sys_clk,//125Mhz
    input       I_rst_button,
    input       I_start_button,
    input       direction1_movement_done,
    input       direction2_movement_done,
    input       direction3_movement_done,
    input       gripping1_movement_done,
    input       gripping2_movement_done,
    input       gripping3_movement_done,

    output      o_motor_clk,
    output reg  clk_posedge_detector,
    output reg  scanner_done,
    output reg  gripper1_orientation_indicator     = 0,
    output reg  gripper2_orientation_indicator     = 0,
    output reg  gripper3_orientation_indicator     = 0,
    output reg  directional1_orientation_indicator = 0,
    output reg  directional2_orientation_indicator = 0,
    output reg  directional3_orientation_indicator = 0,
    output reg  o_servo1_directional               = 0,
    output reg  o_servo2_directional               = 0,
    output reg  o_servo3_directional               = 0,
    output reg  o_servo1_gripping                  = 0,
    output reg  o_servo2_gripping                  = 0,
    output reg  o_servo3_gripping                  = 0
);

//----------------------------------------------------

parameter COUNT_LIMIT                   = (125_000_000/(2*MOTOR_CLOCK_FREQUENCY))-1;
parameter SCANNING_IDLE                 = 8'b00000001;
parameter SCANNING_CUBE_1ST_FACE        = 8'b00000010;
parameter SCANNING_CUBE_2ND_FACE        = 8'b00000100;
parameter SCANNING_CUBE_3RD_FACE        = 8'b00001000;
parameter SCANNING_CUBE_4TH_FACE        = 8'b00010000;
parameter SCANNING_CUBE_5TH_FACE        = 8'b00100000;
parameter SCANNING_CUBE_6TH_FACE        = 8'b01000000;
parameter SCANNING_DONE                 = 8'b10000000;

//----------------------------------------------------

reg [$clog2(COUNT_LIMIT) - 1:0] counter     = 0;
reg                             clk_divider = 0;

reg [12:0] key;
reg [12:0] key_next;
reg [7:0]  cube_current_position;
reg [7:0]  cube_new_position;
reg        I_scanner_clk_sync;
reg        direction1_movement_done_reg;
reg        scanner_done_combinational;

reg       o_servo1_gripping_next;
reg       o_servo2_gripping_next;
reg       o_servo3_gripping_next;
reg       o_servo1_directional_next;
reg       o_servo2_directional_next;
reg       o_servo3_directional_next;
reg       gripper1_orientation_indicator_next;
reg       gripper2_orientation_indicator_next;
reg       gripper3_orientation_indicator_next;
reg       directional1_orientation_indicator_next;
reg       directional2_orientation_indicator_next;
reg       directional3_orientation_indicator_next;

//----------------------------------------------------
always@(posedge I_sys_clk) //clk divider logic 2khz
begin
    counter                 <= counter + 1;
    I_scanner_clk_sync      <= clk_divider;
    clk_posedge_detector    <= (clk_divider == 1 && I_scanner_clk_sync == 0);

        if(counter == COUNT_LIMIT)
        begin

            clk_divider     <=  ~clk_divider;
            counter         <=  0;

        end
end
//----------------------------------------------------

assign  o_motor_clk = clk_divider;

//---------------------Sequential Logic----------------------------------------------
always@(posedge I_sys_clk or posedge I_rst_button)
begin
    if(I_rst_button)
    begin
        cube_current_position              <= SCANNING_IDLE;
        o_servo1_gripping                  <= 0;
        o_servo2_gripping                  <= 0;
        o_servo3_gripping                  <= 0;
        o_servo1_directional               <= 0;
        o_servo2_directional               <= 0;
        o_servo3_directional               <= 0;
        gripper1_orientation_indicator     <= 0;//0 = initially closed
        gripper2_orientation_indicator     <= 0;//0 = initially closed
        gripper3_orientation_indicator     <= 0;//0 = initially opened
        directional1_orientation_indicator <= 0;
        directional2_orientation_indicator <= 0;
        directional3_orientation_indicator <= 0;
        key[0]                             <= 0;
        key[1]                             <= 0;
        key[2]                             <= 0;
        key[3]                             <= 0;
        key[4]                             <= 0;
        key[5]                             <= 0;
        key[6]                             <= 0;
        key[7]                             <= 0;
        key[8]                             <= 0;
        key[9]                             <= 0;
        key[10]                            <= 0;
        key[11]                            <= 0;
        key[12]                            <= 0;
        scanner_done                       <= 1;

    end
    else
    begin
        cube_current_position              <= cube_new_position;
        o_servo1_gripping                  <= o_servo1_gripping_next;
        o_servo2_gripping                  <= o_servo2_gripping_next;
        o_servo3_gripping                  <= o_servo3_gripping_next;
        o_servo1_directional               <= o_servo1_directional_next;
        o_servo2_directional               <= o_servo2_directional_next;
        o_servo3_directional               <= o_servo3_directional_next;
        gripper1_orientation_indicator     <= gripper1_orientation_indicator_next;
        gripper2_orientation_indicator     <= gripper2_orientation_indicator_next;
        gripper3_orientation_indicator     <= gripper3_orientation_indicator_next;
        directional1_orientation_indicator <= directional1_orientation_indicator_next;
        directional2_orientation_indicator <= directional2_orientation_indicator_next;
        directional3_orientation_indicator <= directional3_orientation_indicator_next;
        key[0]                             <= key_next[0];
        key[1]                             <= key_next[1];
        key[2]                             <= key_next[2];
        key[3]                             <= key_next[3];
        key[4]                             <= key_next[4];
        key[5]                             <= key_next[5];
        key[6]                             <= key_next[6];
        key[7]                             <= key_next[7];
        key[8]                             <= key_next[8];
        key[9]                             <= key_next[9];
        key[10]                            <= key_next[10];
        key[11]                            <= key_next[11];
        key[12]                            <= key_next[12];
        scanner_done                       <= scanner_done_combinational;

    end
end

//-------------------------Combinatorial Logic--------------------------------------------
always@(*)
begin
    cube_new_position                       = cube_current_position;
    o_servo1_gripping_next                  = o_servo1_gripping;
    o_servo2_gripping_next                  = o_servo2_gripping;
    o_servo3_gripping_next                  = o_servo3_gripping;
    o_servo1_directional_next               = o_servo1_directional;
    o_servo2_directional_next               = o_servo2_directional;
    o_servo3_directional_next               = o_servo3_directional;
    gripper1_orientation_indicator_next     = gripper1_orientation_indicator;
    gripper2_orientation_indicator_next     = gripper2_orientation_indicator;
    gripper3_orientation_indicator_next     = gripper3_orientation_indicator;
    directional1_orientation_indicator_next = directional1_orientation_indicator;
    directional2_orientation_indicator_next = directional2_orientation_indicator;
    directional3_orientation_indicator_next = directional3_orientation_indicator;
    scanner_done_combinational              = scanner_done;
    key_next[0]                             = key[0];
    key_next[1]                             = key[1];
    key_next[2]                             = key[2];
    key_next[3]                             = key[3];
    key_next[4]                             = key[4];
    key_next[5]                             = key[5];
    key_next[6]                             = key[6];
    key_next[7]                             = key[7];
    key_next[8]                             = key[8];
    key_next[9]                             = key[9];
    key_next[10]                            = key[10];
    key_next[11]                            = key[11];
    key_next[12]                            = key[12];

    case(cube_current_position)
    //----------------------------------------------------
    SCANNING_IDLE: //00000001
    begin

           if(I_start_button == 1)
           begin

               cube_new_position          = SCANNING_CUBE_1ST_FACE;
               scanner_done_combinational = 0;

           end
           else
           begin

               cube_new_position          = SCANNING_IDLE;
               scanner_done_combinational = 1;

           end

    end
    //----------------------------------------------------
    SCANNING_CUBE_1ST_FACE: //00000010
    begin
        if(clk_posedge_detector == 1)
        begin

             o_servo1_gripping_next                  = 0; //currently closed @180
             o_servo2_gripping_next                  = 0; //currently closed @180
             o_servo3_gripping_next                  = 0; //currently open @180

             cube_new_position                       = SCANNING_CUBE_2ND_FACE;
             key_next[0]                             = 1;
             o_servo1_directional_next               = 1; //90 degrees left, closed @90
             o_servo2_directional_next               = 1; //90 degrees right, closed @90
             directional1_orientation_indicator_next = 1;
             directional2_orientation_indicator_next = 1;

        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_2ND_FACE: //00000100
    begin
        if(clk_posedge_detector == 1)
        begin

            if(direction1_movement_done == 1 & key[0] == 1)
            begin

                key_next[0]                         = 0;
                key_next[1]                         = 1;
                o_servo1_directional_next           = 0;
                o_servo2_directional_next           = 0;
                o_servo3_gripping_next              = 1;//closed @180
                gripper3_orientation_indicator_next = 1;

            end

            if(gripping3_movement_done == 1 & key[1] == 1)
            begin

                key_next[1]                         = 0;
                key_next[2]                         = 1;
                o_servo1_gripping_next              = 1; //now opened @90
                gripper1_orientation_indicator_next = 1;
                o_servo2_gripping_next              = 1; //now opened @90
                gripper2_orientation_indicator_next = 1;
                o_servo3_gripping_next              = 0;

            end

            if(gripping1_movement_done == 1 && gripping2_movement_done == 1 && key[2] == 1)
            begin

                key_next[2]                             = 0;
                o_servo1_gripping_next                  = 0;
                o_servo2_gripping_next                  = 0;
                o_servo1_directional_next               = 1; //90 degrees left, opened @180
                directional1_orientation_indicator_next = 0;
                o_servo2_directional_next               = 1; //90 degrees right, opened @180
                directional2_orientation_indicator_next = 0;
                key_next[3]                             = 1;

            end

            if(direction1_movement_done == 1 && gripping3_movement_done == 1 && key[3] == 1 )
            begin

                key_next[3]                         = 0;
                o_servo1_directional_next           = 0;
                o_servo2_directional_next           = 0;
                o_servo3_gripping_next              = 0;
                cube_new_position                   = SCANNING_CUBE_3RD_FACE;
                o_servo1_gripping_next              = 1; //closed @180
                gripper1_orientation_indicator_next = 0;
                o_servo2_gripping_next              = 1; //closed @180
                gripper2_orientation_indicator_next = 0;
                key_next[12]                        = 1;

            end
        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_3RD_FACE: //00001000
    begin
        if(clk_posedge_detector == 1)
        begin

            if(key[12] == 1)
            begin

                key_next[12]           = 0;
                key_next[2]            = 1;

            end

             if(gripping1_movement_done == 1 && key[2] == 1)
             begin

                key_next[2]                         = 0;
                o_servo1_gripping_next              = 0;
                o_servo2_gripping_next              = 0;
                o_servo3_gripping_next              = 1;//opened @180
                gripper3_orientation_indicator_next = 0;
                key_next[1]                         = 1;

             end

             if(key[1] == 1)
             begin

                key_next[1] = 0;
                key_next[0] = 1;

             end

             if(gripping3_movement_done == 1 && key[0] == 1)
             begin

                o_servo3_gripping_next                  = 0;
                o_servo1_directional_next               = 1; //90 degrees left, closed @90
                directional1_orientation_indicator_next = 1;
                o_servo2_directional_next               = 1; //90 degrees right, closed @90
                directional2_orientation_indicator_next = 1;
                key_next[10]                            = 1;
                key_next[0]                             = 0;

             end

             if(key[10] == 1)
             begin

                key_next[10] = 0;
                key_next[11] = 1;

             end

             if(direction1_movement_done == 1 && key[11] == 1)
             begin

                o_servo3_gripping_next              = 1;//closed @180
                gripper3_orientation_indicator_next = 1;
                o_servo1_directional_next           = 0;
                o_servo2_directional_next           = 0;
                key_next[11]                        = 0;
                key_next[3]                         = 1;

             end

             if(key[3] == 1)
             begin

                key_next[3] = 0;
                key_next[4] = 1;

             end

             if(gripping3_movement_done == 1 && key[4] == 1)
             begin

                o_servo1_gripping_next              = 1; //opened @90
                gripper1_orientation_indicator_next = 1;
                o_servo2_gripping_next              = 1; //opened @90
                gripper2_orientation_indicator_next = 1;
                o_servo3_gripping_next              = 0;
                key_next[4]                         = 0;
                key_next[5]                         = 1;

             end

            if(key[5] == 1)
             begin

                key_next[5] = 0;
                key_next[6] = 1;

             end

             if(gripping1_movement_done == 1 && key[6] == 1)
             begin

                o_servo1_gripping_next                  = 0;
                o_servo2_gripping_next                  = 0;
                o_servo1_directional_next               = 1;
                directional1_orientation_indicator_next = 0;
                o_servo2_directional_next               = 1;
                directional2_orientation_indicator_next = 0;
                key_next[6]                             = 0;
                key_next[7]                             = 1;

             end

             if(key[7] == 1)
             begin

                key_next[7] = 0;
                key_next[8] = 1;

             end

             if(direction1_movement_done == 1 && key[8] == 1)
             begin

                key_next[8]                         = 0;
                o_servo1_directional_next           = 0;
                o_servo2_directional_next           = 0;
                cube_new_position                   = SCANNING_CUBE_4TH_FACE;
                o_servo1_gripping_next              = 1; //closed @180
                gripper1_orientation_indicator_next = 0;
                o_servo2_gripping_next              = 1; //closed @180
                gripper2_orientation_indicator_next = 0;
                key_next[9]                         = 1;

             end

        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_4TH_FACE: //00010000
    begin
        if(clk_posedge_detector == 1)
        begin

            if(key[9] == 1)
            begin

                key_next[9] = 0;
                key_next[2] = 1;

            end

             if(gripping1_movement_done == 1 && key[2] == 1)
             begin

                key_next[2]                         = 0;
                o_servo1_gripping_next              = 0;
                o_servo2_gripping_next              = 0;
                o_servo3_gripping_next              = 1;//opened @180
                gripper3_orientation_indicator_next = 0;
                key_next[1]                         = 1;

             end

             if(key[1] == 1)
             begin

                key_next[1] = 0;
                key_next[0] = 1;

             end

             if(gripping3_movement_done == 1 && key[0] == 1)
             begin

                o_servo3_gripping_next                  = 0;
                o_servo1_directional_next               = 1; //90 degrees left, closed @90
                directional1_orientation_indicator_next = 1;
                o_servo2_directional_next               = 1; //90 degrees right, closed @90
                directional2_orientation_indicator_next = 1;
                key_next[12]                            = 1;
                key_next[0]                             = 0;

             end

             if(key[12] == 1)
             begin

                key_next[12]  = 0;
                key_next[11]  = 1;

             end

             if(direction1_movement_done == 1 && key[11] == 1)
             begin

                o_servo3_gripping_next              = 1;//closed @180
                gripper3_orientation_indicator_next = 1;
                o_servo1_directional_next           = 0;
                o_servo2_directional_next           = 0;
                key_next[11]                        = 0;
                key_next[3]                         = 1;

             end

             if(key[3] == 1)
             begin

                key_next[3] = 0;
                key_next[4] = 1;

             end

             if(gripping3_movement_done == 1 && key[4] == 1)
             begin

                o_servo1_gripping_next              = 1; //opened @90
                gripper1_orientation_indicator_next = 1;
                o_servo2_gripping_next              = 1; //opened @90
                gripper2_orientation_indicator_next = 1;
                o_servo3_gripping_next              = 0;
                key_next[4]                         = 0;
                key_next[5]                         = 1;

             end

            if(key[5] == 1)
             begin

                key_next[5] = 0;
                key_next[6] = 1;

             end

             if(gripping1_movement_done == 1 && key[6] == 1)
             begin

                o_servo1_gripping_next                  = 0;
                o_servo2_gripping_next                  = 0;
                o_servo1_directional_next               = 1;
                directional1_orientation_indicator_next = 0;
                o_servo2_directional_next               = 1;
                directional2_orientation_indicator_next = 0;
                key_next[6]                             = 0;
                key_next[7]                             = 1;

             end

             if(key[7] == 1)
             begin

                key_next[7] = 0;
                key_next[8] = 1;

             end

             if(direction1_movement_done == 1 && key[8] == 1)
             begin

                key_next[8]                             = 0;
                o_servo1_directional_next               = 0;
                o_servo2_directional_next               = 0;
                cube_new_position                       = SCANNING_CUBE_5TH_FACE;
                key_next[1]                             = 1;
                o_servo3_directional_next               = 1; // 90 degrees right, closed at @90
                directional3_orientation_indicator_next = 1;

             end

        end
    end
    //----------------------------------------------------
    //Horizontal scanning
    SCANNING_CUBE_5TH_FACE: //00100000
    begin
        if(clk_posedge_detector == 1)
        begin

            if(key[1] == 1)
            begin

                key_next[0] = 1;
                key_next[1] = 0;

            end

            if(key[0] == 1)
            begin

                key_next[0]  = 0;
                key_next[11] = 1;

            end

            if(key[11] == 1)
            begin

                key_next[11] = 0;
                key_next[8]  = 1;

            end

            if(direction3_movement_done == 1 && key[8] == 1)
            begin

                key_next[8]                         = 0;
                o_servo3_directional_next           = 0;
                o_servo1_gripping_next              = 1; //closed @180
                gripper1_orientation_indicator_next = 0;
                o_servo2_gripping_next              = 1; //closed @180
                gripper2_orientation_indicator_next = 0;
                key_next[7]                         = 1;

            end

            if(key[7] == 1)
            begin

                key_next[7] = 0;
                key_next[6] = 1;

            end

            if(gripping1_movement_done == 1 && key[6] == 1)
            begin

                o_servo1_gripping_next              = 0;
                o_servo2_gripping_next              = 0;
                o_servo3_gripping_next              = 1; //opened @90 degrees
                gripper3_orientation_indicator_next = 0;
                key_next[6]                         = 0;
                key_next[5]                         = 1;

            end

            if(key[5] == 1)
            begin

                key_next[5] = 0;
                key_next[4] = 1;

            end

            if(gripping3_movement_done == 1 && key[4] == 1)
            begin

                o_servo3_gripping_next                  = 0;
                o_servo3_directional_next               = 1; //90 degrees right, opened @180
                directional3_orientation_indicator_next = 0;
                key_next[4]                             = 0;
                key_next[3]                             = 1;

            end

            if(key[3] == 1)
            begin

                key_next[3] = 0;
                key_next[9] = 1;

            end

            if(key[9] == 1)
            begin

                key_next[9]  = 0;
                key_next[10] = 1;

            end

            if(key[10] == 1)
            begin

                key_next[10] = 0;
                key_next[2]  = 1;

            end

            if(direction3_movement_done == 1 && key[2] == 1)
            begin

                key_next[2]                         = 0;
                o_servo3_directional_next           = 0;
                cube_new_position                   = SCANNING_CUBE_6TH_FACE;
                key_next[1]                         = 1;
                o_servo3_gripping_next              = 1; // closed @180 degrees
                gripper3_orientation_indicator_next = 1;

            end
        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_6TH_FACE: //01000000
    begin
        if(clk_posedge_detector == 1)
        begin

            if(gripping3_movement_done == 1 && key[1] == 1)
            begin

                key_next[1]                         = 0;
                o_servo3_gripping_next              = 0;
                o_servo1_gripping_next              = 1; //opened @180
                gripper1_orientation_indicator_next = 1;
                o_servo2_gripping_next              = 1; //opened @180
                gripper2_orientation_indicator_next = 1;
                key_next[8]                         = 1;

            end

            if(key[8] == 1)
            begin

                key_next[8] = 0;
                key_next[7] = 1;

            end

            if(gripping1_movement_done == 1 && key[7] == 1)
            begin

                key_next[7]                             = 0;
                o_servo1_gripping_next                  = 0;
                o_servo2_gripping_next                  = 0;
                o_servo3_directional_next               = 1; //180 degrees right, closed @80 with corresponding duty cycle
                directional3_orientation_indicator_next = 1;
                key_next[6]                             = 1;

            end

            if(key[6] == 1)
            begin

                key_next[6] = 0;
                key_next[9] = 1;

            end

            if(key[9] == 1)
            begin

                key_next[9]  = 0;
                key_next[10] = 1;

            end

            if(key[10] == 1)
            begin

                key_next[10] = 0;
                key_next[5]  = 1;

            end

            if(direction3_movement_done == 1 && key[5] == 1)
            begin

                o_servo3_directional_next           = 0;
                key_next[5]                         = 0;
                cube_new_position                   = SCANNING_DONE;
                key_next[6]                         = 1;
                o_servo1_gripping_next              = 1; //closed @180
                gripper1_orientation_indicator_next = 0;
                o_servo2_gripping_next              = 1; //closed @180
                gripper2_orientation_indicator_next = 0;

            end
        end
    end
    //----------------------------------------------------
    SCANNING_DONE: //10000000
    begin
        if(clk_posedge_detector == 1)
        begin

            if(gripping1_movement_done == 1 && key[6] == 1)
            begin

                o_servo1_gripping_next              = 0;
                o_servo2_gripping_next              = 0;
                o_servo3_gripping_next              = 1;
                gripper3_orientation_indicator_next = 0;
                key_next[6]                         = 0;
                key_next[8]                         = 1;

            end

            if(key[8] == 1)
            begin

                key_next[8] = 0;
                key_next[9] = 1;

            end

            if(key[9] == 1)
            begin

                key_next[9]  = 0;
                key_next[10] = 1;

            end

            if(key[10] == 1)
            begin

                key_next[10]             = 0;
                key_next[7]              = 1;
                o_servo3_gripping_next   = 0;

            end

            if(key[7] == 1)
            begin

                key_next[7]         = 0;
                cube_new_position   = SCANNING_IDLE;

            end

        end
    end
    //----------------------------------------------------
        default:
        begin
            cube_new_position = SCANNING_IDLE;
        end
    //----------------------------------------------------
        endcase
end   
endmodule
