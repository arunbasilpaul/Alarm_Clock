module Alarm_Clk(
    input wire aclk,
    input wire reset,
    input wire set_alarm,
    input wire stop_alarm,
    input wire [5:0] set_alarm_sec,
    input wire [5:0] set_alarm_min,
    input wire [4:0] set_alarm_hrs,
    output reg [6:0] sec_disp_ones,
    output reg [6:0] min_disp_ones,
    output reg [6:0] hrs_disp_ones,
    output reg [6:0] sec_disp_tens,
    output reg [6:0] min_disp_tens,
    output reg [6:0] hrs_disp_tens,
    output reg alarm_signal
);

    reg [5:0] sec = 6'b000000;
    reg [5:0] min = 6'b000000;
    reg [4:0] hrs = 5'b00000;
    reg [4:0] alarm_signal_timer = 5'b00000;
    reg alarm_signal_temp = 1'b0;
    
    function [6:0] binary_to_bcd_display;
        input [3:0] bin_input;
        case (bin_input)
            4'b0000: binary_to_bcd_display = 7'b0000001;
            4'b0001: binary_to_bcd_display = 7'b1001111;
            4'b0010: binary_to_bcd_display = 7'b0010010;
            4'b0011: binary_to_bcd_display = 7'b0000110;
            4'b0100: binary_to_bcd_display = 7'b1001100;
            4'b0101: binary_to_bcd_display = 7'b0100100;
            4'b0110: binary_to_bcd_display = 7'b0100000;
            4'b0111: binary_to_bcd_display = 7'b0001111;
            4'b1000: binary_to_bcd_display = 7'b0000000;
            4'b1001: binary_to_bcd_display = 7'b0000100;
            default: binary_to_bcd_display = 7'b1111111;
        endcase
    endfunction
    
    always @(posedge aclk or posedge reset) begin
        if (reset) begin
            sec <= 6'b000000;
            min <= 6'b000000;
            hrs <= 5'b00000;
        end else if (set_alarm) begin
            sec <= sec + 1;
            if (sec == 6'b111100) begin
                sec <= 6'b000000;
                min <= min + 1;
                if (min == 6'b111100) begin
                    min <= 6'b000000;
                    hrs <= hrs + 1;
                    if (hrs == 5'b11000)
                        hrs <= 5'b00000;
                end
            end
            if ((set_alarm_sec == sec) && (set_alarm_min == min) && (set_alarm_hrs == hrs) && 
                ((stop_alarm != 1'b1) || (alarm_signal_timer < 30))) begin
                alarm_signal_temp <= 1'b1;
                alarm_signal_timer <= alarm_signal_timer + 1;
            end else begin
                alarm_signal_temp <= 1'b0;
                alarm_signal_timer <= 5'b00000;
            end
        end else begin
            sec <= sec + 1;
            if (sec == 6'b111100) begin
                sec <= 6'b000000;
                min <= min + 1;
                if (min == 6'b111100) begin
                    min <= 6'b000000;
                    hrs <= hrs + 1;
                    if (hrs == 5'b11000)
                        hrs <= 5'b00000;
                end
            end
        end
    end
    
    always @(*) begin
        sec_disp_ones = binary_to_bcd_display(sec[3:0]);
        sec_disp_tens = binary_to_bcd_display({2'b00, sec[5:4]});
        min_disp_ones = binary_to_bcd_display(min[3:0]);
        min_disp_tens = binary_to_bcd_display({2'b00, min[5:4]});
        hrs_disp_ones = binary_to_bcd_display(hrs[3:0]);
        hrs_disp_tens = binary_to_bcd_display({3'b000, hrs[4]});
    end
    
    assign alarm_signal = alarm_signal_temp;
    
endmodule
