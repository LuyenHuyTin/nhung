
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY mux IS
    GENERIC (DATA_WIDTH : INTEGER := 16);
    PORT (
        input1, input2, input3, input4 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        SELECTION : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0));
END mux;
ARCHITECTURE bev OF mux IS
BEGIN
    WITH SELECTION SELECT
        z <= input1 WHEN "00",
        input2 WHEN "01",
        input3 WHEN "10",
        input4 WHEN OTHERS;
END bev;