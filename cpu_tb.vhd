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
            address_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            imm_t : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            OPr2_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            Mre_t : OUT STD_LOGIC;
            Mwe_t : OUT STD_LOGIC;

            data_out_mem_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_in_mem_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

            RFs_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            RFwa_t : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            RFwe_t : OUT STD_LOGIC;

            OPr1a_t : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            OPr1e_t : OUT STD_LOGIC;
            OPr2a_t : OUT STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
            OPr2e_t : OUT STD_LOGIC;

            ALUs_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUz_t : OUT STD_LOGIC;

            add_ms_t : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC_inc_t : OUT STD_LOGIC;
            PC_clr_t : OUT STD_LOGIC;
            PC_ld_t : OUT STD_LOGIC;
            IR_ld_t : OUT STD_LOGIC;

            op_t : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT clk_period : TIME := 20 ns;

    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL address_t : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL imm_t : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL OPr2_t : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL Mre_t : STD_LOGIC;
    SIGNAL Mwe_t : STD_LOGIC;

    SIGNAL data_out_mem_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_in_mem_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RFs_t : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL RFwa_t : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL RFwe_t : STD_LOGIC;

    SIGNAL OPr1a_t : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL OPr1e_t : STD_LOGIC;
    SIGNAL OPr2a_t : STD_LOGIC_VECTOR(4 - 1 DOWNTO 0);
    SIGNAL OPr2e_t : STD_LOGIC;

    SIGNAL ALUs_t : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL ALUz_t : STD_LOGIC;

    SIGNAL add_ms_t : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PC_inc_t : STD_LOGIC;
    SIGNAL PC_clr_t : STD_LOGIC;
    SIGNAL PC_ld_t : STD_LOGIC;
    SIGNAL IR_ld_t : STD_LOGIC;

    SIGNAL op_t : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    clk <= NOT clk AFTER clk_period / 2;

    DUT : cpu
    PORT MAP(
        clk, reset, address_t, imm_t, OPr2_t,
        Mre_t, Mwe_t, data_out_mem_t, data_in_mem_t, RFs_t, RFwa_t,
        RFwe_t, OPr1a_t, OPr1e_t, OPr2a_t, OPr2e_t, ALUs_t, ALUz_t, add_ms_t,
        PC_inc_t, PC_clr_t, PC_ld_t, IR_ld_t, op_t);

    SEQUENCER_PROC : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR clk_period * 2;

        reset <= '0';

        WAIT FOR clk_period * 30;

    END PROCESS;

END behav;