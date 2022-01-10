
library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity register_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end register_tb;

  
architecture behavior of register_tb is
  SIGNAL reset_test : STD_LOGIC;
  SIGNAL clk_test : STD_LOGIC;
  SIGNAL RFin_test : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
  SIGNAL RFwa_test : STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
  SIGNAL RFwe_test : STD_LOGIC;
  SIGNAL OPr1a_test : STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
  SIGNAL OPr1e_test : STD_LOGIC;
  SIGNAL OPr2a_test : STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
  SIGNAL OPr2e_test : STD_LOGIC;
  SIGNAL OPr1_test : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
  SIGNAL OPr2_test : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);

  component register_tt --datapath component
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
   
   
begin
   
-- UUT componenet
  dut:  register_tt
    port map (     
      reset => reset_test,
      clk =>   clk_test,
      RFin =>  RFin_test,
      RFwa =>  RFwa_test,
      RFwe =>  RFwe_test,
      OPr1a => OPr1a_test,
      OPr1e => OPr1e_test,
      OPr2a => OPr2a_test,
      OPr2e => OPr2e_test,
      OPr1 =>  OPr1_test,
      OPr2 =>  OPr2_test);
   
-- Read process

  stimuli_proc :  process
  Begin
      -- Reset generation
      reset_test <= '1';
      clk_test <= '1';
      RFin_test <= "10";
      RFwa_test <= "10";
      RFwe_test <= '1';
      OPr1a_test <= "10";
      OPr1e_test <= '1';
      OPr2a_test <= "10";
      OPr2e_test <= '1';
      wait for 20 ns;
      reset_test <= '0';
      clk_test <= '1';
      RFin_test <= "01";
      RFwa_test <= "01";
      RFwe_test <= '1';
      OPr1a_test <= "11";
      OPr1e_test <= '1';
      OPr2a_test <= "10";
      OPr2e_test <= '1';
      wait for 20 ns;
      reset_test <= '1';
      clk_test <= '0';
      RFin_test <= "10";
      RFwa_test <= "10";
      RFwe_test <= '1';
      OPr1a_test <= "10";
      OPr1e_test <= '1';
      OPr2a_test <= "10";
      OPr2e_test <= '1';
      wait for 20 ns;
        
  end process stimuli_proc;
   
 

end behavior;