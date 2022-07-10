----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2022 09:36:18 PM
-- Design Name: 
-- Module Name: a6_main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity a6_main is --define a entity for the a6
    port(button_s_c: in  std_logic; -- define a push down button for start/continue the stopwatch
        button_reset : in std_logic; -- define a push down button for reset the stopwatch
        button_pause : in std_logic; -- define a push down button for pause the stopwatch
        clk : in std_logic; -- define a clock 
        anode : out std_logic_vector(3 downto 0);  -- define a vector of size 4 for the 4 seven segment display
        segment : out std_logic_vector(6 downto 0)); --define a vector of length 7 that contains output of 7 segment display
end a6_main;

architecture Behavioral of a6_main is
signal minute : std_logic_vector(3 downto 0) := "0000"; -- define a signal for minute taht start from 0 intially
signal second1 : std_logic_vector(3 downto 0) := "0000"; -- define a signal for second taht start from 0 intially
signal second0 : std_logic_vector(3 downto 0) := "0000";-- define a signal for second taht start from 0 intially
signal secondten : std_logic_vector(3 downto 0) := "0000";-- define a signal for milisecond taht start from 0 intially
signal stop_watch_counter : std_logic_vector(23 downto 0):= "000000000000000000000000"; -- define a counter for the stopwatch

signal Bt:std_logic_vector(3 downto 0):="0000";  --define a signal for handle the input given by the buttons
signal refresh_clk : std_logic_vector(19 downto 0):= (others => '0');-- a 20-bit clock used for selecting anode and incrementing refresh-rates.
signal refresh_rate:integer :=0;--define an integer for apply the timer to the clock 
signal clk_input:std_logic_vector( 1 downto 0):="00"; -- define a signal of size 2-bit for selecting a anode.
signal start_conti : std_logic := '0';
signal reset : std_logic := '0';
begin
-- Define a process of a combinational circuit using the logical expressions for each output segment
process(Bt)
begin
segment(0) <= (not Bt(3) and not Bt(2) and not Bt(1) and Bt(0)) or(not Bt(3) and Bt(2) and not Bt(1) and not Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and not Bt(2) and Bt(1) and Bt(0));
segment(1) <= (Bt(2) and Bt(1) and not Bt(0)) or (Bt(3) and Bt(1) and Bt(0)) or (not Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and not Bt(0));
segment(2) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(3) AND Bt(2) AND Bt(1)) OR (Bt(3) AND Bt(2) AND (NOT Bt(0)));
segment(3) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0))) OR (Bt(3) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(2) AND Bt(1) AND Bt(0));
segment(4) <= ((NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)));
segment(5) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(0)) OR ((NOT Bt(3)) AND (NOT Bt(2)) AND (Bt(1))) OR ((NOT Bt(3)) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND Bt(0));
segment(6) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1))) OR ((NOT Bt(3)) AND Bt(2) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0)));

end process;

-- process over clock for selecting the desired button and change the output according to that
process(clk)
begin
    if button_s_c = '1' then
        start_conti <= '1';
        reset <= '0';
    end if ;

    if button_pause = '1' then
        start_conti <= '0';
    end if ;
    if button_reset = '1' then
        reset <= '1';
        start_conti <= '0';
    end if ;
end process;

-- define a process over clock that basically process on the rising_edge and change the milisecond of the stopwatch and after 9 milisecond it increase the second by 1 and after that when second reach to 9 then it increase the second to 10 and after that we can wait until the second to 59 and after that we make second to 0 and make minute as 1. 
process(clk)
begin 
if rising_edge(clk) then
    refresh_clk <= refresh_clk + '1';
    if stop_watch_counter = "100110001001011010000000" then
        stop_watch_counter <= "000000000000000000000001";
    else
        stop_watch_counter <= stop_watch_counter +1;
    end if ;
    
    if stop_watch_counter = "100110001001011010000000" then
            if start_conti = '1' then
                if secondten = "1001" then
                    secondten <= "0000";
                    if second0 = "1001" then
                        second0 <= "0000";
                        if second1 = "0101" then
                            second1 <= "0000";
                            if minute = "1001" then
                                minute <= "0000";
                            else
                                minute <= minute + 1;
                            end if ;
                        else
                            second1 <= second1 + 1;
                        end if ;
                    else
                        second0 <= second0 + 1;
                    end if ;
                else
                    secondten <= secondten + 1;
                end if ;
            end if ;
    
            if reset = '1' then
                secondten <= "0000";
                second0 <= "0000";
                second1 <= "0000";
                minute <= "0000";
            end if ;
        end if;

    clk_input <= refresh_clk(19 downto 18);
end if ;
end process;

process(clk_input)
begin
case( clk_input ) is

    when "00" =>
        anode <= "1110";
        Bt <= secondten;

    when "01" =>
        anode <= "1101";
        Bt <= second0;

    

    when "10" =>
        anode <= "1011";
        Bt <= second1;


    when "11" =>
        anode <= "0111";
        Bt <= minute;

    when others => anode <= "1111";

end case ;
end process;


end Behavioral;