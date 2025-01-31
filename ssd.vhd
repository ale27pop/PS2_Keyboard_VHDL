----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2024 10:07:30 AM
-- Design Name: 
-- Module Name: ssd - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
    Port ( clk : in  STD_LOGIC;
           digit0 : in  STD_LOGIC_VECTOR (7 downto 0);
           digit1 : in  STD_LOGIC_VECTOR (7 downto 0);
           digit2 : in  STD_LOGIC_VECTOR (7 downto 0);
           digit3 : in  STD_LOGIC_VECTOR (7 downto 0);
		 digit4 : in  STD_LOGIC_VECTOR (7 downto 0);
		 digit5 : in  STD_LOGIC_VECTOR (7 downto 0);
		 digit6 : in  STD_LOGIC_VECTOR (7 downto 0);
		 digit7 : in  STD_LOGIC_VECTOR (7 downto 0);
           anod : out  STD_LOGIC_VECTOR (7 downto 0);
           catod : out  STD_LOGIC_VECTOR (7 downto 0);
		  ptr : in std_logic_vector(3 downto 0));
end ssd;

architecture Behavioral of ssd is
signal numar:std_logic_vector(15 downto 0);
signal hex:std_logic_vector(7 downto 0);

begin

--numarator

process(clk,numar)
variable temp : unsigned(15 downto 0); 
begin

if clk='1' and clk'event then
   temp := unsigned(numar) + 1;
   numar <= std_logic_vector(temp);
end if;
end process;


--mux anod

process(numar)
begin
case (numar (15 downto 13)) is

when "000"=>anod<="11111110";
when "001"=>anod<="11111101";
when "010"=>anod<="11111011";
when "011"=>anod<="11110111";
when "100"=>anod<="11101111";
when "101"=>anod<="11011111";
when "110"=>anod<="10111111";
when others =>anod<="01111111";
end case;
end process;

--mux afisare cifra activa

process(clk,digit0,digit1,digit2,digit3,digit4,digit5,digit6,digit7,numar, ptr)
begin
catod(7) <= '1';
case (numar (15 downto 13)) is
when "000"=>hex<=digit0; if( ptr = "0001" or ptr = "0000") then catod(7) <= '0'; end if;
when "001"=>hex<=digit1; if( ptr = "0010" or ptr = "0011" ) then catod(7) <= '0'; end if;
when "010"=>hex<=digit2; if( ptr = "0100" or ptr = "0101") then catod(7) <= '0'; end if;
when "011"=>hex<=digit3; if( ptr = "0110" or ptr = "0111") then catod(7) <= '0'; end if;
when "100"=>hex<=digit4; if( ptr = "1000" or ptr = "1001") then catod(7) <= '0'; end if;
when "101"=>hex<=digit5; if( ptr = "1010" or ptr = "1011") then catod(7) <= '0'; end if;
when "110"=>hex<=digit6; if( ptr = "1100" or ptr = "1101") then catod(7) <= '0'; end if;
when others=>hex<=digit7; if( ptr = "1110" or ptr = "1111") then catod(7) <= '0'; end if;
end case;
end process;


---decoder hex to 7 segmente
process(hex)
begin
case hex is
		---NUMERE
		when "01000101" => catod(6 downto 0)<="0000001"; -- 0
		when "00010110" => catod(6 downto 0)<="1001111"; -- 1
		when "00011110" => catod(6 downto 0)<="0010010"; -- 2
		when "00100110" => catod(6 downto 0)<="0000110"; -- 3
		when "00100101" => catod(6 downto 0)<="1001100"; -- 4
		when "00101110" => catod(6 downto 0)<="0100100"; -- 5
		when "00110110" => catod(6 downto 0)<="0100000"; -- 6
		when "00111101" => catod(6 downto 0)<="0001111"; -- 7
		when "00111110" => catod(6 downto 0)<="0000000"; -- 8
		when "01000110" => catod(6 downto 0)<="0000100"; -- 9
		--- LITERE
		when "00011100" => catod(6 downto 0)<="0001000"; -- A
		when "00110010" => catod(6 downto 0)<="0000000"; -- B
		when "00100001" => catod(6 downto 0)<="0110001"; -- C
		when "00100011" => catod(6 downto 0)<="0000011"; -- D
		when "00100100" => catod(6 downto 0)<="0110000"; -- E
		when "00101011" => catod(6 downto 0)<="0111000"; -- F
		when "00110100" => catod(6 downto 0)<="0100001"; -- G
		when "00110011" => catod(6 downto 0)<="1001000"; -- H
		when "01000011" => catod(6 downto 0)<="1111001"; -- I
		when "00111011" => catod(6 downto 0)<="1000111"; -- J
		when "01000010" => catod(6 downto 0)<="0101000"; -- K
		when "01001011" => catod(6 downto 0)<="1110001"; -- L
		when "00111010" => catod(6 downto 0)<="0010101"; -- M
		when "00110001" => catod(6 downto 0)<="0001001"; -- N
		when "01000100" => catod(6 downto 0)<="0000001"; -- O
		when "01001101" => catod(6 downto 0)<="0011000"; -- P
		when "00010101" => catod(6 downto 0)<="0010100"; -- Q
		when "00101101" => catod(6 downto 0)<="0010000"; -- R
		when "00011011" => catod(6 downto 0)<="0100100"; -- S
		when "00101100" => catod(6 downto 0)<="0110001"; -- T
		when "00111100" => catod(6 downto 0)<="1000001"; -- U
		when "00101010" => catod(6 downto 0)<="1000101"; -- V
		when "00011101" => catod(6 downto 0)<="0100011"; -- W
		when "00100010" => catod(6 downto 0)<="0110110"; -- X
		when "00110101" => catod(6 downto 0)<="1010100"; -- Y
		when "00011010" => catod(6 downto 0)<="1010100"; -- Z
		when others => catod(6 downto 0)<="1111111"; 

end case;
end process;
--- bagam punctul



end Behavioral;





