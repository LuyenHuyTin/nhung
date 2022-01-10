
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter is
    Port (I_clk : in  STD_LOGIC;
			I_reset : in  STD_LOGIC;
			I_halt : in  STD_LOGIC;
			
			I_int: in STD_LOGIC;
			O_int_ack: out STD_LOGIC;

			-- new memory interface
			MEM_I_ready : IN  std_logic;
			MEM_O_cmd : OUT  std_logic;
			MEM_O_we : OUT  std_logic;
			MEM_O_byteEnable : OUT  std_logic_vector(1 downto 0);
			MEM_O_addr : OUT  std_logic_vector(15 downto 0);
			MEM_O_data : OUT  std_logic_vector(15 downto 0);
			MEM_I_data : IN  std_logic_vector(15 downto 0);
			MEM_I_dataReady : IN  std_logic
	);
end program_counter;

architecture program_counter of program_counter is
signal PC_reg: STD_LOGIC_VECTOR (15 downto 0);
begin
    process(clk, PCclr)
    begin
       if PCclr = '1' then
                PC_reg <= (others => '0');
       elsif clk'event and clk = '1' then
            if PCld = '1' then
                PC_reg <= PC_in;
            elsif PCincr = '1' then
                PC_reg <= PC_reg + 1;
            end if;
        end if;
    end process;
    PC_out <= PC_reg;       
end program_counter;
