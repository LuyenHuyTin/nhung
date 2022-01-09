library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity
ALU is
GENERIC(DATA_WIDTH : integer := 16); -- khai bao bien 

    Port ( OPr1 : in STD_LOGIC_VECTOR
	 (DATA_WIDTH - 1 downto 0);
          OPr2 : in STD_LOGIC_VECTOR
	 (DATA_WIDTH - 1 downto 0);
           ALUs : in STD_LOGIC_VECTOR (1
downto 0);
           ALUr : out STD_LOGIC_VECTOR
	  (DATA_WIDTH - 1 downto 0);
           ALUz : out STD_LOGIC
        );
end ALU;
architecture
ALU of ALU is
signal
result : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
begin
    process(ALUs, Opr1, Opr2) -- process se hoat dong khi 1 trong 3 cong dau vao thay doi
    begin
        case(ALUs) is
            when "00" =>
                result <= OPr1 + OPr2;
            when "01" => 
                result <= OPr1 - OPr2;
            when "10" =>
                result <= OPr1 or OPr2;
            when "11" =>
                result <= OPr1 and OPr2;
          
            when others => 
                result <= (others =>
'1');
        end case;
    end process;
    ALUr <= result;
    ALUz <= '1' when OPr1 = x"0000"
	 else '0';
end
ALU;

