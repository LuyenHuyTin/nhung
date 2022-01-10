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
  
  component alu 
    port (
        OPr1 : in std_logic_vector(15 downto 0);
        OPr2 : in std_logic_vector(15 downto 0);
        ALUs : in std_logic_vector(1 downto 0);
        ALUz : out std_logic;
        ALUr : out std_logic_vector(15 downto 0)
    );
  end component;

  component mux
    PORT (input1, input2, input3, input4: IN  	std_logic_vector (DATA_WIDTH-1 downto 0);
          SELECTION : IN 	 std_logic_vector (1 downto 0);
          Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0)
                );
  END component;

  component rf_tt 
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

signal OPr_1 : std_logic_vector(15 downto 0);
signal OPr_2 : std_logic_vector(15 downto 0);
signal input2 : std_logic_vector(15 downto 0);

begin
	input2 <= x"00"& imm;
  uut_mux : mux
      port map (
          input1 => ALUr,
          input2 => input2,
          input3 => input3,
          input4 => input4,
          SELECTION => RFs,
          Z => RFin);
  uut_rf : rf_tt
      Port map ( 
          reset => rst,
          clk => clk,
          RFin => RFin,
          RFwa => RFwa,
          RFwe => RFwe,
          OPr1a => OPr1a,
          OPr1e => OPr1e,
          OPr2a => OPr2a,
          OPr2e => OPr2e,
          OPr1 => OPr_1,
          OPr2 => OPr_2);
  uut_alu: ALU 
      port map (
          OPr1 => OPr_1,
          OPr2 => OPr_2,
          ALUs => ALUs,
          ALUz => ALUz,
          ALUr => ALUr);
  add_out <= OPr_2;
  data_out <= OPr_1;

end struct;


