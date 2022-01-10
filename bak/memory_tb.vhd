

library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity alu_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
end alu_tb;

 
 
architecture behavior of alu_tb is

  SIGNAL opr1_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
  SIGNAL opr2_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); 
  SIGNAL alus_test:STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL alur_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
  SIGNAL aluz_test:STD_LOGIC;
  component alu --datapath component
	Port (OPr1 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              OPr2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              ALUs : in STD_LOGIC_VECTOR (1 downto 0);
              ALUr : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              ALUz : out STD_LOGIC );
  end component; 

   
   
   
begin
   
-- UUT componenet
  dut:  alu
    port map (     
      OPr1      => opr1_test,
      OPr2   => opr2_test,
      ALUs     => alus_test,
      ALUr       => alur_test,
      ALUz    => aluz_test   
      );
   
-- Read process

  stimuli_proc :  process
  Begin
      -- Reset generation
  	opr1_test <= "1010010100110111";
	opr2_test <= "0011011010010111";
	alus_test <= "00";
	wait for 20 ns;
	alus_test <= "01";
	wait for 20 ns;
	alus_test <= "10";
	wait for 20 ns;
	alus_test <= "11";
	wait for 20 ns;

        
  end process stimuli_proc;
   
 

end behavior;