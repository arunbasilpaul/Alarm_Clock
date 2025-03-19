// Verilog Testbench for Alarm Clock

`timescale 1ns / 1ps

module Alarm_Clk_tb;

    // Inputs
    reg aclk;
    reg reset;
    reg set_alarm;
    reg stop_alarm;
    reg [5:0] set_alarm_sec;
    reg [5:0] set_alarm_min;
    reg [4:0] set_alarm_hrs;
    
    // Outputs
    wire [6:0] sec_disp_ones;
    wire [6:0] min_disp_ones;
    wire [6:0] hrs_disp_ones;
    wire [6:0] sec_disp_tens;
    wire [6:0] min_disp_tens;
    wire [6:0] hrs_disp_tens;
    wire alarm_signal;
    
    // Clock period definition
    parameter clk_period = 10;
    
    // Instantiate the Unit Under Test (UUT)
    Alarm_Clk uut (
        .aclk(aclk),
        .reset(reset),
        .set_alarm(set_alarm),
        .stop_alarm(stop_alarm),
        .set_alarm_sec(set_alarm_sec),
        .set_alarm_min(set_alarm_min),
        .set_alarm_hrs(set_alarm_hrs),
        .sec_disp_ones(sec_disp_ones),
        .min_disp_ones(min_disp_ones),
        .hrs_disp_ones(hrs_disp_ones),
        .sec_disp_tens(sec_disp_tens),
        .min_disp_tens(min_disp_tens),
        .hrs_disp_tens(hrs_disp_tens),
        .alarm_signal(alarm_signal)
    );

    // Clock generation
    always begin
        aclk = 0;
        #(clk_period/2) aclk = 1;
        #(clk_period/2);
    end
    
    // Test process
    initial begin
        reset = 1;
        set_alarm = 0;
        stop_alarm = 0;
        set_alarm_sec = 6'b000000;
        set_alarm_min = 6'b000000;
        set_alarm_hrs = 5'b00000;
        
        # (clk_period * 2);
        reset = 0;
        
        // Setting an alarm
        set_alarm = 1;
        set_alarm_sec = 6'b000010;  // Alarm at 2 seconds
        set_alarm_min = 6'b000010;  // Alarm at 2 minutes
        set_alarm_hrs = 5'b00000;   // Alarm at 0 hours
        
        # (clk_period * 50); // Testing automatic alarm stop
        
        // Setting another alarm
        set_alarm = 1;
        set_alarm_sec = 6'b000101;  // Alarm at 5 seconds
        set_alarm_min = 6'b000010;  // Alarm at 1 minute
        set_alarm_hrs = 5'b00000;   // Alarm at 0 hours
        
        # (clk_period * 10);
        
        // Stop the alarm
        stop_alarm = 1;
        # (clk_period * 10);
        stop_alarm = 0;
        
        # (clk_period * 50);
        
        $stop;
    end

endmodule
