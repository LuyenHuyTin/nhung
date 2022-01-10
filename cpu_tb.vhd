library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cpu_tb is
end cpu_tb;

architecture behav of cpu_tb is

    component cpu
        port(clk : in std_logic;
            reset : in std_logic;
            address_t : out std_logic_vector(15 downto 0);
    
             imm_t : out std_logic_vector(7 downto 0);
             OPr2_t :  out std_logic_vector(15 downto 0);--noi datapath oi mux cua control
            --
             Mre_t :  out std_logic;
             Mwe_t :  out std_logic;
            --
             data_out_mem_t :out std_logic_vector(15 downto 0); -- noi voi input3 datapath va ir_in 
             data_in_mem_t :  out std_logic_vector(15 downto 0); -- tuong duong data out cua datapath
            -- 
             RFs_t : out STD_LOGIC_VECTOR(1 downto 0);
             RFwa_t : out STD_LOGIC_VECTOR(4 - 1 downto 0);
             RFwe_t : out STD_LOGIC;
            --
             OPr1a_t : out STD_LOGIC_VECTOR(4 - 1 downto 0);
             OPr1e_t : out STD_LOGIC;
             OPr2a_t : out STD_LOGIC_VECTOR(4 - 1 downto 0);
             OPr2e_t : out STD_LOGIC;
            --
             ALUs_t : out STD_LOGIC_VECTOR(1 downto 0);
             ALUz_t : out STD_LOGIC;
             --de test
             add_ms_t : out std_logic_vector(1 downto 0);
             PC_inc_t : out STD_LOGIC;
             PC_clr_t : out STD_LOGIC;
             PC_ld_t : out STD_LOGIC;
             IR_ld_t : out STD_LOGIC;
     
             op_t : out STD_LOGIC_VECTOR(3 downto 0)
        );
       
    
    end component;

    constant clk_period : time := 20 ns;

    signal clk : std_logic := '1';
    signal reset : std_logic := '1';
    --
    

    --
    signal address_t : std_logic_vector(15 downto 0);
    
    signal imm_t :  std_logic_vector(7 downto 0);
    signal OPr2_t :   std_logic_vector(15 downto 0);--noi datapath oi mux cua control
--
    signal Mre_t :  std_logic;
    signal Mwe_t :  std_logic;
--
    signal data_out_mem_t : std_logic_vector(15 downto 0); -- noi voi input3 datapath va ir_in 
    signal data_in_mem_t :   std_logic_vector(15 downto 0); -- tuong duong data out cua datapath

-- 
    signal RFs_t :  STD_LOGIC_VECTOR(1 downto 0);
    signal RFwa_t :  STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal RFwe_t :  STD_LOGIC;
--
    signal OPr1a_t : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal OPr1e_t :  STD_LOGIC;
    signal OPr2a_t :  STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal OPr2e_t :  STD_LOGIC;
--
    signal ALUs_t :  STD_LOGIC_VECTOR(1 downto 0);
    signal ALUz_t :  STD_LOGIC;
    --
    signal  add_ms_t :  std_logic_vector(1 downto 0);
     signal  PC_inc_t :  STD_LOGIC;
     signal  PC_clr_t :  STD_LOGIC;
     signal  PC_ld_t :  STD_LOGIC;
     signal  IR_ld_t :  STD_LOGIC;

     signal  op_t :  STD_LOGIC_VECTOR(3 downto 0);

begin

    clk <= not clk after clk_period / 2;

    DUT : cpu
    port map (clk,reset,address_t,imm_t,OPr2_t,
    Mre_t,Mwe_t,data_out_mem_t,data_in_mem_t,RFs_t,RFwa_t,
    RFwe_t,OPr1a_t,OPr1e_t,OPr2a_t,OPr2e_t,ALUs_t,ALUz_t,add_ms_t,
    PC_inc_t,PC_clr_t,PC_ld_t,IR_ld_t,op_t);

    SEQUENCER_PROC : process
    begin
        reset <= '1';
        wait for clk_period * 2;

        reset <= '0';

        wait for clk_period * 30;

    end process;

end behav;