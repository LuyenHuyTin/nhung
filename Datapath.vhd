
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is

	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end Datapath;

architecture Behavioral of Datapath is

--GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
component registor_tt --datapath registor
	 Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           RFin : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           RFwa : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           RFwe : in STD_LOGIC;
           OPr1a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           OPr1e : in STD_LOGIC;
           OPr2a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           OPr2e : in STD_LOGIC;
           OPr1 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           OPr2 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));

end component;

component ALU_tt --datapath component
 Port ( OPr1 : in STD_LOGIC_VECTOR
	 (DATA_WIDTH - 1 downto 0);
          OPr2 : in STD_LOGIC_VECTOR
	 (DATA_WIDTH - 1 downto 0);
           ALUs : in STD_LOGIC_VECTOR (1 downto 0);
           ALUr : out STD_LOGIC_VECTOR
	  (DATA_WIDTH - 1 downto 0);
           ALUz : out STD_LOGIC );
end component;

component Controller_tt
 port(
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz, ALUeq, ALUgt : in STD_LOGIC;
        Instr_in : in STD_LOGIC_VECTOR(15 downto 0);
        RFs : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa : out STD_LOGIC_VECTOR(3 downto 0);
        RFwe : out STD_LOGIC;
        OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr2e : out STD_LOGIC;
        ALUs : out STD_LOGIC_VECTOR(1 downto 0);
        IRld : out STD_LOGIC;
        PCincr : out STD_LOGIC;
        PCclr : out STD_LOGIC;
        PCld : out STD_LOGIC;
        Addr_sel : out STD_LOGIC_VECTOR(1 downto 0);
        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC 
        );
end component;

component Mux_tt --datapath mux
	port( 
	data_in0, data_in1, data_in2 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    	sel : in STD_LOGIC_VECTOR (1 downto 0);
    	data_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
    );
end component;

component PC_tt
Port ( 
	   clk : in STD_LOGIC;
           PCclr : in STD_LOGIC;
           PCincr : in STD_LOGIC;
           PCld : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (15 downto 0);
           PC_out : out STD_LOGIC_VECTOR (15 downto 0));
end component;
begin


END Behavioral;

