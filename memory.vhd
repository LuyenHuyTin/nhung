library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity memory is
  generic (
    DATA_WIDTH        :     integer   := 16;     
    ADDR_WIDTH        :     integer   := 16      
    );

  port (
      Clk: in  std_logic; 
      Reset  : in  std_logic; 
      addr: in  std_logic_vector(ADDR_WIDTH -1 downto 0);   
      Wen : in  std_logic; 
      Datain : in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');   
      Ren : in  std_logic; 
      Dataout: out std_logic_vector(DATA_WIDTH -1 downto 0)   
    );
end memory;
 
architecture memory_architecture of memory is
   
  type DATA_ARRAY is array (integer range <>) of std_logic_vector(DATA_WIDTH -1 downto 0);
  signal   M       :     DATA_ARRAY(0 to (2**ADDR_WIDTH) -1) := (others => (others => '0'));  
  constant PM_Size : Integer := 4;
  constant PM : DATA_ARRAY(0 to (2**PM_Size) - 1) := (	
    X"3163",	
    X"1164",		
    X"3A58",   
    X"4A10",   
    X"8A10",   
    X"0000",    
    X"0000",   
    X"0000",    
    X"0000",   
    X"0000",   
    others => x"0000");
  signal en : std_logic;
begin  
	
	
  check_addr : process(addr)
  begin 
    if(conv_integer(addr) >= (2**PM_Size) and conv_integer(addr) <= (2**ADDR_WIDTH) -1) then
      en <= '1';
    else
      en <= '0';
    end if;
  end process;

  RW_Proc : process (clk, Reset)
  begin  
    if Reset = '1' then
          Dataout <= (others => '0');
          M(0 to (2**PM_Size)-1) <= PM; 
    elsif (clk'event and clk = '1') then   
        if Wen = '1' and en = '1' then
			   M(conv_integer(addr))      <= Datain; 
        else
			   if Ren = '1' and en = '1' then
				    Dataout <= M(conv_integer(addr));
			   else
				Dataout <= (others => 'Z');
			end if;
		end if;
      end if;
  end process  RW_Proc;
     
end memory_architecture;