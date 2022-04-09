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
module motor_logic #(parameter count_limit = 0,parameter duty_cycle = 0)
(
input I_servo_pwm_EN,
input I_clk,
output reg o_servo_output = 0,
output movement_done
);

//clk divider
//reg [14:0] count_limit = 6249;//10khz
reg [14:0] counter = 0;
reg o_motor_clk = 0;
//pwm
reg [8:0] counter_pwm = 0;
reg movement_done_reg = 0;
wire counter_trigger;
//localparam duty_cycle = 500; //n-1 
assign counter_trigger = (I_servo_pwm_EN)?1:0; 
assign movement_done = movement_done_reg;
      
always@(posedge I_clk)
begin

   if(counter_pwm >= duty_cycle)
   
   begin 
   
   counter_pwm <= 0; 
   movement_done_reg <= 1;
   o_servo_output <= 0;
   
   end
   
   else if (counter_trigger == 1 || counter_pwm > 0 )
   
   begin 
   
   counter_pwm <= counter_pwm+1;
   movement_done_reg <= 0;
   o_servo_output <= 1;
   
   end
    
end 

   
endmodule




