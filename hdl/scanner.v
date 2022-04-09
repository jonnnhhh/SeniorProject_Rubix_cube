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
module scanner
(
    input I_sys_clk,//125Mhz
    input I_rst_button,
    input I_start_button,
    input direction1_movement_done,
    input direction2_movement_done,
    input direction3_movement_done,
    input gripping1_movement_done,
    input gripping2_movement_done,
    input gripping3_movement_done,

    output reg o_servo1_directional,
    output reg o_servo2_directional,
    output reg o_servo3_directional,
    output reg o_servo1_gripping,
    output reg o_servo2_gripping,
    output reg o_servo3_gripping,
    output     o_motor_clk,
    output reg scanner_clk_posedge_detector,
    output reg scanner_done
);

//----------------------------------------------------

parameter SCANNING_IDLE               = 8'b00000001;
parameter SCANNING_CUBE_1ST_FACE      = 8'b00000010;
parameter SCANNING_CUBE_2ND_FACE      = 8'b00000100;
parameter SCANNING_CUBE_3RD_FACE      = 8'b00001000;
parameter SCANNING_CUBE_4TH_FACE      = 8'b00010000;
parameter SCANNING_CUBE_5TH_FACE      = 8'b00100000;
parameter SCANNING_CUBE_6TH_FACE      = 8'b01000000;
parameter SCANNING_DONE               = 8'b10000000;

//----------------------------------------------------
reg [7:0] cube_current_position; //mem holder
reg [7:0] cube_new_position;
reg       o_servo1_gripping_next;
reg       o_servo2_gripping_next;
reg       o_servo3_gripping_next;
reg       o_servo1_directional_next;
reg       o_servo2_directional_next;
reg       o_servo3_directional_next;
reg       key,key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12;
reg       key_next,key1_next,key2_next,key3_next,key4_next,key5_next,
          key6_next,key7_next,key8_next,key9_next,key10_next,key11_next,key12_next;

reg [14:0] count_limit        = 62; //1249999; //50hz
reg [14:0] counter            = 0;
reg        I_scanner_clk      = 0;
reg        I_scanner_clk_sync;
reg        direction1_movement_done_reg;
reg        scanner_done_combinational;

//----------------------------------------------------    
always@(posedge I_sys_clk) //clk divider logic 50hz
begin
    counter                      <= counter+1;
    I_scanner_clk_sync           <= I_scanner_clk;
    scanner_clk_posedge_detector <= (I_scanner_clk == 1 && I_scanner_clk_sync == 0);

        if(counter == count_limit)
        begin

            I_scanner_clk <=~I_scanner_clk;
            counter       <=0;

        end
end
//----------------------------------------------------
assign  o_motor_clk = I_scanner_clk;
//----------------------------------------------------  
always@(posedge I_sys_clk or posedge I_rst_button)
begin
    if(I_rst_button)
    begin
        cube_current_position <= SCANNING_IDLE;
        o_servo1_gripping     <= 0;
        o_servo2_gripping     <= 0;
        o_servo3_gripping     <= 0;
        o_servo1_directional  <= 0;
        o_servo2_directional  <= 0;
        o_servo3_directional  <= 0;
        key                   <= 0;
        key1                  <= 0;
        key2                  <= 0;
        key3                  <= 0;
        key4                  <= 0;
        key5                  <= 0;
        key6                  <= 0;
        key7                  <= 0;
        key8                  <= 0;
        key9                  <= 0;
        key10                 <= 0;
        key11                 <= 0;
        key12                 <= 0;
        scanner_done          <= 1;
    
    end
    else
    begin 
        cube_current_position <= cube_new_position;
        o_servo1_gripping     <= o_servo1_gripping_next;
        o_servo2_gripping     <= o_servo2_gripping_next;
        o_servo3_gripping     <= o_servo3_gripping_next;
        o_servo1_directional  <= o_servo1_directional_next;
        o_servo2_directional  <= o_servo2_directional_next;
        o_servo3_directional  <= o_servo3_directional_next;
        key                   <= key_next;
        key1                  <= key1_next;
        key2                  <= key2_next;
        key3                  <= key3_next;
        key4                  <= key4_next;
        key5                  <= key5_next;
        key6                  <= key6_next;
        key7                  <= key7_next;
        key8                  <= key8_next;
        key9                  <= key9_next;
        key10                 <= key10_next;
        key11                 <= key11_next;
        key12                 <= key12_next;
        scanner_done          <= scanner_done_combinational;
    end
