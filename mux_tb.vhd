
library ieee;
--use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
--use work.sys_definition.all;
 
--use alu.all;
 
entity mux_tb is
	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer :=4);
end mux_tb;

 
 
architecture behavior of mux_tb is

  SIGNAL data_in0_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
  SIGNAL data_in1_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); 
  SIGNAL data_in2_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
  SIGNAL sel_test:STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL data_out_test:STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

  component Mux_tt --datapath component
	Port (data_in0 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              data_in1 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	      data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              data_out : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
              sel : in STD_LOGIC_VECTOR (1 downto 0));
  end component; 

   
   
   
begin
   
-- UUT componenet
  dut:  Mux_tt
    port map (     
      data_in0      => data_in0_test,
      data_in1   => data_in1_test,
      data_in2     => data_in2_test,
      sel       => sel_test,
      data_out    => data_out_test   
      );
   
-- Read process

  stimuli_proc :  process
  Begin
      -- Reset generation
  	data_in0_test <= "1010010100110111";
	data_in1_test <= "0011011010010111";
	data_in2_test <= "0011011010010111";
	sel_test <= "00";
	wait for 20 ns;
	sel_test <= "01";
	wait for 20 ns;
	sel_test <= "10";
	wait for 20 ns;
	sel_test <= "11";
	wait for 20 ns;

        
  end process stimuli_proc;
   
 
end behavior;
--vopt  +acc + mux_tb -o mux_tb_opt