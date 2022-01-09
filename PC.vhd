
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
    Port ( clk : in STD_LOGIC;
           PCclr : in STD_LOGIC;
           PCincr : in STD_LOGIC;
           PCld : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           PC_out : out STD_LOGIC_VECTOR (15 downto 0));
end program_counter;

architecture program_counter of program_counter is
signal PC_reg: STD_LOGIC_VECTOR (15 downto 0);
begin
    process(clk, PCclr)
    begin
       if PCclr = '1' then
                PC_reg <= (others => '0');
       elsif clk'event and clk = '1' then
            if PCld = '1' then
                PC_reg <= PC_in;
            elsif PCincr = '1' then
                PC_reg <= PC_reg + 1;
            end if;
        end if;
    end process;
    PC_out <= PC_reg;       
end program_counter;
