

library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity controller_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end controller_tb;

 
 
architecture behavior of controller_tb is
   
   SIGNAL reset_test :STD_LOGIC; 
   SIGNAL clk_test :STD_LOGIC; 
   SIGNAL ALUz_test, ALUeq_test, ALUgt_test :STD_LOGIC;
   SIGNAL Instr_in_test :STD_LOGIC_VECTOR(15 downto 0);
   SIGNAL RFs_test : STD_LOGIC_VECTOR(1 downto 0);
   SIGNAL RFwa_test : STD_LOGIC_VECTOR(3 downto 0);
   SIGNAL RFwe_test : STD_LOGIC;
   SIGNAL OPr1a_test : STD_LOGIC_VECTOR(3 downto 0);
   SIGNAL OPr1e_test : STD_LOGIC;
   SIGNAL OPr2a_test : STD_LOGIC_VECTOR(3 downto 0);
   SIGNAL OPr2e_test : STD_LOGIC;
   SIGNAL ALUs_test : STD_LOGIC_VECTOR(1 downto 0);
   SIGNAL IRld_test : STD_LOGIC;
   SIGNAL PCincr_test : STD_LOGIC;
   SIGNAL PCclr_test : STD_LOGIC;
   SIGNAL PCld_test : STD_LOGIC;
   SIGNAL Addr_sel_test : STD_LOGIC_VECTOR(1 downto 0);
   SIGNAL Mre_test : STD_LOGIC;
   SIGNAL Mwe_test : STD_LOGIC;
 
  component controller_tt --datapath component
	Port (reset : in STD_LOGIC; 
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
        Mwe : out STD_LOGIC );
  end component; 

   
begin

  dut:  controller_tt
    port map (     
        reset  => reset_test, 
        clk  => clk_test, 
        ALUz  => ALUz_test,
        ALUeq  => ALUeq_test,
        ALUgt  => ALUgt_test,
        Instr_in =>  Instr_in_test,
        RFs =>  RFs_test,
        RFwa  => RFwa_test,
        RFwe  => RFwe_test,
        OPr1a => OPr1a_test,
        OPr1e =>  OPr1e_test,
        OPr2a =>  OPr2a_test,
        OPr2e  => OPr2e_test,
        ALUs  => ALUs_test,
        IRld  => IRld_test,
        PCincr  => PCincr_test,
        PCclr =>  PCclr_test,
        PCld =>  PCld_test,
        Addr_sel =>  Addr_sel_test,
        Mre =>  Mre_test,
        Mwe =>  Mwe_test
      );
   
-- Read process
-- reset : in STD_LOGIC; 
-- clk : in STD_LOGIC; 
-- ALUz, ALUeq, ALUgt : in STD_LOGIC;
-- Instr_in : in STD_LOGIC_VECTOR(15 downto 0);
  stimuli_proc :  process
  Begin
      -- Reset generation
  	-- clk = 0
    clk_test <= '0';
    reset_test <= '0';
    ALUz_test <= '1';
    ALUeq_test <= '0';
    ALUgt_test <= '0';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;
    reset_test <= '1';
    ALUz_test <= '0';
    ALUeq_test <= '1';
    ALUgt_test <= '0';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;
    ALUz_test <= '0';
    ALUeq_test <= '0';
    ALUgt_test <= '1';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;
    -- clk = 1
    clk_test <= '1';
    clk_test <= '0';
    reset_test <= '0';
    ALUz_test <= '1';
    ALUeq_test <= '0';
    ALUgt_test <= '0';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;
    reset_test <= '1';
    ALUz_test <= '0';
    ALUeq_test <= '1';
    ALUgt_test <= '0';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;
    ALUz_test <= '0';
    ALUeq_test <= '0';
    ALUgt_test <= '1';
    Instr_in_test <= "1010101010101010";
    wait for 20 ns;

        
  end process stimuli_proc;
   
 
end behavior;
--vopt  +acc + controller_tb -o controller_tb_opt