-- Nguyen Kiem Hung
-- datapath for microprocessor

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity datapath is
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 4     -- Address width
    );
   port ( 
        rst     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        imm     : in std_logic_vector(7 downto 0); 
        input3      : in std_logic_vector(DATA_WIDTH -1 downto 0); 
        RFs : in std_logic_vector(1 downto 0);
        ALUs : in std_logic_vector(1 downto 0);
        ALUz : out std_logic;
        RFwa : in std_logic_vector(3 downto 0);
        RFwe : in std_logic;
        OPr1a : in std_logic_vector(3 downto 0);
        OPr1e : in std_logic;
        OPr2a : in std_logic_vector(3 downto 0);
        OPr2e : in std_logic;
        add_out : out std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0)
        );
end datapath;

architecture struct of datapath is
  -- ALU
  component alu 
    port (
        OPr1 : in std_logic_vector(15 downto 0);
        OPr2 : in std_logic_vector(15 downto 0);
        ALUs : in std_logic_vector(1 downto 0);
        ALUz : out std_logic;
        ALUr : out std_logic_vector(15 downto 0)
    );
end component;

-- mux 4 -> 1 
component mux4to1
   GENERIC ( DATA_WIDTH : integer := 16);
   PORT (input1, input2, input3, input4: IN  	std_logic_vector (DATA_WIDTH-1 downto 0);
        SEL : IN 	 std_logic_vector (1 downto 0);
        Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0)
               );
END component;
-- RF
component register_file 
  generic(
      DATA_WIDTH : integer := 16;
      ADDR_WIDTH : integer := 4
  );
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


signal ALUr : std_logic_vector(15 downto 0);
signal RFin : std_logic_vector(15 downto 0);
signal input4 : std_logic_vector(15 downto 0) := x"0000";

signal o1 : std_logic_vector(15 downto 0);
signal o2 : std_logic_vector(15 downto 0);
signal input2 : std_logic_vector(15 downto 0);

begin
-- write your code here
  -- MUX_U: MUX4to1 port map(?);
	input2 <= x"00"& imm;
  mux : mux4to1
  port map(ALUr, input2, input3, input4, RFs, RFin);
  --RF_U: REG_FILE port map (?);
  rf_u : register_file
  port map(rst,clk,RFin,RFwa,RFwe,OPr1a,OPr1e,OPr2a,OPr2e,o1,o2);
  --ALU_U: alu port map (?);
  alu_u: ALU 
  port map(o1,o2,ALUs,ALUz,ALUr);

  add_out <= o2;
  data_out <= o1;
 -- ALU_out <= ALUr;

  


end struct;


