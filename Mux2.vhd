
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2_tt is
GENERIC(DATA_WIDTH : integer := 16);
    port(data_in0, data_in1, data_in2 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    	sel : in STD_LOGIC_VECTOR (1 downto 0);
    	data_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
    );
end Mux2_tt;
architecture Mux2_tt of Mux_tt is
begin
    with sel select
        data_out <= data_in0 when "00",
                    data_in1 when "01",
                    data_in2 when others;
end Mux2_tt;

