LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY alu IS
    PORT (
        OPr1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OPr2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUz : OUT STD_LOGIC;
        ALUr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END alu;

ARCHITECTURE behav OF alu IS
    COMPONENT mux
        GENERIC (
            DATA_WIDTH : INTEGER := 16);
        PORT (
            input1, input2, input3, input4 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            SELECTION : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL num1 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0) := x"0000";
    SIGNAL num2 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0) := x"0000";
    SIGNAL input1 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
    SIGNAL input2 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
    SIGNAL input3 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
    SIGNAL input4 : STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
BEGIN
    uut_mux : mux
    PORT MAP(
        input1 => input1,
        input2 => input2,
        input3 => input3,
        input4 => input4,
        SELECTION => ALUs,
        Z => ALUr
    );
    num1 <= OPr1;
    num2 <= Opr2;
    input1 <= num1 + num2b;
    input2 <= num1 - num2;
    input3 <= num1 OR num2;
    input4 <= num1 AND num2;
    ALUz <= '1' WHEN OPr1 = X"0000" ELSE
        '0';

END behav;