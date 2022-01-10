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
  constant codes : DATA_ARRAY(0 to 15) := (	
    X"0119",	-- mov1 rf(1) = M(19)
    X"1119",	-- mov2 M(19) = rf(1)
    X"2110",  -- mov3 M((rm==1)) = (rn==2)
    X"3219",  -- mov4 RF(2) = 19(hex)
    X"4220",  -- add RF(2) = RF(2) + RF(2)
    X"5220",  -- subRF(2) = RF(2) - RF(2)
    X"6205",  -- jz RF(2) addr = 5
    X"7210",  -- or  RF(2) = RF(2) or RF(1)
    X"8210",  -- and  RF(2) = RF(2) and RF(1)
    X"9105",   -- jmp rn =1  addr = 5
    others => x"0000");
  signal en : std_logic;
begin  
	
	
  check_addr : process(addr)
  begin 
    if(conv_integer(addr) >= (9) and conv_integer(addr) <= (2**ADDR_WIDTH) -1) then
      en <= '1';
    else
      en <= '0';
    end if;
  end process;

  RW_Proc : process (clk, Reset)
  begin  
    if Reset = '1' then
          Dataout <= (others => '0');
          M(0 to 15) <= codes; 
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