library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity alu is
    port (
        OPr1 : in std_logic_vector(15 downto 0);
        OPr2 : in std_logic_vector(15 downto 0);
        ALUs : in std_logic_vector(1 downto 0);
        ALUz : out std_logic;
        ALUr : out std_logic_vector(15 downto 0)
    );
end alu;

architecture behav of alu is
    component mux4to1
    GENERIC ( 
             DATA_WIDTH : integer := 16);
    PORT (input1, input2, input3, input4: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
         SEL : IN 	std_logic_vector (1 downto 0);
         Z: OUT std_logic_vector (DATA_WIDTH-1 downto 0)
                );
    END component;
 signal a : std_logic_vector(16 - 1 downto 0) := x"0000";
 signal b : std_logic_vector(16 - 1 downto 0) := x"0000";
 signal input1 : std_logic_vector(16 - 1 downto 0) ;
 signal input2 : std_logic_vector(16 - 1 downto 0) ;
 signal input3 : std_logic_vector(16 - 1 downto 0) ;
 signal input4 : std_logic_vector(16 - 1 downto 0) ;
--  signal ALUs : std_logic_vector(1 downto 0) ;
--  signal ALUz : std_logic;
--  signal ALUr : std_logic_vector(DATA_WIDTH downto 0);
begin
    mux : mux4to1
    port map(
        input1 => input1,
        input2 => input2,
        input3 => input3,
        input4 => input4,
        SEL => ALUs,
        Z => ALUr
    );
    a <= OPr1;
    b <= Opr2;
    input1 <= a+b;
    input2 <= a - b;
    input3 <= a or b;
    input4 <= a and b;
    ALUz <= '1' when  OPr1 = X"0000" else
            '0';    

end behav;