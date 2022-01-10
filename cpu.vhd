LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cpu IS
  GENERIC (
    DATA_WIDTH : INTEGER := 16;
    ADDR_WIDTH : INTEGER := 4);
  PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    address_t : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    imm_t : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    OPr2_t : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    Mre_t : OUT STD_LOGIC;
    Mwe_t : OUT STD_LOGIC;
    data_out_mem_t : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    data_in_mem_t : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    RFs_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    RFwa_t : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    RFwe_t : OUT STD_LOGIC;
    OPr1a_t : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    OPr1e_t : OUT STD_LOGIC;
    OPr2a_t : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    OPr2e_t : OUT STD_LOGIC;
    ALUs_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUz_t : OUT STD_LOGIC;
    add_ms_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    PC_inc_t : OUT STD_LOGIC;
    PC_clr_t : OUT STD_LOGIC;
    PC_ld_t : OUT STD_LOGIC;
    IR_ld_t : OUT STD_LOGIC;
    op_t : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0)
  );
END cpu;

ARCHITECTURE behav OF cpu IS
  --control unit
  COMPONENT control_unit
    PORT (
      reset : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      ALUz : IN STD_LOGIC;
      addr_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      ir_data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      RFwe : OUT STD_LOGIC;
      OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      OPr1e : OUT STD_LOGIC;
      OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      OPr2e : OUT STD_LOGIC;
      ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      ADDR : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      Mre : OUT STD_LOGIC;
      Mwe : OUT STD_LOGIC;
      imm : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
      add_ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      PC_inc : OUT STD_LOGIC;
      PC_clr : OUT STD_LOGIC;
      PC_ld : OUT STD_LOGIC;
      IR_ld : OUT STD_LOGIC;
      op : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT datapath
    PORT (
      rst : IN STD_LOGIC;
      clk : IN STD_LOGIC;
      imm : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      input3 : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      RFs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      ALUs : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      ALUz : OUT STD_LOGIC;
      RFwa : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      RFwe : IN STD_LOGIC;
      OPr1a : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      OPr1e : IN STD_LOGIC;
      OPr2a : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
      OPr2e : IN STD_LOGIC;
      opr2_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      opr1_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0));
  END COMPONENT;

  -- memory
  COMPONENT memory
    PORT (
      Clk : IN STD_LOGIC;
      Reset : IN STD_LOGIC;
      addr : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
      Wen : IN STD_LOGIC;
      Datain : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
      Ren : IN STD_LOGIC;
      Dataout : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL OPr1e : STD_LOGIC;
  SIGNAL OPr2a : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL OPr2e : STD_LOGIC;
  SIGNAL ALUs : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ALUz : STD_LOGIC;
  SIGNAL add_ms : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL PC_inc : STD_LOGIC;
  SIGNAL PC_clr : STD_LOGIC;
  SIGNAL PC_ld : STD_LOGIC;
  SIGNAL RFs : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL RFwa : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL RFwe : STD_LOGIC;
  SIGNAL OPr1a : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL IR_ld : STD_LOGIC;
  SIGNAL op : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL address : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL imm : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL OPr2 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL Mre : STD_LOGIC;
  SIGNAL Mwe : STD_LOGIC;
  SIGNAL data_out_mem : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL data_in_mem : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
  ctrl : control_unit
  PORT MAP(
    reset => reset,
    clk => clk,
    ALUz => ALUz,
    addr_in => OPr2,
    ir_data_in => data_out_mem,
    RFs => RFs,
    RFwa => RFwa,
    RFwe => RFwe,
    OPr1a => OPr1a,
    OPr1e => OPr1e,
    OPr2a => OPr2a,
    OPr2e => OPr2e,
    ALUs => ALUs,
    ADDR => address,
    Mre => Mre,
    Mwe => Mwe,
    imm => imm,
    add_ms => add_ms,
    PC_inc => PC_inc,
    PC_clr => PC_clr,
    PC_ld => PC_ld,
    IR_ld => IR_ld,
    op => op);

  data : datapath
  PORT MAP(
    rst => reset,
    clk => clk,
    imm => imm,
    input3 => data_out_mem,
    RFs => RFs,
    ALUs => ALUs,
    ALUz => ALUz,
    RFwa => RFwa,
    RFwe => RFwe,
    OPr1a => OPr1a,
    OPr1e => OPr1e,
    OPr2a => OPr2a,
    OPr2e => OPr2e,
    opr2_out => OPr2,
    opr1_out => data_in_mem
  );

  mem : memory
  PORT MAP(
    Clk => Clk,
    Reset => Reset,
    addr => address,
    Wen => Mwe,
    Datain => data_in_mem,
    Ren => Mre,
    Dataout => data_out_mem);
  address_t <= address;
  Mre_t <= Mre;
  Mwe_t <= Mwe;
  data_out_mem_t <= data_out_mem;
  data_in_mem_t <= data_in_mem;

  --
  imm_t <= imm;
  OPr2_t <= OPr2;--noi datapath oi mux cua control
  --
  Mre_t <= Mre;
  Mwe_t <= Mwe;
  --
  data_out_mem_t <= data_out_mem; -- noi voi input3 datapath va ir_in 
  data_in_mem_t <= data_in_mem; -- tuong duong data out cua datapath
  -- 
  RFs_t <= RFs;
  RFwa_t <= RFwa;
  RFwe_t <= RFwe;
  --
  OPr1a_t <= OPr1a;
  OPr1e_t <= OPr1e;
  OPr2a_t <= OPr2a;
  OPr2e_t <= OPr2e;
  --
  ALUs_t <= ALUs;
  ALUz_t <= ALUz;
  --
  add_ms_t <= add_ms;
  PC_inc_t <= PC_inc;
  PC_clr_t <= PC_clr;
  PC_ld_t <= PC_ld;
  IR_ld_t <= IR_ld;

  op_t <= op;

END behav;