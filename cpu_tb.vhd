LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY cpu_tb IS
END cpu_tb;

ARCHITECTURE behav OF cpu_tb IS

    COMPONENT cpu
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            imm : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            OPr2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Mre : OUT STD_LOGIC;
            Mwe : OUT STD_LOGIC;
            data_out_mem : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_in_mem : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RFwa : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            RFwe : OUT STD_LOGIC;
            OPr1a : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            OPr1e : OUT STD_LOGIC;
            OPr2a : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            OPr2e : OUT STD_LOGIC;
            ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUz : OUT STD_LOGIC;
            add_ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC_inc : OUT STD_LOGIC;
            PC_clr : OUT STD_LOGIC;
            PC_ld : OUT STD_LOGIC;
            IR_ld : OUT STD_LOGIC;
            op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk_test : STD_LOGIC := '1';
    SIGNAL reset_test : STD_LOGIC := '1';
    SIGNAL address_test : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL imm_test : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL OPr2_test : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Mre_test : STD_LOGIC;
    SIGNAL Mwe_test : STD_LOGIC;
    SIGNAL data_out_mem_test : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_in_mem_test : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RFs_test : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL RFwa_test : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL RFwe_test : STD_LOGIC;
    SIGNAL OPr1a_test : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL OPr1e_test : STD_LOGIC;
    SIGNAL OPr2a_test : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL OPr2e_test : STD_LOGIC;
    SIGNAL ALUs_test : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL ALUz_test : STD_LOGIC;
    SIGNAL add_ms_test : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PC_inc_test : STD_LOGIC;
    SIGNAL PC_clr_test : STD_LOGIC;
    SIGNAL PC_ld_test : STD_LOGIC;
    SIGNAL IR_ld_test : STD_LOGIC;
    SIGNAL op_test : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    clk_test <= NOT clk_test AFTER 20 ns;

    DUT : cpu
    PORT MAP(
        clk => clk_test,
        reset => reset_test,
        address => address_test,
        imm => imm_test,
        OPr2 => OPr2_test,
        Mre => Mre_test,
        Mwe => Mwe_test,
        data_out_mem => data_out_mem_test,
        data_in_mem => data_in_mem_test,
        RFs => RFs_test,
        RFwa => RFwa_test,
        RFwe => RFwe_test,
        OPr1a => OPr1a_test,
        OPr1e => OPr1e_test,
        OPr2a => OPr2a_test,
        OPr2e => OPr2e_test,
        ALUs => ALUs_test,
        ALUz => ALUz_test,
        add_ms => add_ms_test,
        PC_inc => PC_inc_test,
        PC_clr => PC_clr_test,
        PC_ld => PC_ld_test,
        IR_ld => IR_ld_test,
        op => op_test);

    SEQUENCER_PROC : PROCESS
    BEGIN
        reset_test <= '0';
        WAIT FOR 50ns;
    END PROCESS;

END behav;