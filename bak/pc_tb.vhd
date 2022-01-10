

library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity pc_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end pc_tb;

 
 
architecture behavior of pc_tb is

  SIGNAL clk_test : STD_LOGIC;
  SIGNAL PCclr_test : STD_LOGIC;
  SIGNAL PCincr_test : STD_LOGIC;
  SIGNAL PCld_test : STD_LOGIC;
  SIGNAL PC_in_test : STD_LOGIC_VECTOR (15 downto 0);
  SIGNAL PC_out_test : STD_LOGIC_VECTOR (15 downto 0);
  component pc --datapath component
    Port (clk : in STD_LOGIC;
          PCclr : in STD_LOGIC;
          PCincr : in STD_LOGIC;
          PCld : in STD_LOGIC;
          PC_in : in STD_LOGIC_VECTOR (15 downto 0);
          PC_out : out STD_LOGIC_VECTOR (15 downto 0));
  end component; 

   
   
   
begin
   
-- UUT componenet
  dut:  pc
    port map (     
      clk => clk_test,
      PCclr => PCclr_test,
      PCincr => PCincr_test,
      PCld => PCld_test,
      PC_in => PC_in_test,
      PC_out => PC_out_test
      );
   
-- Read process

  stimuli_proc :  process
  Begin
      -- Reset generation
      clk_test <= '1';
      PCclr_test <= '1';
      PCincr_test <= '1';
      PCld_test <= '1';
      PC_in_test <= "1000000000000000";
      wait for 20 ns;
      clk_test <= '1';
      PCclr_test <= '0';
      PCincr_test <= '0';
      PCld_test <= '1';
      PC_in_test <= "1000000000000000";
      wait for 20 ns;
      clk_test <= '0';
      PCclr_test <= '1';
      PCincr_test <= '1';
      PCld_test <= '1';
      PC_in_test <= "1000000000000000";
      wait for 20 ns;
        
  end process stimuli_proc;
   
end behavior;