end 
//----------------------------------------------------    
//vertical scanning
always@(*)
begin
    cube_new_position          = cube_current_position;
    o_servo1_gripping_next     = o_servo1_gripping;
    o_servo2_gripping_next     = o_servo2_gripping;
    o_servo3_gripping_next     = o_servo3_gripping;
    o_servo1_directional_next  = o_servo1_directional;
    o_servo2_directional_next  = o_servo2_directional;
    o_servo3_directional_next  = o_servo3_directional;
    key_next                   = key;
    key1_next                  = key1;
    key2_next                  = key2;
    key3_next                  = key3;
    key4_next                  = key4;
    key5_next                  = key5;
    key6_next                  = key6;
    key7_next                  = key7;
    key8_next                  = key8;
    key9_next                  = key9;
    key10_next                 = key10;
    key11_next                 = key11;
    key12_next                 = key12;
    scanner_done_combinational = scanner_done;
    //----------------------------------------------------
        case(cube_current_position)
    SCANNING_IDLE: //00000001
    begin
        if(scanner_clk_posedge_detector == 1)
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
    end
    //----------------------------------------------------
    SCANNING_CUBE_1ST_FACE: //00000010
    begin
        if(scanner_clk_posedge_detector == 1)
        begin
             o_servo1_gripping_next    = 0; //currently closed @180
             o_servo2_gripping_next    = 0; //currently closed @180
             o_servo3_gripping_next    = 0; ////currently open @180
             cube_new_position         = SCANNING_CUBE_2ND_FACE;
             o_servo3_directional_next = 0;
             o_servo1_gripping_next    = 0;
             o_servo2_gripping_next    = 0;
             o_servo3_gripping_next    = 0;
             key_next                  = 1;
             o_servo1_directional_next = 1; //90 degrees left, closed @90
             o_servo2_directional_next = 1; //90 degrees right, closed @90

        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_2ND_FACE: //00000100
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(direction1_movement_done == 1 & key == 1)
            begin

                key_next                  = 0;
                key1_next                 = 1;
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                o_servo3_gripping_next    = 1;//closed @180

            end

            if(gripping3_movement_done == 1 & key1 == 1)
            begin

                key1_next              = 0;
                key2_next              = 1;
                o_servo1_gripping_next = 1; //now opened @90
                o_servo2_gripping_next = 1; //now opened @90
                o_servo3_gripping_next = 0;

            end

            if(gripping1_movement_done == 1 && gripping2_movement_done == 1 && key2 == 1)
            begin

                key2_next                 = 0;
                o_servo1_gripping_next    = 0;
                o_servo2_gripping_next    = 0;
                o_servo1_directional_next = 1; //90 degrees left, opened @180
                o_servo2_directional_next = 1; //90 degrees right, opened @180
                key3_next                 = 1;

            end

            if(direction1_movement_done == 1 && gripping3_movement_done == 1 && key3 == 1 )
            begin

                key3_next                 = 0;
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                o_servo3_gripping_next    = 0;
                cube_new_position         = SCANNING_CUBE_3RD_FACE;
                o_servo1_gripping_next    = 1; //closed @180
                o_servo2_gripping_next    = 1; //closed @180
                key12_next                = 1;

            end
        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_3RD_FACE: //00001000
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(key12 == 1)
            begin

                key12_next           = 0;
                key2_next            = 1;

            end

             if(gripping1_movement_done == 1 && key2 == 1)
             begin

                key2_next              = 0;
                o_servo1_gripping_next = 0;
                o_servo2_gripping_next = 0;
                o_servo3_gripping_next = 1;//opened @180
                key1_next              = 1;

             end

             if(key1 == 1)
             begin

                key1_next = 0;
                key_next  = 1;

             end

             if(gripping3_movement_done == 1 && key == 1)
             begin

                o_servo3_gripping_next    = 0;
                o_servo1_directional_next = 1; //90 degrees left, closed @90
                o_servo2_directional_next = 1; //90 degrees right, closed @90
                key10_next                = 1;
                key_next                  = 0;

             end

             if(key10 == 1)
             begin

                key10_next = 0;
                key11_next = 1;

             end

             if(direction1_movement_done == 1 && key11 == 1)
             begin

                o_servo3_gripping_next    = 1;//closed @180
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                key11_next                = 0;
                key3_next                 = 1;

             end

             if(key3 == 1)
             begin

                key3_next = 0;
                key4_next = 1;

             end

             if(gripping3_movement_done == 1 && key4 == 1)
             begin

                o_servo1_gripping_next = 1; //opened @90
                o_servo2_gripping_next = 1; //opened @90
                o_servo3_gripping_next = 0;
                key4_next              = 0;
                key5_next              = 1;

             end

            if(key5 == 1)
             begin

                key5_next = 0;
                key6_next = 1;

             end

             if(gripping1_movement_done == 1 && key6 == 1)
             begin

                o_servo1_gripping_next    = 0;
                o_servo2_gripping_next    = 0;
                o_servo1_directional_next = 1;
                o_servo2_directional_next = 1;
                key6_next                 = 0;
                key7_next                 = 1;

             end

             if(key7 == 1)
             begin

                key7_next = 0;
                key8_next = 1;

             end

             if(direction1_movement_done == 1 && key8 == 1)
             begin

                key8_next                 = 0;
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                cube_new_position         = SCANNING_CUBE_4TH_FACE;
                o_servo1_gripping_next    = 1; //closed @180
                o_servo2_gripping_next    = 1; //closed @180
                key9_next                 = 1;

             end

        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_4TH_FACE: //00010000
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(key9 == 1)
            begin

                key9_next = 0;
                key2_next = 1;

            end

             if(gripping1_movement_done == 1 && key2 == 1)
             begin

                key2_next              = 0;
                o_servo1_gripping_next = 0;
                o_servo2_gripping_next = 0;
                o_servo3_gripping_next = 1;//opened @180
                key1_next              = 1;

             end

             if(key1 == 1)
             begin

                key1_next = 0;
                key_next = 1;

             end

             if(gripping3_movement_done == 1 && key == 1)
             begin

                o_servo3_gripping_next    = 0;
                o_servo1_directional_next = 1; //90 degrees left, closed @90
                o_servo2_directional_next = 1; //90 degrees right, closed @90
                key12_next                = 1;
                key_next                  = 0;

             end

             if(key12 == 1)
             begin

                key12_next  = 0;
                key11_next  = 1;

             end

             if(direction1_movement_done == 1 && key11 == 1)
             begin

                o_servo3_gripping_next    = 1;//closed @180
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                key11_next                = 0;
                key3_next                 = 1;

             end

             if(key3 == 1)
             begin

                key3_next = 0;
                key4_next = 1;

             end

             if(gripping3_movement_done == 1 && key4 == 1)
             begin

                o_servo1_gripping_next = 1; //opened @90
                o_servo2_gripping_next = 1; //opened @90
                o_servo3_gripping_next = 0;
                key4_next              = 0;
                key5_next              = 1;

             end

            if(key5 == 1)
             begin

                key5_next = 0;
                key6_next = 1;

             end

             if(gripping1_movement_done == 1 && key6 == 1)
             begin

                o_servo1_gripping_next    = 0;
                o_servo2_gripping_next    = 0;
                o_servo1_directional_next = 1;
                o_servo2_directional_next = 1;
                key6_next                 = 0;
                key7_next                 = 1;

             end

             if(key7 == 1)
             begin

                key7_next = 0;
                key8_next = 1;

             end

             if(direction1_movement_done == 1 && key8 == 1)
             begin

                key8_next                 = 0;
                o_servo1_directional_next = 0;
                o_servo2_directional_next = 0;
                cube_new_position         = SCANNING_CUBE_5TH_FACE;
                key1_next                 = 1;
                o_servo3_directional_next = 1; // 90 degrees right, closed at @90

             end

        end
    end
    //----------------------------------------------------
    //Horizontal scanning
    SCANNING_CUBE_5TH_FACE: //00100000
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(key1 == 1)
            begin

                key_next  = 1;
                key1_next = 0;

            end

            if(key == 1)
            begin

                key_next   = 0;
                key11_next = 1;

            end

            if(key11 == 1)
            begin

                key11_next = 0;
                key8_next  = 1;

            end

            if(direction3_movement_done == 1 && key8 == 1)
            begin

                key8_next                 = 0;
                o_servo3_directional_next = 0;
                o_servo1_gripping_next    = 1; //closed @180
                o_servo2_gripping_next    = 1; //closed @180
                key7_next                 = 1;

            end

            if(key7 == 1)
            begin

                key7_next = 0;
                key6_next = 1;

            end

            if(gripping1_movement_done == 1 && key6 == 1)
            begin

                o_servo1_gripping_next = 0;
                o_servo2_gripping_next = 0;
                o_servo3_gripping_next = 1; //opened @90 degrees
                key6_next              = 0;
                key5_next              = 1;

            end

            if(key5 == 1)
            begin

                key5_next = 0;
                key4_next = 1;

            end

            if(gripping3_movement_done == 1 && key4 == 1)
            begin

                o_servo3_gripping_next    = 0;
                o_servo3_directional_next = 1; //90 degrees right, opened @180
                key4_next                 = 0;
                key3_next                 = 1;

            end

            if(key3 == 1)
            begin

                key3_next = 0;
                key9_next = 1;

            end

            if(key9 == 1)
            begin

                key9_next = 0;
                key10_next = 1;

            end

            if(key10 == 1)
            begin

                key10_next = 0;
                key2_next = 1;

            end

            if(direction3_movement_done == 1 && key2 == 1)
            begin

                key2_next                 = 0;
                o_servo3_directional_next = 0;
                cube_new_position         = SCANNING_CUBE_6TH_FACE;
                key1_next                 = 1;
                o_servo3_gripping_next    = 1; // closed @180 degrees

            end
        end
    end
    //----------------------------------------------------
    SCANNING_CUBE_6TH_FACE: //01000000
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(gripping3_movement_done == 1 && key1 == 1)
            begin

                key1_next              = 0;
                o_servo3_gripping_next = 0;
                o_servo1_gripping_next = 1; //opened @180
                o_servo2_gripping_next = 1; //opened @180
                key8_next              = 1;

            end

            if(key8 == 1)
            begin

                key8_next = 0;
                key7_next = 1;

            end

            if(gripping1_movement_done == 1 && key7 == 1)
            begin

                key7_next                 = 0;
                o_servo1_gripping_next    = 0;
                o_servo2_gripping_next    = 0;
                o_servo3_directional_next = 1; //180 degrees right, closed @80 with corresponding duty cycle
                key6_next                 = 1;

            end

            if(key6 == 1)
            begin

                key6_next = 0;
                key9_next = 1;

            end

            if(key9 == 1)
            begin

                key9_next  = 0;
                key10_next = 1;

            end

            if(key10 == 1)
            begin

                key10_next = 0;
                key5_next  = 1;

            end

            if(direction3_movement_done == 1 && key5 == 1)
            begin

                o_servo3_directional_next = 0;
                key5_next                 = 0;
                cube_new_position         = SCANNING_DONE;
                key6_next                 = 1;
                o_servo1_gripping_next    = 1; //closed @180
                o_servo2_gripping_next    = 1; //closed @180

            end
        end
    end
    //----------------------------------------------------
    SCANNING_DONE: //10000000
    begin
        if(scanner_clk_posedge_detector == 1)
        begin

            if(gripping1_movement_done == 1 && key6 == 1)
            begin

                o_servo1_gripping_next = 0;
                o_servo2_gripping_next = 0;
                o_servo3_gripping_next = 1;
                key6_next              = 0;
                key8_next              = 1;

            end

            if(key8 == 1)
            begin

                key8_next = 0;
                key9_next = 1;

            end

            if(key9 == 1)
            begin

                key9_next  = 0;
                key10_next = 1;

            end

            if(key10 == 1)
            begin

                key10_next             = 0;
                key7_next              = 1;
                o_servo3_gripping_next = 0;

            end

            if(key7 == 1)
            begin

                key7_next         = 0;
                cube_new_position = SCANNING_IDLE;

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
