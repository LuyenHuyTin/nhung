
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all ;
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.Sys_Definition.all;

ENTITY mux IS
   GENERIC ( DATA_WIDTH : integer := 16);
   PORT (input1, input2, input3, input4: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
        SELECTION : IN 	 std_logic_vector (1 downto 0);
        Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0));
END mux;
ARCHITECTURE bev OF mux IS
BEGIN
    with SELECTION select
    z <= input1 when "00",
        input2 when "01",
        input3 when "10",
        input4 when others;
END bev;

