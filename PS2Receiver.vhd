---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2024 14:08:05
-- Design Name: 
-- Module Name: PS2Receiver - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity PS2Receiver is
    Port ( clk : in STD_LOGIC;
           kclk : in STD_LOGIC;
           kdata : in STD_LOGIC;
           fg : out STD_LOGIC;
           keycodeout : out STD_LOGIC_VECTOR (23 downto 0));
end PS2Receiver;

architecture Behavioral of PS2Receiver is

component debouncer is
    Port ( buton : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           buton_db : out  STD_LOGIC);
end component;

signal kclkf : STD_LOGIC;
signal kdataf : STD_LOGIC;
signal datacur : STD_LOGIC_VECTOR(7 downto 0);
signal dataprev : STD_LOGIC_VECTOR(7 downto 0);
signal cnt : unsigned(3 downto 0) := (others => '0');
signal keycode : STD_LOGIC_VECTOR(23 downto 0) := x"000000";
signal flag : STD_LOGIC := '0';

begin

DEBOUNCE:  debouncer port map(buton => kclk, clk => clk, buton_db => kclkf);
DEBOUNCE1: debouncer port map(buton => kdata, clk => clk, buton_db => kdataf);

	process(kclkf)
	begin
		if rising_edge(kclkf) then
			if cnt < 10 then
				cnt <= cnt + 1;
			else
				cnt <= (others => '0');
			end if;

			case to_integer(cnt) is
				when 1 => datacur(0) <= kdataf;
				when 2 => datacur(1) <= kdataf;
				when 3 => datacur(2) <= kdataf;
				when 4 => datacur(3) <= kdataf;
				when 5 => datacur(4) <= kdataf;
				when 6 => datacur(5) <= kdataf;
				when 7 => datacur(6) <= kdataf;
				when 8 => datacur(7) <= kdataf;
				when 9 => flag <= '1';
				when 10 => flag <= '0';
				when others => null;
			end case;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if flag = '1' then
				if dataprev /= datacur then
					keycode(23 downto 16) <= keycode(15 downto 8);
					keycode(15 downto 8) <= dataprev;
					keycode(7 downto 0) <= datacur;
					dataprev <= datacur;
				end if;
			end if;
		end if;
	end process;

fg <= flag;
keycodeout <= keycode;

end Behavioral;

