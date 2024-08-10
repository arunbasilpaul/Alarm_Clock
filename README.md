# Overview
This project implements a digital alarm clock using VHDL (VHSIC Hardware Description Language). The clock counts seconds, minutes, and hours, and supports an alarm function that triggers based on preset values. Time and alarm values are displayed using 7-segment displays. The design is suitable for FPGA-based implementations and serves as a fundamental example of digital logic design in VHDL.

<div>
  <img align="left" width="55%" src="https://github.com/user-attachments/assets/52b15464-286c-4dd5-adf6-c17d621a51cb">
</div>

# Features
- Time Counting: The clock counts up to 60 seconds, 60 minutes, and 24 hours, displaying the time using 7-segment displays.
- Alarm Functionality: The alarm can be set to trigger at a specific time. When the time matches the preset alarm value, an alarm signal is activated.
- 7-Segment Display: The current time and alarm values are displayed on 7-segment displays, broken down into ones and tens for each unit (seconds, minutes, hours).
- Reset Functionality: A reset input allows the clock and alarm to be reset to their initial state.

# Design Details
- Entity: Alarm_Clk  This entity defines the top-level interface for the alarm clock system.

# Ports:
aclk (in): Clock input.
reset (in): Asynchronous reset signal.
set_alarm (in): Signal to enable setting the alarm.
stop_alarm (in): Signal to stop the alarm.
set_alarm_sec (in): 6-bit vector to set the alarm seconds.
set_alarm_min (in): 6-bit vector to set the alarm minutes.
set_alarm_hrs (in): 5-bit vector to set the alarm hours.
sec_disp_ones, sec_disp_tens (out): 7-segment display outputs for seconds.
min_disp_ones, min_disp_tens (out): 7-segment display outputs for minutes.
hrs_disp_ones, hrs_disp_tens (out): 7-segment display outputs for hours.
alarm_signal (out): Signal that activates when the alarm is triggered.

Architecture: BEHAV
The architecture contains the logic for the clock's timekeeping, alarm function, and 7-segment display control.

# Key Processes:
- CLK_FUN: Handles the time counting and alarm triggering logic. This process increments the seconds, minutes, and hours counters based on the clock input (aclk). The alarm is triggered when the current time matches the preset alarm time.

- CLK_DISPLAY: Converts the current time (seconds, minutes, and hours) into a format suitable for 7-segment display. This process splits the time into ones and tens digits and uses a function to convert binary values to their corresponding 7-segment display format.

Function: binary_to_bcd_display
A utility function that converts a 4-bit binary value to a 7-segment display format, which is then used to drive the 7-segment display outputs.

# Getting Started
## Prerequisites
- VHDL simulator or synthesis tool (e.g., ModelSim, Vivado).
- FPGA development board (optional for hardware implementation).

# Simulation
To simulate the design:

1. Clone the repository:
   git clone https://github.com/arunbasilpaul/Alarm_Clock/tree/main
2. Open the project in your preferred VHDL simulator.
3. Run the testbench (Alarm_Clk_tb) to verify the functionality of the design.
4. Synthesis and Implementation

## For FPGA implementation:
1. Import the VHDL files into your FPGA development environment.
2. Synthesize the design.
3. Implement the design on your FPGA board.
4. Connect the 7-segment displays and input switches/buttons as per the design.

# File Structure
Alarm_Clk.vhd: Top-level VHDL file defining the alarm clock logic.
Alarm_Clk_tb.vhd: Testbench for simulating the alarm clock design.
README.md: Project documentation.

# Future Enhancements
- Multiple Alarms: Add support for setting multiple alarms.
- AM/PM Indicator: Extend the design to support 12-hour format with AM/PM indicators.
- Alarm Sound Integration: Interface with a buzzer or speaker to produce a sound when the alarm triggers.
- User Interface: Create a more user-friendly interface for setting time and alarms.
