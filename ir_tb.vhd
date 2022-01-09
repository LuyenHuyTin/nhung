

library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity ir_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end ir_tb;

 
 
architecture behavior of ir_tb is

  SIGNAL clk_test : STD_LOGIC;
  SIGNAL IR_in_test : STD_LOGIC_VECTOR (15 downto 0);
  SIGNAL IRld_test : STD_LOGIC;
  SIGNAL IR_out_test : STD_LOGIC_VECTOR (15 downto 0);
  component ir --datapath component
	Port(  clk : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           IRld : in STD_LOGIC;
           IR_out : out STD_LOGIC_VECTOR (15 downto 0));
  end component; 

   
   
   
begin
   
-- UUT componenet
  dut:  ir
    port map (     
      clk => clk_test,
      IR_in => IR_in_test,
      IRld => IRld_test,
      IR_out => IR_out_test
      );
   
-- Read process

  stimuli_proc :  process
  Begin
      -- Reset generation
      clk_test <= '1';
      IR_in_test <= "1000000000000000";
      IRld_test <= '1';
	    wait for 20 ns;
      clk_test <= '1';
      IR_in_test <= "1000000000000000";
      IRld_test <= '0';
	    wait for 20 ns;
      clk_test <= '0';
      IR_in_test <= "1000000000000000";
      IRld_test <= '1';
	    wait for 20 ns;

        
  end process stimuli_proc;
   
 

end behavior;