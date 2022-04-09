`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 05:03:44 PM
// Design Name: 
// Module Name: UART_Check_data
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
module UART_Check_data
(
    input            I_sys_clk,
    input            I_rst,
    input      [7:0] I_write_data, //8bit ASCII value coming in
    input            I_read_data_valid,

    output reg [6:0] o_write_enable
);
//----------------------------------------------------
//a [Left movement] = 01100001
//w [top movement] = 01110111
//s [bottom movement] = 01110011
//d [right movemment] = 01100100
//b [scanner start button] = 01100010
//n [scanner reset button] = 01101110
//m [user controller reset button] = 01101110
//----------------------------------------------------
parameter STATE_IDLE            = 8'b00000001;
parameter STATE_LEFT_MOVEMENT   = 8'b00000010;
parameter STATE_TOP_MOVEMENT    = 8'b00000100;
parameter STATE_BOTTOM_MOVEMENT = 8'b00001000;
parameter STATE_RIGHT_MOVEMENT  = 8'b00010000;
parameter STATE_SCANNER_START   = 8'b00100000;
parameter STATE_SCANNER_RST     = 8'b01000000;
parameter STATE_USER_RST        = 8'b10000000;
//----------------------------------------------------
reg [6:0] o_write_enable_next;
reg [7:0] current_state,current_state_next;
//----------------------------------------------------
//sequential
always@(posedge I_sys_clk, posedge I_rst)
begin
        if(I_rst == 1)
        begin

        o_write_enable[0] <=0; //left movement
        o_write_enable[1] <=0; //top movement
        o_write_enable[2] <=0; //bottom movement
        o_write_enable[3] <=0; //right movement
        o_write_enable[4] <=0; //scanner start
        o_write_enable[5] <=0; //scanner rst
        o_write_enable[6] <=0; //user rst
        current_state     <= STATE_IDLE;

        end

        else
        begin

        o_write_enable[0] <= o_write_enable_next[0];
        o_write_enable[1] <= o_write_enable_next[1];
        o_write_enable[2] <= o_write_enable_next[2];
        o_write_enable[3] <= o_write_enable_next[3];
        o_write_enable[4] <= o_write_enable_next[4];
        o_write_enable[5] <= o_write_enable_next[5];
        o_write_enable[6] <= o_write_enable_next[6];
        current_state  <= current_state_next;

        end
end

always@(*)
begin

    o_write_enable_next[0] = o_write_enable[0];
    o_write_enable_next[1] = o_write_enable[1];
    o_write_enable_next[2] = o_write_enable[2];
    o_write_enable_next[3] = o_write_enable[3];
    o_write_enable_next[4] = o_write_enable[4];
    o_write_enable_next[5] = o_write_enable[5];
    o_write_enable_next[6] = o_write_enable[6];
    current_state_next  = current_state;

    case (current_state)
            //----------------------------------------------------
            STATE_IDLE:
            begin

                o_write_enable_next[0] = 0;
                o_write_enable_next[1] =0;
                o_write_enable_next[2] =0;
                o_write_enable_next[3] =0;
                o_write_enable_next[4] =0;
                o_write_enable_next[5] =0;
                o_write_enable_next[6] =0;
                o_write_enable_next[7] =0;

                if(I_read_data_valid == 1)
                begin
                    if(I_write_data == 01100001)
                    begin
                        current_state_next = STATE_LEFT_MOVEMENT;
                    end
                    else if (I_write_data == 01110111)
                    begin
                        current_state_next = STATE_TOP_MOVEMENT;
                    end
                    else if (I_write_data == 01110011)
                    begin
                        current_state_next = STATE_BOTTOM_MOVEMENT;
                    end
                    else if (I_write_data == 01100100)
                    begin
                        current_state_next = STATE_RIGHT_MOVEMENT;
                    end
                    else if (I_write_data == 01100010)
                    begin
                        current_state_next = STATE_SCANNER_START;
                    end
                    else if (I_write_data == 01101110)
                    begin
                        current_state_next = STATE_SCANNER_RST;
                    end
                    else if (I_write_data == 01101110)
                    begin
                        current_state_next = STATE_USER_RST;
                    end
                    else
                    begin
                        current_state_next = STATE_IDLE;
                    end
                end

            end
            //----------------------------------------------------
            STATE_LEFT_MOVEMENT:
            begin


                o_write_enable_next[0] = 1;
                current_state_next = STATE_IDLE;


            end
            //----------------------------------------------------
            STATE_TOP_MOVEMENT:
            begin

                o_write_enable_next[1] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            STATE_BOTTOM_MOVEMENT:
            begin

                o_write_enable_next[2] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            STATE_RIGHT_MOVEMENT:
            begin

                o_write_enable_next[3] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            STATE_SCANNER_START:
            begin
                o_write_enable_next[4] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            STATE_SCANNER_RST:
            begin

                o_write_enable_next[5] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            STATE_USER_RST:
            begin

                o_write_enable_next[6] = 1;
                current_state_next = STATE_IDLE;

            end
            //----------------------------------------------------
            default:
            begin
               current_state_next = STATE_IDLE;
            end
    endcase
end

endmodule
