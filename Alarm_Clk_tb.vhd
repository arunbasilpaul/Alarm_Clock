library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Alarm_Clk_tb is
end Alarm_Clk_tb;

architecture testbench of Alarm_Clk_tb is

    component Alarm_Clk
        port(
            aclk:          in std_logic;
            reset:         in std_logic;
            set_alarm:     in std_logic;
            stop_alarm:    in std_logic;
            set_alarm_sec: in std_logic_vector (5 downto 0);
            set_alarm_min: in std_logic_vector (5 downto 0);
            set_alarm_hrs: in std_logic_vector (4 downto 0);
            sec_disp_ones: out std_logic_vector (6 downto 0);
            min_disp_ones: out std_logic_vector (6 downto 0);
            hrs_disp_ones: out std_logic_vector (6 downto 0);
            sec_disp_tens: out std_logic_vector (6 downto 0);
            min_disp_tens: out std_logic_vector (6 downto 0);
            hrs_disp_tens: out std_logic_vector (6 downto 0);
            alarm_signal:  out std_logic
        );
    end component;

    -- Signals for the test bench
    signal aclk:          std_logic := '0';
    signal reset:         std_logic := '0';
    signal set_alarm:     std_logic := '0';
    signal stop_alarm:    std_logic := '0';
    signal set_alarm_sec: std_logic_vector (5 downto 0) := "000000";
    signal set_alarm_min: std_logic_vector (5 downto 0) := "000000";
    signal set_alarm_hrs: std_logic_vector (4 downto 0) := "00000";
    signal sec_disp_ones: std_logic_vector (6 downto 0);
    signal min_disp_ones: std_logic_vector (6 downto 0);
    signal hrs_disp_ones: std_logic_vector (6 downto 0);
    signal sec_disp_tens: std_logic_vector (6 downto 0);
    signal min_disp_tens: std_logic_vector (6 downto 0);
    signal hrs_disp_tens: std_logic_vector (6 downto 0);
    signal alarm_signal:  std_logic;

    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Alarm_Clk
        port map (
            aclk => aclk,
            reset => reset,
            set_alarm => set_alarm,
            stop_alarm => stop_alarm,
            set_alarm_sec => set_alarm_sec,
            set_alarm_min => set_alarm_min,
            set_alarm_hrs => set_alarm_hrs,
            sec_disp_ones => sec_disp_ones,
            min_disp_ones => min_disp_ones,
            hrs_disp_ones => hrs_disp_ones,
            sec_disp_tens => sec_disp_tens,
            min_disp_tens => min_disp_tens,
            hrs_disp_tens => hrs_disp_tens,
            alarm_signal => alarm_signal
        );

    -- Clock process
    clk_process :process
    begin
        while True loop
            aclk <= '0';
            wait for clk_period/2;
            aclk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        reset <= '1';
        set_alarm <= '0';
        stop_alarm <= '0';
        set_alarm_sec <= "000000";
        set_alarm_min <= "000000";
        set_alarm_hrs <= "00000";

        -- Wait for global reset to finish
        wait for clk_period * 2;
        reset <= '0';

        -- Set an alarm
        set_alarm <= '1';
        set_alarm_sec <= "000010";  -- Alarm at 2 seconds
        set_alarm_min <= "000000";  -- Alarm at 0 minutes
        set_alarm_hrs <= "00000";   -- Alarm at 0 hours

        -- Wait for a few clock cycles
        wait for clk_period * 50;

        -- Stop the alarm
        stop_alarm <= '1';
        wait for clk_period * 10;
        stop_alarm <= '0';

        -- End simulation
        wait;
    end process;

end testbench;
