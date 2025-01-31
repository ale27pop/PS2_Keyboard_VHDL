----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2024 05:22:42 PM
-- Design Name: 
-- Module Name: Stack - Behavioral
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

entity stack is
    Port (
        clk      : in  STD_LOGIC;
        date_in  : in  STD_LOGIC_VECTOR (7 downto 0);
        date_out0: out STD_LOGIC_VECTOR (7 downto 0);
        date_out1: out STD_LOGIC_VECTOR (7 downto 0);
        date_out2: out STD_LOGIC_VECTOR (7 downto 0);
        date_out3: out STD_LOGIC_VECTOR (7 downto 0);
        date_out4: out STD_LOGIC_VECTOR (7 downto 0);
        date_out5: out STD_LOGIC_VECTOR (7 downto 0);
        date_out6: out STD_LOGIC_VECTOR (7 downto 0);
        date_out7: out STD_LOGIC_VECTOR (7 downto 0);
        ptr_n    : in  STD_LOGIC_VECTOR (3 downto 0);
        ptr      : out STD_LOGIC_VECTOR (3 downto 0);
        rst      : in  STD_LOGIC;
        stack_op : in  STD_LOGIC_VECTOR (1 downto 0)
    );
end stack;

architecture Behavioral of stack is
    type memorie is array (0 to 15) of std_logic_vector(7 downto 0);
    signal stocare: memorie := (others => x"FF");

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                ptr <= (others => '0');
                stocare <= (others => x"FF");
            else
                case stack_op is
                    when "10" => -- push
                        if (date_in = x"41" and not(ptr_n = "0000")) then -- sageata stanga
                            ptr <= std_logic_vector(unsigned(ptr_n) - 1);
                        elsif (date_in = x"49" and not(ptr_n = "1111")) then -- sageata dreapta
                            ptr <= std_logic_vector(unsigned(ptr_n) + 1);
                        elsif (ptr_n = "1111") then -- in caz ca trebuie shiftat cand e gata
                            if (not(stocare(15) = x"FF")) then -- daca 7 nu e gol
                                for i in 0 to 14 loop
                                    stocare(i) <= stocare(i + 1);
                                end loop;
                            end if;
                            ptr <= ptr_n;
                            stocare(15) <= date_in;
                        elsif (ptr_n < "1111" and ptr_n > "0000") then
                            ptr <= std_logic_vector(unsigned(ptr_n) + 1);
                        elsif (ptr_n = "0000") then
                            if (stocare(0) = x"FF") then
                                stocare(0) <= date_in;
                            else
                                ptr <= std_logic_vector(unsigned(ptr_n) + 1);
                            end if;
                        else
                           
                            ptr <= std_logic_vector(unsigned(to_unsigned(to_integer(unsigned(ptr_n)), ptr'length)) + 1);

                        end if;
                    when "01" => -- pop
                        if (ptr_n = "0000") then
                            stocare(0) <= x"FF";
                        elsif (ptr_n < "1111" and ptr_n > "0000") then
                            stocare(to_integer(unsigned(ptr_n))) <= date_in;
                            ptr <= std_logic_vector(unsigned(to_unsigned(to_integer(unsigned(ptr_n)), ptr'length)) + 1);
                        else
                            stocare(15) <= x"FF";
                        end if;
                        ptr <= std_logic_vector(unsigned(ptr_n) - 1);
                    when others =>
                        ptr <= ptr_n;
                end case;
            end if;
        end if;
    end process;

    date_out0 <= stocare(1);
    date_out1 <= stocare(3);
    date_out2 <= stocare(5);
    date_out3 <= stocare(7);
    date_out4 <= stocare(9);
    date_out5 <= stocare(11);
    date_out6 <= stocare(13);
    date_out7 <= stocare(15);

end Behavioral;


