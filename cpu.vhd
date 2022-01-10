
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Cpu is

	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
    Port(  clk : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            I_int: in STD_LOGIC;
            data_in_from_mem : std_logic_vector(15 downto 0);
            -- new memory interface
            data_out : std_logic_vector(15 downto 0);
            addr_out : std_logic_vector(15 downto 0)
            );
end Cpu;

architecture Behavioral of Cpu is

         SIGNAL ALUz, ALUeq, ALUgt :STD_LOGIC;
         SIGNAL Instr_in :STD_LOGIC_VECTOR(15 downto 0);
         SIGNAL RFs : STD_LOGIC_VECTOR(1 downto 0);
         SIGNAL RFwa : STD_LOGIC_VECTOR(3 downto 0);
         SIGNAL RFwe : STD_LOGIC;
         SIGNAL OPr1a : STD_LOGIC_VECTOR(3 downto 0);
         SIGNAL OPr1e : STD_LOGIC;
         SIGNAL OPr2a : STD_LOGIC_VECTOR(3 downto 0);
         SIGNAL OPr2e : STD_LOGIC;
         SIGNAL ALUs : STD_LOGIC_VECTOR(1 downto 0);
         SIGNAL IRld : STD_LOGIC;
         SIGNAL PCincr : STD_LOGIC;
         SIGNAL PCclr : STD_LOGIC;
         SIGNAL PCld : STD_LOGIC;
         SIGNAL Addr_sel : STD_LOGIC_VECTOR(1 downto 0);
         SIGNAL Mre : STD_LOGIC;
         SIGNAL Mwe : STD_LOGIC;
         SIGNAL OPR2 : STD_LOGIC_VECTOR (15 downto 0));

        component datapath_tt --datapath registor
            Port(clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               RFs : in STD_LOGIC_VECTOR (1 downto 0);
               data_in1: in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
               data_in2: in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
               RFwa : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
               RFwe : in STD_LOGIC;
               OPr1a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
               OPr1e : in STD_LOGIC;
               OPr2a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
               OPr2e : in STD_LOGIC;
               ALUs : in STD_LOGIC_VECTOR (1 downto 0);
               ALUz : out STD_LOGIC;
               data_out1 : out STD_LOGIC_VECTOR (15 downto 0);
               data_out2 : out STD_LOGIC_VECTOR (15 downto 0));

        end component;


        component control_unit
            port(reset : in STD_LOGIC; 
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
        end component;



begin

    uut_cu: control_unit  port map (
         reset => reset,
         clk => clk,
         ALUz => ALUz,
         ALUeq => ALUeq,
         ALUgt => ALUgt,
         -- RF (opr2)
         data_in => OPR2,
         -- mem to ir
         data_in_ir => data_in_from_mem,
         -- ir => mux
         Instr_out => Instr_in,
         -- controller => rf 
         RFs => RFs,
         RFwa => RFwa,
         RFwe => RFwe,
         OPr1a => OPr1a,
         OPr1e => OPr1e,
         OPr2a => OPr2a,
         OPr2e => OPr2e,
         ALUs => ALUs,
         Mre => Mre,
         Mwe => Mwe,
         ADDR => ADDR);

    uut_dp : datapath_tt Port map(
         clk => clk,
         reset => reset,
         RFs => RFs,
         data_in1 => data_in1,
         data_in2 => data_in2,
         RFwa => RFwa,
         RFwe => RFwe,
         OPr1a => OPr1a,
         OPr1e => OPr1e,
         OPr2a => OPr2a,
         OPr2e => OPr2e,
         ALUs => ALUs,
         ALUz => ALUz,
         data_out1 => data_out1,
         data_out2 => OPR2);

END Behavioral;

