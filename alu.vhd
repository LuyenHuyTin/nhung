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
    PORT (w0, w1, w2, w3: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
         SEL : IN 	std_logic_vector (1 downto 0);
         Z: OUT std_logic_vector (DATA_WIDTH-1 downto 0)
                );
    END component;
 signal a : std_logic_vector(16 - 1 downto 0) := x"0000";
 signal b : std_logic_vector(16 - 1 downto 0) := x"0000";
 signal w0 : std_logic_vector(16 - 1 downto 0) ;
 signal w1 : std_logic_vector(16 - 1 downto 0) ;
 signal w2 : std_logic_vector(16 - 1 downto 0) ;
 signal w3 : std_logic_vector(16 - 1 downto 0) ;
--  signal ALUs : std_logic_vector(1 downto 0) ;
--  signal ALUz : std_logic;
--  signal ALUr : std_logic_vector(DATA_WIDTH downto 0);
begin
    mux : mux4to1
    port map(
        w0 => w0,
        w1 => w1,
        w2 => w2,
        w3 => w3,
        SEL => ALUs,
        Z => ALUr
    );
    a <= OPr1;
    b <= Opr2;
    w0 <= a+b;
    w1 <= a - b;
    w2 <= a or b;
    w3 <= a and b;
    ALUz <= '1' when  OPr1 = X"0000" else
            '0';    

end behav;