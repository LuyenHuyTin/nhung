library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
 GENERIC ( DATA_WIDTH :integer := 16; ADDR_WIDTH : integer := 4);
    port (
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz : in STD_LOGIC;
        addr_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);
        ir_data_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);
        RFs : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        RFwe : out STD_LOGIC;
        OPr1a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
        OPr2e : out STD_LOGIC;
        ALUs : out STD_LOGIC_VECTOR(1 downto 0);
        ADDR : out STD_LOGIC_VECTOR(16 - 1 downto 0);
        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC;
        imm : out STD_LOGIC_VECTOR(8 - 1 downto 0);
        add_ms : out std_logic_vector(1 downto 0);
        PC_inc : out STD_LOGIC;
        PC_clr : out STD_LOGIC;
        PC_ld : out STD_LOGIC;
        IR_ld : out STD_LOGIC;
        op : out STD_LOGIC_VECTOR(3 downto 0)
    );
end control_unit;

architecture behav of control_unit is
    component controller 
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
    end component;
    
    component ir
        port (
            clk : in std_logic;
            IRld : in std_logic;
            IRin : in std_logic_vector(DATA_WIDTH-1 downto 0);
            IRout : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component pc 
        port (
            clk : in std_logic;
            PCclr : in std_logic;
            PCinc : in std_logic;
            PCld : in std_logic;
            PCd_in : in std_logic_vector(7 downto 0);
            PCd_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component mux 
        PORT (
            input1, input2, input3, input4: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
            SELECTION : IN 	 std_logic_vector (1 downto 0);
            Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0));
    END component;

    signal IRout : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IRout_to_dp : std_logic_vector(7 downto 0);
    signal IRout_mux : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal PCout : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IRld :  STD_LOGIC;
    signal PCinc :  STD_LOGIC;
    signal PCclr :  STD_LOGIC;
    signal PCld :  STD_LOGIC;
    signal addr_Ms :  STD_LOGIC_VECTOR(1 downto 0);
    signal input4 : std_logic_vector(DATA_WIDTH-1 downto 0):=x"0000";
    

begin


    uut_controller : controller
        port map (
            reset => reset,
            clk => clk,
            ALUz => ALUz,
            Instr_in => IRout,
            RFs => RFs,
            RFwa => RFwa,
            RFwe => RFwe,
            OPr1a => OPr1a,
            OPr1e => OPr1e,
            OPr2a => OPr2a,
            OPr2e => OPr2e,
            ALUs => ALUs,
            IRld => IRld,
            PCinc => PCinc,
            PCclr => PCclr,
            PCld => PCld,
            addr_Ms => addr_Ms,
            Mre => Mre,
            Mwe => Mwe
        );
    uut_pc : pc
        port map (
                clk => clk,
                PCclr => PCclr,
                PCinc => PCinc,
                PCld => PCld,
                PCd_in => IRout_to_dp,
                PCd_out => PCout
            );
    
    uut_ir: ir
        port map (
            clk => clk,
            IRld => IRld,
            IRin => ir_data_in,
            IRout => IRout
        );

    uut_mux : mux
        port map (
            input1 => addr_in,
            input2 => IRout_mux,
            input3 => PCout,
            input4 => input4,
            SELECTION => addr_Ms,
            Z => ADDR);
    op <= IRout(DATA_WIDTH-1 downto 12);
    IRout_to_dp <= IRout(7 downto 0);
    IRout_mux <= x"00" & IRout_to_dp;
    imm <= IRout_to_dp;
    add_ms <= addr_ms;
    PC_inc <= PCinc;
    PC_clr <= PCclr;
    PC_ld <= PCld;
    IR_ld <= IRld;

    
end behav;