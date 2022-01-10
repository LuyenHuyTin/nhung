library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity pc is
        port (
            clk : in std_logic;
            PCclr : in std_logic;
            PCinc : in std_logic;
            PCld : in std_logic;
            PCd_in : in std_logic_vector(7 downto 0);
            PCd_out : out std_logic_vector(15 downto 0)
        );
end pc;

architecture pc_behav of pc is
    signal data : std_logic_vector(15 downto 0);
begin
    pc_pro : process(clk,PCclr)
    begin
        if(PCclr = '1') then 
            data <= X"0000";
        elsif(clk='1'and clk'event) then
            if(PCld = '1') then
                data <= X"00" & PCd_in;
            end if;
            if(PCinc = '1') then
                data <= data + "1";
            end if;
        end if;
    end process;
    PCd_out <= data;
end pc_behav;