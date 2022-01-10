

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is

	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
    port(
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz, ALUeq, ALUgt : in STD_LOGIC;
        -- RF (opr2)
        data_in : in STD_LOGIC_VECTOR(15 downto 0);
        -- mem to ir
        data_in_ir : in STD_LOGIC_VECTOR(15 downto 0);
        -- ir => mux
        Instr_out : out STD_LOGIC_VECTOR(15 downto 0);
        -- controller => rf 
        RFs : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa : out STD_LOGIC_VECTOR(3 downto 0);
        RFwe : out STD_LOGIC;
        OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr2e : out STD_LOGIC;
        ALUs : out STD_LOGIC_VECTOR(1 downto 0);
        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC;

        -- adddresss id => mem 
        ADDR : out STD_LOGIC_VECTOR(15 downto 0)
        );
end control_unit;

architecture Behavioral of control_unit is
        SIGNAL Instr_in_inter : STD_LOGIC_VECTOR(15 downto 0);
        SIGNAL ADDR_mux : STD_LOGIC_VECTOR(15 downto 0);
        SIGNAL pc_out : STD_LOGIC_VECTOR(15 downto 0);
        SIGNAL IRld : STD_LOGIC;
        SIGNAL PCincr : STD_LOGIC;
        SIGNAL PCclr : STD_LOGIC;
        SIGNAL PCld : STD_LOGIC;
        SIGNAL Addr_sel : STD_LOGIC_VECTOR(1 downto 0);

        component controller_tt --datapath registor
            port(reset : in STD_LOGIC; 
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

        end component;


        component Mux_tt
            port(data_in0, data_in1, data_in2 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
                sel : in STD_LOGIC_VECTOR (1 downto 0);
                data_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
            );
        end component;

        component PC_tt --datapath component
            Port ( clk : in STD_LOGIC;
            PCclr : in STD_LOGIC;
            PCincr : in STD_LOGIC;
            PCld : in STD_LOGIC;
            PC_in : in STD_LOGIC_VECTOR (15 downto 0);
            PC_out : out STD_LOGIC_VECTOR (15 downto 0));
        end component;

        component IR_tt 
            Port(  clk : in STD_LOGIC;
                IR_in : in STD_LOGIC_VECTOR (15 downto 0);
                IRld : in STD_LOGIC;
                IR_out : out STD_LOGIC_VECTOR (15 downto 0));
        end component;

begin

    uut_controller: controller_tt port map (     
        reset  => reset, 
        clk  => clk, 
        ALUz  => ALUz,
        ALUeq  => ALUeq,
        ALUgt  => ALUgt,
        Instr_in =>  Instr_in_inter,
        RFs =>  RFs,
        RFwa  => RFwa,
        RFwe  => RFwe,
        OPr1a => OPr1a,
        OPr1e =>  OPr1e,
        OPr2a =>  OPr2a,
        OPr2e  => OPr2e,
        ALUs  => ALUs,
        IRld  => IRld,
        PCincr  => PCincr,
        PCclr =>  PCclr,
        PCld =>  PCld,
        Addr_sel =>  Addr_sel,
        Mre =>  Mre,
        Mwe =>  Mwe
      );

    uut_mux : Mux_tt PORT MAP(
        data_in0      => data_in,
        data_in1   => Instr_in_inter,
        data_in2     => pc_out,
        sel       => Addr_sel,
        data_out    => ADDR_mux
    );

    uut_pc: PC_tt port map (     
        clk => clk,
        PCclr => PCclr,
        PCincr => PCincr,
        PCld => PCld,
        PC_in => Instr_in_inter,
        PC_out => PC_out
        );
    
    uut_ir: IR_tt  port map (     
        clk => clk,
        IR_in => data_in_ir,
        IRld => IRld,
        IR_out => Instr_in_inter
        );
    
    ADDR <= ADDR_mux;
    Instr_out <= Instr_in_inter;
    
END Behavioral;

