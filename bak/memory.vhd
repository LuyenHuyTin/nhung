library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity dpmem is
  generic (
    DATA_WIDTH        :     integer   := 16;   
    ADDR_WIDTH        :     integer   := 16
    );

  port (
    Clk              : in  std_logic;          -- clock
	nReset             : in  std_logic; -- Reset input
    addr              : in  std_logic_vector(ADDR_WIDTH -1 downto 0);   --  Address
	Wen               : in  std_logic;          -- Write Enable
    Datain            : in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');   -- Input Data
    Ren               : in  std_logic;          -- Read Enable
    Dataout           : out std_logic_vector(DATA_WIDTH -1 downto 0)   -- Output data
    
    );
end dpmem;
 
architecture dpmem_arch of dpmem is
   
  type DATA_ARRAY is array (integer range <>) of std_logic_vector(DATA_WIDTH -1 downto 0); -- Memory Type
  signal   M       :     DATA_ARRAY(0 to (2**ADDR_WIDTH) -1) := (others => (others => '0'));  -- Memory model
  constant PM_Size : Integer := 2; -- Size of program memory :(range 255 downto 0 )
  constant PM : DATA_ARRAY(0 to PM_Size-1) := (	
    X"0003",	-- Mov R0,3 => R0 = M(3)
    X"1007"		-- Mov 7,R0 => M(7) = R0
    );
begin  -- dpmem_arch
	
  RW_Proc : process (clk, nReset)
  begin  
    if nReset = '0' then
          Dataout <= (others => '0');
          M(0 to PM_Size-1) <= PM; -- initialize program memory
    elsif (clk'event and clk = '1') then   -- rising clock edge
        if Wen = '1' then
			   M(conv_integer(addr)+PM_Size)      <= Datain; -- ensure that data cant overwrite on program
        else
			   if Ren = '1' then
				    Dataout <= M(conv_integer(addr));
			   else
				Dataout <= (others => 'Z');
			end if;
		end if;
      end if;
  end process  RW_Proc;
     
end dpmem_arch;