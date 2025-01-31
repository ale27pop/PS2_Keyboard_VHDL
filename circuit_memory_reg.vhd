----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2024 10:04:17 AM
-- Design Name: 
-- Module Name: circuit_memory_reg - Behavioral
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

entity circuit_memory_reg is
    Port ( clk : in  STD_LOGIC;
         ps2_clk : in STD_LOGIC;
           ps2_data : in STD_LOGIC;
          catod : out std_logic_vector(7 downto 0);
          anod : out std_logic_vector(7 downto 0)
              );
             
end circuit_memory_reg;

architecture Behavioral of circuit_memory_reg is

component PS2Receiver is
Port ( clk : in STD_LOGIC;
kclk : in STD_LOGIC;
kdata : in STD_LOGIC;
fg : out STD_LOGIC;
keycodeout : out STD_LOGIC_VECTOR (23 downto 0));
end component;

component stack is
    Port ( clk : in  STD_LOGIC;
           date_in : in  STD_LOGIC_VECTOR (7 downto 0);
           date_out0 : out  STD_LOGIC_VECTOR (7 downto 0);
         date_out1 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out2 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out3 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out4 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out5 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out6 : out  STD_LOGIC_VECTOR (7 downto 0);
           date_out7 : out  STD_LOGIC_VECTOR (7 downto 0);
            ptr_n    : in  STD_LOGIC_VECTOR (3 downto 0);
              ptr      : out STD_LOGIC_VECTOR (3 downto 0);
         rst : in std_logic;
         stack_op : in std_logic_vector(1 downto 0)
             );
end component;

component ssd is
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
         ptr : in STD_LOGIC_VECTOR (3 downto 0));
end component;

signal use_stack :STD_LOGIC:='0';
signal codu_cifrei : STD_LOGIC_VECTOR (23 downto 0):=x"000000";
signal digit0:std_logic_vector(7 downto 0):=x"FF";
signal digit1:std_logic_vector(7 downto 0):=x"FF";
signal digit2:std_logic_vector(7 downto 0):=x"FF";
signal digit3:std_logic_vector(7 downto 0):=x"FF";
signal digit4:std_logic_vector(7 downto 0):=x"FF";
signal digit5:std_logic_vector(7 downto 0):=x"FF";
signal digit6:std_logic_vector(7 downto 0):=x"FF";
signal digit7:std_logic_vector(7 downto 0):=x"FF";
signal punct_curr: std_logic_vector(3 downto 0):= "0000";
signal punct_next: std_logic_vector(3 downto 0);
signal avem_enter: std_logic:='0';
signal oare_scriem: std_logic_vector(1 downto 0):="00";
begin
luam_codul : PS2Receiver port map(clk=> clk,kclk=>ps2_clk,kdata=>ps2_data,fg=>use_stack,keycodeout=>codu_cifrei);

process(clk)
begin
    if(codu_cifrei(7 downto 0) = x"5A") then --if "enter"
avem_enter <= '1';
else
avem_enter <= '0';
end if;

if(codu_cifrei(7 downto 0)=x"F0") then
oare_scriem <= "00";
elsif(codu_cifrei(7 downto 0) = x"66") then --if backspace
oare_scriem <= "01"; --pop from the stack
else
oare_scriem <= "10"; --push on stack the character
end if;

end process;

push_on_stack : stack port map(clk=>use_stack,date_in=> codu_cifrei(7 downto 0), date_out0=>digit0,date_out1=> digit1,date_out2=> digit2, date_out3=>digit3, date_out4=>digit4,date_out5=> digit5,date_out6=> digit6,date_out7=> digit7,ptr_n=> punct_curr, ptr=>punct_next,rst=> avem_enter,stack_op=> oare_scriem);

afisare_numere: ssd port map(clk=>clk, digit0=>digit0,digit1=> digit1,digit2=>digit2,digit3=>digit3,digit4=>digit4,digit5=> digit5, digit6=>digit6, digit7=>digit7, anod=>anod, catod=>catod,ptr=> punct_next);

punct_curr <= punct_next;



end Behavioral;
