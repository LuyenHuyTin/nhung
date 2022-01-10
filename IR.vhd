LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ir IS
    PORT (
        clk : IN STD_LOGIC;
        IRld : IN STD_LOGIC;
        IRin : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IRout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ir;

ARCHITECTURE behav OF ir IS
    SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    ir_pro : PROCESS (clk)
    BEGIN
        IF (clk = '1' AND clk'event) THEN
            IF (IRld = '1') THEN
                data <= IRin;
            END IF;
        END IF;
    END PROCESS;
    IRout <= data;
END behav;