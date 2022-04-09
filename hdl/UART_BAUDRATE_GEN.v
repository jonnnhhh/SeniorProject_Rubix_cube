`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2022 12:00:10 PM
// Design Name: 
// Module Name: UART_BAUDRATE_GEN
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
module UART_BAUDRATE_GEN #(parameter BAUD_RATE = 9600)
(
input I_sys_clk, //125mhz
input I_rst,
input I_enable,

output reg O_BaudRate_generator_tick
);

//((clk freq/(desired freq x sampling rate))-1)
localparam BAUD_RATE_DELIMITER = ((125_000_000/(BAUD_RATE*16))-1);
//log2(BAUD_RATE_DELIMITER)

reg [$clog2(BAUD_RATE_DELIMITER) - 1:0] baud_counter_reg, baud_counter_reg_next;
reg O_BaudRate_generator_tick_next;

always@(posedge I_sys_clk, posedge I_rst)
begin
    
    if(I_rst == 1)
    begin
    baud_counter_reg <= 0;
    O_BaudRate_generator_tick <= 0;
    end
    
    else
    begin
    
    baud_counter_reg <= baud_counter_reg_next;
    O_BaudRate_generator_tick <= O_BaudRate_generator_tick_next;
    
    end

end

always@(*)
begin

    baud_counter_reg_next = baud_counter_reg;
    O_BaudRate_generator_tick_next = 0;
    
    if(I_enable == 1)
        begin
          if(baud_counter_reg >= BAUD_RATE_DELIMITER) 
          begin
            baud_counter_reg_next = 0;
            O_BaudRate_generator_tick_next = 1;
            
            end
        
        else
            begin
            
            baud_counter_reg_next = baud_counter_reg+1;
            
            end
    end    
         
end 
    
endmodule
