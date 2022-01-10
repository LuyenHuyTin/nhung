library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir is
    port (
        clk : in std_logic;
        IRld : in std_logic;
        IRin : in std_logic_vector(15 downto 0);
        IRout : out std_logic_vector(15 downto 0)
    );
end ir;

architecture behav of ir is
signal data : std_logic_vector(15 downto 0);
begin
    ir_pro : process(clk)
    begin
        if(clk ='1' and clk'event) then
            if(IRld = '1') then 
                data <= IRin;
            end if;
        end if;
    end process;
    IRout <= data;
end behav;