library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
 GENERIC ( DATA_WIDTH :integer := 16; ADDR_WIDTH : integer := 4);
    port (
        reset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
        ALUz : in STD_LOGIC;
        addr_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);--noi voi opr2
        ir_data_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);--noi voi data out o memory
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
        --  de test
        add_ms : out std_logic_vector(1 downto 0);
        PC_inc : out STD_LOGIC;
        PC_clr : out STD_LOGIC;
        PC_ld : out STD_LOGIC;
        IR_ld : out STD_LOGIC;
        op : out STD_LOGIC_VECTOR(3 downto 0)

    );
end control_unit;

architecture behav of control_unit is
    -- controller 
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
    -- IR
    component ir
        port (
            clk : in std_logic;
            IRld : in std_logic;
            IRin : in std_logic_vector(DATA_WIDTH-1 downto 0);
            IRout : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    -- PC
    component pc 
        port (
            -- control pc
            clk : in std_logic;
            PCclr : in std_logic;
            PCinc : in std_logic;
            PCld : in std_logic;
            -- data in out of pc
            PCd_in : in std_logic_vector(7 downto 0);
            PCd_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    -- mux
    component mux 
        PORT (
            w0, w1, w2, w3: IN  std_logic_vector (DATA_WIDTH-1 downto 0);
            SEL : IN 	 std_logic_vector (1 downto 0);
            Z: OUT 	std_logic_vector (DATA_WIDTH-1 downto 0));
    END component;

    --signal  Instr_in : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IRout : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IRout_7_to_0 : std_logic_vector(7 downto 0);
    signal IRout_mux : std_logic_vector(DATA_WIDTH-1 downto 0);
    -- tin hieu cho pc va ir
    signal PCout : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal IRld :  STD_LOGIC;
    signal PCinc :  STD_LOGIC;
    signal PCclr :  STD_LOGIC;
    signal PCld :  STD_LOGIC;
    signal addr_Ms :  STD_LOGIC_VECTOR(1 downto 0);
    signal w3 : std_logic_vector(DATA_WIDTH-1 downto 0):=x"0000";
    

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
                -- control pc
                clk => clk,
                PCclr => PCclr,
                PCinc => PCinc,
                PCld => PCld,
    
                -- data in out of pc
                PCd_in => IRout_7_to_0,
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
        port 
        -- map(addr_in,IRout_mux,PCout,w3,addr_Ms,ADDR);
        map (
            w0 => addr_in,
            w1 => IRout_mux,
            w2 => PCout,
            w3 => w3,
            SEL => addr_Ms,
            Z => ADDR);
    op <= IRout(DATA_WIDTH-1 downto 12);
    IRout_7_to_0 <= IRout(7 downto 0);
    IRout_mux <= x"00" & IRout_7_to_0;
    imm <= IRout_7_to_0;
    add_ms <= addr_ms;
    PC_inc <= PCinc;
    PC_clr <= PCclr;
    PC_ld <= PCld;
    IR_ld <= IRld;

    
end behav;