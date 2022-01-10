
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Datapath is

	GENERIC(DATA_WIDTH: integer := 16; ADDR_WIDTH: integer := 16);
    Port(  clk : in STD_LOGIC;
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
end Datapath;

architecture Behavioral of Datapath is

        SIGNAL data_in0_alur: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        SIGNAL OPr2: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        SIGNAL OPr1: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        SIGNAL RFin : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);

        component registor_tt --datapath registor
        Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           RFin : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           RFwa : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           RFwe : in STD_LOGIC;
           OPr1a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           OPr1e : in STD_LOGIC;
           OPr2a : in STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);
           OPr2e : in STD_LOGIC;
           OPr1 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           OPr2 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));

        end component;


        component Mux_tt
        port(data_in0, data_in1, data_in2 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            sel : in STD_LOGIC_VECTOR (1 downto 0);
            data_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
        );
        end component;

        component ALU_tt --datapath component
        Port ( OPr1 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            OPr2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            ALUs : in STD_LOGIC_VECTOR (1 downto 0);
            ALUr : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
            ALUz : out STD_LOGIC );
        end component;



begin

    uut_alu: ALU_tt  PORT MAP (
        OPr1 => OPr1,
        OPr2 => OPr2,
        ALUs => ALUs,
        ALUz => ALUz,
        ALUr => data_in0_alur

    );

    uut_mux : Mux_tt PORT MAP(
        data_in0      => data_in0_alur,
        data_in1   => data_in1,
        data_in2     => data_in2,
        sel       => RFs,
        data_out    => RFin
    );

    uut_registor: registor_tt PORT MAP(
        reset => reset,
        clk =>   clk,
        RFin =>  RFin,
        RFwa =>  RFwa,
        RFwe =>  RFwe,
        OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
        OPr1 =>  OPr1,
        OPr2 =>  OPr2);
    
    data_out1 <= OPr1;
    data_out2 <= OPr2;
    
END Behavioral;

