
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all ;
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.Sys_Definition.all;

ENTITY mux4to1 IS
   GENERIC ( DATA_WIDTH : integer := 16);
   PORT (w0, w1, w2, w3: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
        SEL : IN 	 std_logic_vector (1 downto 0);
        Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0));
END mux4to1;
ARCHITECTURE bev OF mux4to1 IS
BEGIN
    -- write your code here
    with sel select
    z <= w0 when "00",
        w1 when "01",
        w2 when "10",
        w3 when others;
END bev;

