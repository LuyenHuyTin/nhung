LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_unit IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        ADDR_WIDTH : INTEGER := 4);
    PORT (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        ALUz : IN STD_LOGIC;
        addr_in : IN STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
        ir_data_in : IN STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
        RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        RFwe : OUT STD_LOGIC;
        OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        OPr1e : OUT STD_LOGIC;
        OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        OPr2e : OUT STD_LOGIC;
        ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ADDR : OUT STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
        Mre : OUT STD_LOGIC;
        Mwe : OUT STD_LOGIC;
        imm : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
        add_ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_inc : OUT STD_LOGIC;
        PC_clr : OUT STD_LOGIC;
        PC_ld : OUT STD_LOGIC;
        IR_ld : OUT STD_LOGIC;
        op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END control_unit;

ARCHITECTURE behav OF control_unit IS
    COMPONENT controller
        PORT (
            reset : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            ALUz : IN STD_LOGIC;
            Instr_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
            RFwe : OUT STD_LOGIC;
            OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
            OPr1e : OUT STD_LOGIC;
            OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
            OPr2e : OUT STD_LOGIC;
            ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            IRld : OUT STD_LOGIC;
            PCinc : OUT STD_LOGIC;
            PCclr : OUT STD_LOGIC;
            PCld : OUT STD_LOGIC;
            addr_Ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            Mre : OUT STD_LOGIC;
            Mwe : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT ir
        PORT (
            clk : IN STD_LOGIC;
            IRld : IN STD_LOGIC;
            IRin : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            IRout : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pc
        PORT (
            clk : IN STD_LOGIC;
            PCclr : IN STD_LOGIC;
            PCinc : IN STD_LOGIC;
            PCld : IN STD_LOGIC;
            PCd_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            PCd_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux
        PORT (
            input1, input2, input3, input4 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            SELECTION : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL IRout : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL IRout_to_dp : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL IRout_mux : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL PCout : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL IRld : STD_LOGIC;
    SIGNAL PCinc : STD_LOGIC;
    SIGNAL PCclr : STD_LOGIC;
    SIGNAL PCld : STD_LOGIC;
    SIGNAL addr_Ms : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL input4 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := x"0000";
BEGIN
    uut_controller : controller
    PORT MAP(
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
    PORT MAP(
        clk => clk,
        PCclr => PCclr,
        PCinc => PCinc,
        PCld => PCld,
        PCd_in => IRout_to_dp,
        PCd_out => PCout
    );

    uut_ir : ir
    PORT MAP(
        clk => clk,
        IRld => IRld,
        IRin => ir_data_in,
        IRout => IRout
    );

    uut_mux : mux
    PORT MAP(
        input1 => addr_in,
        input2 => IRout_mux,
        input3 => PCout,
        input4 => input4,
        SELECTION => addr_Ms,
        Z => ADDR);
    op <= IRout(DATA_WIDTH - 1 DOWNTO 12);
    IRout_to_dp <= IRout(7 DOWNTO 0);
    IRout_mux <= x"00" & IRout_to_dp;
    imm <= IRout_to_dp;
    add_ms <= addr_ms;
    PC_inc <= PCinc;
    PC_clr <= PCclr;
    PC_ld <= PCld;
    IR_ld <= IRld;
END behav;