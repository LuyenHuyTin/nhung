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
    address : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    imm : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    OPr2 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    Mre : OUT STD_LOGIC;
    Mwe : OUT STD_LOGIC;
    data_out_mem : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    data_in_mem : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    RFwe : OUT STD_LOGIC;
    OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    OPr1e : OUT STD_LOGIC;
    OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    OPr2e : OUT STD_LOGIC;
    ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUz : OUT STD_LOGIC;
    add_ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    PC_inc : OUT STD_LOGIC;
    PC_clr : OUT STD_LOGIC;
    PC_ld : OUT STD_LOGIC;
    IR_ld : OUT STD_LOGIC;
    op : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0)
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

  SIGNAL OPr1e_in_cpu : STD_LOGIC;
  SIGNAL OPr2a_in_cpu : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL OPr2e_in_cpu : STD_LOGIC;
  SIGNAL ALUs_in_cpu : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL ALUz_in_cpu : STD_LOGIC;
  SIGNAL add_ms_in_cpu : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL PC_inc_in_cpu : STD_LOGIC;
  SIGNAL PC_clr_in_cpu : STD_LOGIC;
  SIGNAL PC_ld_in_cpu : STD_LOGIC;
  SIGNAL RFs_in_cpu : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL RFwa_in_cpu : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL RFwe_in_cpu : STD_LOGIC;
  SIGNAL OPr1a_in_cpu : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL IR_ld_in_cpu : STD_LOGIC;
  SIGNAL op_in_cpu : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
  SIGNAL address_in_cpu : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL imm_in_cpu : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL OPr2_in_cpu : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL Mre_in_cpu : STD_LOGIC;
  SIGNAL Mwe_in_cpu : STD_LOGIC;
  SIGNAL data_out_mem_in_cpu : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
  SIGNAL data_in_mem_in_cpu : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

BEGIN
  ctrl : control_unit
  PORT MAP(
    reset => reset,
    clk => clk,
    ALUz => ALUz_in_cpu,
    addr_in => OPr2_in_cpu,
    ir_data_in => data_out_mem_in_cpu,
    RFs => RFs_in_cpu,
    RFwa => RFwa_in_cpu,
    RFwe => RFwe_in_cpu,
    OPr1a => OPr1a_in_cpu,
    OPr1e => OPr1e_in_cpu,
    OPr2a => OPr2a_in_cpu,
    OPr2e => OPr2e_in_cpu,
    ALUs => ALUs_in_cpu,
    ADDR => address_in_cpu,
    Mre => Mre_in_cpu,
    Mwe => Mwe_in_cpu,
    imm => imm_in_cpu,
    add_ms => add_ms_in_cpu,
    PC_inc => PC_inc_in_cpu,
    PC_clr => PC_clr_in_cpu,
    PC_ld => PC_ld_in_cpu,
    IR_ld => IR_ld_in_cpu,
    op => op_in_cpu);

  data : datapath
  PORT MAP(
    rst => reset,
    clk => clk,
    imm => imm_in_cpu,
    input3 => data_out_mem_in_cpu,
    RFs => RFs_in_cpu,
    ALUs => ALUs_in_cpu,
    ALUz => ALUz_in_cpu,
    RFwa => RFwa_in_cpu,
    RFwe => RFwe_in_cpu,
    OPr1a => OPr1a_in_cpu,
    OPr1e => OPr1e_in_cpu,
    OPr2a => OPr2a_in_cpu,
    OPr2e => OPr2e_in_cpu,
    opr2_out => OPr2_in_cpu,
    opr1_out => data_in_mem_in_cpu
  );

  mem : memory
  PORT MAP(
    Clk => Clk,
    Reset => Reset,
    addr => address_in_cpu,
    Wen => Mwe_in_cpu,
    Datain => data_in_mem_in_cpu,
    Ren => Mre_in_cpu,
    Dataout => data_out_mem_in_cpu);
  address <= address_in_cpu;
  Mre <= Mre_in_cpu;
  Mwe <= Mwe_in_cpu;
  data_out_mem <= data_out_mem_in_cpu;
  data_in_mem <= data_in_mem_in_cpu;

  --
  imm <= imm_in_cpu;
  OPr2 <= OPr2_in_cpu;--noi datapath oi mux cua control
  --
  Mre <= Mre_in_cpu;
  Mwe <= Mwe_in_cpu;
  --
  data_out_mem <= data_out_mem_in_cpu; -- noi voi input3 datapath va ir_in 
  data_in_mem <= data_in_mem_in_cpu; -- tuong duong data out cua datapath
  -- 
  RFs <= RFs_in_cpu;
  RFwa <= RFwa_in_cpu;
  RFwe <= RFwe_in_cpu;
  --
  OPr1a <= OPr1a_in_cpu;
  OPr1e <= OPr1e_in_cpu;
  OPr2a <= OPr2a_in_cpu;
  OPr2e <= OPr2e_in_cpu;
  --
  ALUs <= ALUs_in_cpu;
  ALUz <= ALUz_in_cpu;
  --
  add_ms <= add_ms_in_cpu;
  PC_inc <= PC_inc_in_cpu;
  PC_clr <= PC_clr_in_cpu;
  PC_ld <= PC_ld_in_cpu;
  IR_ld <= IR_ld_in_cpu;

  op <= op_in_cpu;

END behav;