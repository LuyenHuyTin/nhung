----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2022 08:31:52 PM
-- Design Name: 
-- Module Name: instruction_register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_register is
    Port(   clk : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR (15 downto 0);
           IRld : in STD_LOGIC;
           IR_out : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_register;

architecture Behavioral of instruction_register is

begin
   process(clk)
   begin
       if clk'event and clk = '1' then
           if IRld = '1' then
               IR_out <= IR_in;
           end if;
       end if;
   end process;

end Behavioral;

