library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Alarm_Clk is
	port(   aclk:          in std_logic;
		reset:         in std_logic;
		set_alarm:     in std_logic;
		stop_alarm:    in std_logic;
		set_alarm_sec: in std_logic_vector (5 downto 0);
		set_alarm_min: in std_logic_vector (5 downto 0);
		set_alarm_hrs: in std_logic_vector (4 downto 0);
		sec_disp_ones: out std_logic_vector (6 downto 0); -- To display the ones position of the seconds
		min_disp_ones: out std_logic_vector (6 downto 0); -- To display the ones position of the minutes
		hrs_disp_ones: out std_logic_vector (6 downto 0); -- To display the ones position of the hours
		sec_disp_tens: out std_logic_vector (6 downto 0); -- To display the tens position of the seconds
		min_disp_tens: out std_logic_vector (6 downto 0); -- To display the tens position of the minutes
		hrs_disp_tens: out std_logic_vector (6 downto 0); -- To display the tens position of the hours
		alarm_signal:  out std_logic
	);
end Alarm_Clk;

architecture BEHAV of Alarm_Clk is

signal sec, min:  	   std_logic_vector (5 downto 0) := "000000"; 
signal hrs: 		   std_logic_vector (4 downto 0) := "00000";
signal alarm_signal_timer: std_logic_vector (4 downto 0) := "00000";
signal alarm_signal_temp:  std_logic := '0';

function binary_to_bcd_display(bin_input: std_logic_vector(3 downto 0)) 
	return std_logic_vector is
	variable bcd_disp: std_logic_vector(6 downto 0);
begin
	case bin_input is
		when "0000" => bcd_disp := "0000001";
		when "0001" => bcd_disp := "1001111";
		when "0010" => bcd_disp := "0010010";
		when "0011" => bcd_disp := "0000110";
		when "0100" => bcd_disp := "1001100";
		when "0101" => bcd_disp := "0100100";
		when "0110" => bcd_disp := "0100000";
		when "0111" => bcd_disp := "0001111";
		when "1000" => bcd_disp := "0000000";
		when "1009" => bcd_disp := "0000100";
		when others => bcd_disp := "1111111";
	end case;
	return bcd_disp;
end binary_to_bcd_display;

begin

	CLK_FUN: process(aclk, reset)
	begin
		if(reset = '1') then
			sec <= "000000";
			min <= "000000";
			hrs <= "00000";

		elsif(rising_edge(aclk) and (set_alarm = '1')) then
			sec <= sec + 1;

			if(sec = "111100") then
				sec <= "000000";
				min <= min + 1;
				if(min = "111100") then
					min <= "000000";
					hrs <= hrs + 1;
					if(hrs = "11000") then
						hrs <= "00000";
					end if;
				end if;
			end if;

			if(((set_alarm_sec = sec) and (set_alarm_min = min) and (set_alarm_hrs = hrs)) and ((stop_alarm /= '1') or (alarm_signal_timer < 30))) then
				alarm_signal_temp <= '1';
				alarm_signal_timer <= alarm_signal_timer + 1;
			else
				alarm_signal_temp <= '0';
				alarm_signal_timer <= "00000";
			end if;

		elsif(rising_edge(aclk)) then
			sec <= sec + 1;

			if(sec = "111100") then
				sec <= "000000";
				min <= min + 1;
				if(min = "111100") then
					min <= "000000";
					hrs <= hrs + 1;
					if(hrs = "11000") then
						hrs <= "00000";
					end if;
				end if;
			end if;
		end if;
	end process;

	CLK_DISPLAY: process(sec, min, hrs)
		variable sec_ones, sec_tens, min_ones, min_tens, hrs_ones, hrs_tens : std_logic_vector(3 downto 0);
	begin
		sec_ones := sec(3 downto 0);
		sec_tens := "00" & sec(5 downto 4);

		min_ones := min(3 downto 0);
		min_tens := "00" & min(5 downto 4);

		hrs_ones := hrs(3 downto 0);
		hrs_tens := "000" & hrs(4);
	
		sec_disp_ones <= binary_to_bcd_display(sec_ones);
		sec_disp_tens <= binary_to_bcd_display(sec_tens);
		min_disp_ones <= binary_to_bcd_display(min_ones);		
		min_disp_tens <= binary_to_bcd_display(min_tens);
		hrs_disp_ones <= binary_to_bcd_display(hrs_ones);
		hrs_disp_tens <= binary_to_bcd_display(hrs_tens);

	end process;

	alarm_signal <= alarm_signal_temp;

end BEHAV;
