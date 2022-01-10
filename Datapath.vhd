LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY datapath IS
  GENERIC (
    DATA_WIDTH : INTEGER := 16; -- Data Width
    ADDR_WIDTH : INTEGER := 4 -- Address width
  );
  PORT (
    rst : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    imm : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    input3 : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    RFs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUz : OUT STD_LOGIC;
    RFwa : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    RFwe : IN STD_LOGIC;
    OPr1a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    OPr1e : IN STD_LOGIC;
    OPr2a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    OPr2e : IN STD_LOGIC;
    opr2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    opr1_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END datapath;

ARCHITECTURE struct OF datapath IS

  COMPONENT alu
    PORT (
      OPr1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      OPr2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      ALUz : OUT STD_LOGIC;
      ALUr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT mux
    PORT (
      input1, input2, input3, input4 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
      SELECTION : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT rf_tt
    PORT (
      reset : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      RFin : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
      RFwa : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
      RFwe : IN STD_LOGIC;
      OPr1a : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
      OPr1e : IN STD_LOGIC;
      OPr2a : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
      OPr2e : IN STD_LOGIC;
      OPr1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
      OPr2 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0));
  END COMPONENT;
  SIGNAL ALUr : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL RFin : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL input4 : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

  SIGNAL OPr_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL OPr_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL input2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
  input2 <= x"00" & imm;
  uut_mux : mux
  PORT MAP(
    input1 => ALUr,
    input2 => input2,
    input3 => input3,
    input4 => input4,
    SELECTION => RFs,
    Z => RFin);
  uut_rf : rf_tt
  PORT MAP(
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
  uut_alu : ALU
  PORT MAP(
    OPr1 => OPr_1,
    OPr2 => OPr_2,
    ALUs => ALUs,
    ALUz => ALUz,
    ALUr => ALUr);
  opr2_out <= OPr_2;
  opr1_out <= OPr_1;

END struct;