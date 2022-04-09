`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2022 12:00:31 PM
// Design Name: 
// Module Name: UART_RX
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
//  connect I_rx_serial_data to a two flip-flop syncornizer
//////////////////////////////////////////////////////////////////////////////////
module UART_RX 
(
input I_sys_clk,
input I_rst,
input I_rx_serial_data,
input I_baud_tick,

output [7:0] o_read_data,
output o_read_data_valid
);

parameter STATE_IDLE             = 3'b001;
parameter STATE_DATA             = 3'b010;
parameter STATE_STOP             = 3'b100;
parameter SAMPLING_COUNTER_LIMIT = 16;
parameter DATA_WIDTH             = 8;

reg [2:0] bit_counter,bit_counter_next;
reg [3:0] sampling_counter,sampling_counter_next;
reg [7:0] recieved_byte,recieved_byte_next;
reg [2:0] current_state,current_state_next;
reg [1:0] I_rx_serial_data_sync2;
reg I_rx_serial_data_reg1;
reg I_rx_serial_data_reg2;
reg read_data_valid,read_data_valid_next;

wire I_rx_serial_data_synced;

assign I_rx_serial_data_synced  = I_rx_serial_data_sync2[1];
assign o_read_data              = recieved_byte;
assign o_read_data_valid = read_data_valid;

//sequential    
always@(posedge I_sys_clk, posedge I_rst)
begin
        if(I_rst == 1)
        begin
        
        bit_counter           <= 0;
        sampling_counter      <= 0;
        recieved_byte         <= 0;
        I_rx_serial_data_reg1 <= 0;
        I_rx_serial_data_reg2 <= 0;
        I_rx_serial_data_sync2 <= 0;
        read_data_valid <= 0;
        current_state         <= STATE_IDLE;
        
        end
        
        else 
        begin
        
        bit_counter           <= bit_counter_next;
        sampling_counter      <= sampling_counter_next;
        recieved_byte         <= recieved_byte_next;
        current_state         <= current_state_next;
        read_data_valid <= read_data_valid_next;
        I_rx_serial_data_sync2 <= {I_rx_serial_data_sync[0],I_rx_serial_data};
        end
end

always@(*)
begin

    bit_counter_next      = bit_counter;
    sampling_counter_next = sampling_counter;
    recieved_byte_next    = recieved_byte;
    current_state_next    = current_state;
    read_data_valid_next = 0;
    
        case(current_state)
    //----------------------------------------------------       
    STATE_IDLE: //001
    begin
    
        if(I_rx_serial_data_synced == 0)//replace I_rx_serial_data to syncronized signal
        begin
            if(I_baud_tick == 1)
            begin
                if(sampling_counter <(SAMPLING_COUNTER_LIMIT/2)) //7
                begin

                    sampling_counter_next = sampling_counter+1;

                end

                if(sampling_counter ==(SAMPLING_COUNTER_LIMIT/2)-1)
                begin

                    sampling_counter_next = 0;
                    current_state_next    = STATE_DATA;

                end

                end
        end
    
    end 
    //----------------------------------------------------     
    STATE_DATA: //010
    begin
    
        if(I_baud_tick == 1)
        begin
           if(sampling_counter <SAMPLING_COUNTER_LIMIT) //15
           begin

                sampling_counter_next = sampling_counter+1; //count up to 15

           end

           if(sampling_counter == (SAMPLING_COUNTER_LIMIT)-1)
           begin

               sampling_counter_next = 0;

               recieved_byte_next = {I_rx_serial_data_synced,recieved_byte[DATA_WIDTH:1]};

               if(bit_counter == DATA_WIDTH-1)
               begin

                    current_state_next = STATE_STOP; //goes to next state when all seven shifted in
                    read_data_valid = 1;

               end

               else
               begin

                    bit_counter_next = bit_counter+1; //counts up top 7 to account for amount bits being sent through

               end
           end
        //sampling counter must increment up to 15 based off baud rate tick
        //every time the sampling ratew reaches 15 shift in a bit into my register
        //shifter should be least significant bit, tells us the direction(shifting left to right)
        //recieved byte is my shift register (the one gettting updated)
        //everytime the sampling rate reaches 15, must also increment bit counter
        //once bit counter reaches specific value (7), then go to stop state
        end
    end   
    //----------------------------------------------------   
    STATE_STOP: //001
    begin
    
         if(I_baud_tick == 1)
        begin
           if(sampling_counter <SAMPLING_COUNTER_LIMIT)
           begin

                sampling_counter_next = sampling_counter+1; //count up to 15

           end

           if(sampling_counter == (SAMPLING_COUNTER_LIMIT)-1)
           begin

                current_state_next = STATE_IDLE;
           end
        //increment sampling counter up to 15 based on baud rate tick
        //then goes back to idle state
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

endmodule
