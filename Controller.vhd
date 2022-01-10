
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    generic(
        DATA_WIDTH :integer := 16;
        ADDR_WIDTH : integer :=4
    );

    port(
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz : in STD_LOGIC;
        Instr_in : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        RFs : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        RFwe : out STD_LOGIC;
        OPr1a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        OPr2e : out STD_LOGIC;
        ALUs : out STD_LOGIC_VECTOR(1 downto 0);
        IRld : out STD_LOGIC;
        PCinc : out STD_LOGIC;
        PCclr : out STD_LOGIC;
        PCld : out STD_LOGIC;
        addr_Ms : out STD_LOGIC_VECTOR(1 downto 0);
        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC 

    );
end controller;

architecture controller of controller is
    type state_type is (RESET_S, FETCH, Load_IR, Increase_PC, DECODE, MOV1, MOV1a, MOV2, MOV2a,
                    MOV3, MOV3a, MOV4, MOV4a, ADD, ADDa, SUB, SUBa,
                      OR_S, OR_Sa, AND_S, AND_Sa, JPZ, JPZa,NOPE);
    signal state : state_type;
    signal rn, rm, OPCODE : STD_LOGIC_VECTOR(3 downto 0);
begin
    rn <= Instr_in(11 downto 8);
    rm <= Instr_in(7 downto 4);
    OPCODE <= INSTR_in(15 downto 12);
    
    NSL:process(clk, reset, OPCODE)
    begin
        if reset = '1' then
            state <= RESET_S;
        elsif clk'event and clk = '1' then
            case state is
                when RESET_S =>
                            state <= FETCH;
                when FETCH =>
                            state <= Load_IR;
                when Load_IR =>
                             state <= Increase_PC;
                when Increase_PC =>  
                            state <= DECODE;
                when DECODE =>
                    case OPCODE is
                        when "0000"=>
                            state <= MOV1;
                        when "0001"=> 
                            state <= MOV2;
                        when "0010" => 
                            state <= MOV3;
                        when  "0011"=> 
                            state <= MOV4;
                        when "0100"=> 
                            state <= ADD;
                        when "0101" => 
                            state <= SUB;
                        when "0110"=> 
                            state <= JPZ;
                        when "0111"=>
                             state <= OR_S;
                        when "1000"=> 
                            state <= AND_S;
                        --when "1001"=>
                        --     state <= JMP;
                        when others => state <= NOPE;
                    end case;
                when MOV1 => -- RF[rn] = M[dir]
                         
                            state <= MOV1a;
                when MOV1a =>

                            state <= FETCH;
                when MOV2 =>  -- M[dir] = RF[rn]

                            state <= MOV2a;
                when MOV2a =>

                            state <= FETCH;
                when MOV3 => --M[rn] <= RF[rm]

                            state <= MOV3a;
                when MOV3a =>
                            state <= FETCH;
                when MOV4 => -- RF[rn] = imm

                            state <= FETCH;
                when ADD => -- RF[rn] = RF[rn] + RF[rm]

                            state <= ADDa;
                when ADDa =>

                            state <= FETCH;
                when SUB => -- RF[rn] = RF[rn] – RF[rm]
                         
                            state <= SUBa;
                when SUBa =>
                            state <= FETCH;

                when JPZ =>  
                            state <= JPZa;
                when JPZa =>
                            state <= FETCH;
                when OR_S => -- RF[rn] = RF[rn] or RF[rm]
                 
                        state <= OR_Sa;

                when OR_Sa =>
                        state <= FETCH;

                when AND_S => -- RF[rn] = RF[rn] and RF[rm]
                         
                        state <= AND_Sa;
                when AND_Sa =>
                        state <= FETCH;

                when others => State <= FETCH;
            end case;
        end if;
    end process;
    -- -- lenh cho PC
    PCClr <= '1' WHEN (State =  RESET_S) ELSE '0';
    PCinc <= '1' WHEN (State = Increase_PC) else '0';
    PCLd <= ALUz WHEN (State = JPZa) ELSE '0';
    -- lenh cho IR
    IRld <= '1' WHEN (state = Load_IR) ELSE '0';
    -- Address slect
    WITH State Select 
        addr_Ms <= "10" WHEN Fetch,
                "01" WHEN MOV1|MOV2a,
                    "00" WHEN MOV3a,
                    "11" WHEN others ;
    WITH State Select 
        Mre <= '1' WHEN Fetch|MOV1,
                '0' WHEN others ;
    WITH State Select 
        Mwe <= '1' WHEN MOV2a|MOV3a,
                '0' WHEN others ;
    -- Write RF
    WITH State Select  
        RFs <= "10" WHEN MOV1a,
                "01" WHEN MOv4,
                "00" WHEN ADDa|SUBa|OR_S,
                "11" WHEN others;
    WITH State Select   
        RFwe <= '1' WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
                '0' WHEN Others;
    WITH State Select   
        RFwa <= rn WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
                "0000" WHEN Others;
    WITH State Select   
        OPr1e <= '1' WHEN MOV2|MOV3|ADD|SUB|JPZ|OR_S|AND_S,
                '0' WHEN OTHERS;
    WITH State Select   
        OPr1a <= rn WHEN MOV2|MOV3|ADD|SUB|JPZ|OR_S|AND_S,
                "0000" WHEN OTHERS;
    WITH State Select   
        OPr2e <= '1' WHEN MOV3|ADD|SUB|OR_S|AND_S,
                '0'WHEN OTHERS;
    WITH State Select   
        OPr2a <= rm WHEN MOV3|ADD|SUB|OR_S|AND_S,
                "0000" WHEN OTHERS;
    WITH State Select   
        ALUs <= "00" WHEN ADD|ADDa,
                "01" WHEN SUB|SUBa,
                "10" WHEN OR_S,
                "11" WHEN others;

end controller;

