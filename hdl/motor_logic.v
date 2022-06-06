`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2021 07:37:15 PM
// Design Name: 
// Module Name: motor_logic
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
module motor_logic #(parameter count_limit = 0)
(
    input       I_servo_pwm_EN,
    input [2:0] I_duty_cycle_selected,
    input       I_clk,
    output reg  o_servo_output = 0,
    output      movement_done
);

//----------------------------------------------------

reg [8:0]  counter_pwm              = 0;
reg [13:0] counter_continous_signal = 0;
reg        movement_done_reg        = 0;
wire       counter_trigger;

//----------------------------------------------------

assign counter_trigger = (I_servo_pwm_EN)? 1 : 0;
assign movement_done   = movement_done_reg;

//----------------------------------------------------
always@(posedge I_clk)
begin

    if(counter_pwm >= I_duty_cycle_selected)
    begin

      counter_pwm          <= 0;
      o_servo_output       <= 0;

           if(counter_continous_signal >= count_limit)
           begin

                movement_done_reg         <= 1;
                counter_continous_signal  <= 0;

           end

      end

    else if (counter_trigger == 1 || counter_pwm > 0 )
    begin

      movement_done_reg    <= 0;
      counter_pwm          <= counter_pwm+1;
      o_servo_output       <= 1;

      end

    if(counter_continous_signal < count_limit)
    begin

    counter_continous_signal <= counter_continous_signal+1;

    end
end
//----------------------------------------------------
endmodule




