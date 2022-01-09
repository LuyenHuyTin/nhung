


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.STD_LOGIC_ARITH.all;


entity controller is
    port(
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz, ALUeq, ALUgt : in STD_LOGIC;
        Instr_in : in STD_LOGIC_VECTOR(15 downto 0);
        RFs : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa : out STD_LOGIC_VECTOR(3 downto 0);
        RFwe : out STD_LOGIC;
        OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr2e : out STD_LOGIC;
        ALUs : out STD_LOGIC_VECTOR(1 downto 0);
        IRld : out STD_LOGIC;
        PCincr : out STD_LOGIC;
        PCclr : out STD_LOGIC;
        PCld : out STD_LOGIC;
        Addr_sel : out STD_LOGIC_VECTOR(1 downto 0);
        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC 
        );
end controller;

architecture Behavioral of controller is
    type state_type is (RESET_S, FETCH, FETCHa, FETCHb, DECODE, MOV1, MOV1a, MOV1b, MOV2, MOV2a, MOV2b,
                    MOV3, MOV3a, MOV3b, MOV4, MOV4a, ADD, ADDa, ADDb, SUB, SUBa, SUBb, RSB, RSBa, RSBb,
                     XOR_S, XOR_Sa, XOR_Sb, OR_S, OR_Sa, OR_Sb, AND_S, AND_Sa, AND_Sb, JZ, JZa, JZb, JEQ,JEQa, JEQb,
                     JGT,JGTa, JGTb, JLT, JLTa, JLTb, CLR, CLRa, CLRb, PRS, PRSa, PRSb, NOP);
    signal state : state_type;
    signal rn, rm, OPCODE : STD_LOGIC_VECTOR(3 downto 0);
begin
    rn <= Instr_in(11 downto 8);
    rm <= Instr_in(7 downto 4);
    OPCODE <= INSTR_in(15 downto 12);
    process(clk, reset, OPCODE)
    begin
        if reset = '1' then

            --OP2 <= (others => '0');
            state <= RESET_S;
        elsif clk'event and clk = '1' then
            case state is
                when RESET_S =>
                            state <= FETCH;
                when FETCH =>
                         
                            state <= FETCHa;
                when FETCHa =>
                             state <= FETCHb;
                when FETCHb =>   
                            state <= DECODE;
                when DECODE =>
                    case OPCODE is
                        when "0000" => state <= MOV1;
                        when "0001" => state <= MOV2;
                        when "0010" => state <= MOV3;
                        when "0011" => state <= MOV4;
                        when "0100" => state <= ADD;
                        when "0101" => state <= SUB;
                        when "0110" => state <= JZ;
                        when others => state <= NOP;
                    end case;
                when MOV1 => 
                         
                            state <= MOV1a;
                when MOV1a =>

                            state <= FETCH;
                when MOV2 => 

                            state <= MOV2a;
                when MOV2a =>

                            state <= FETCH;
                when MOV3 =>  

                            state <= MOV3a;
                when MOV3a =>
                            state <= FETCH;
                when MOV4 => 

                            state <= FETCH;
                when ADD => 

                            state <= ADDa;
                when ADDa =>

                            state <= ADDb;
                when ADDb =>
                             state <= FETCH;
                when SUB => 
                         
                            state <= SUBa;
                when SUBa =>
                            state <= FETCH;

                when JZ =>  
                            state <= JZa;
                when JZa =>
                            state <= FETCH;

                when others => state <= FETCH;
            end case;
        end if;
    end process;


 PCClr <= '1' WHEN (State =  RESET_S) ELSE '0';
 PCincr <= '1' WHEN (State = Fetchb) else '0';
 PCLd <= ALUz WHEN (State = JZa) ELSE '0';
 IRld <= '1' WHEN (state = Fetchb) ELSE '0';
 WITH State Select Addr_sel <= "10" WHEN Fetch,"01" WHEN MOV1|MOV2a,"00" WHEN MOV3a,"11" WHEN others ;
 WITH State Select Mre <= '1' WHEN Fetch|MOV1, '0' WHEN others ;
 WITH State Select Mwe <= '1' WHEN MOV2a|MOV3a, '0' WHEN others ;
 WITH State Select  RFs <= "10" WHEN MOV1a,"01" WHEN MOv4, "00" WHEN ADDb|SUBa, "11" WHEN others;
WITH State Select   RFwe <= '1' WHEN MOV1a|MOv4|ADDb|SUBa, '0' WHEN Others;
WITH State Select   RFwa <= rn WHEN MOV1a|MOv4|ADDb|SUBa, "0000" WHEN Others;
WITH State Select   OPr1e <= '1' WHEN MOV2|MOV3|ADD|SUB|JZ,'0' WHEN OTHERS;
WITH State Select   OPr1a <= rn WHEN MOV2|MOV3|ADD|SUB|JZ,"0000" WHEN OTHERS;
WITH State Select   OPr2e <= '1' WHEN MOV3|ADD|SUB,'0' WHEN OTHERS;
WITH State Select   OPr2a <= rm WHEN MOV3|ADD|SUB,"0000" WHEN OTHERS;
WITH State Select   ALUs <= "00" WHEN ADDa|ADDb,"01" WHEN SUB|SUBa,"10" WHEN OR_S,"11" WHEN others;

end Behavioral;

