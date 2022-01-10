library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    Generic (
            DATA_WIDTH : integer   := 16; 
            ADDR_WIDTH : integer   := 4 );
    port(
        clk : in std_logic;
        reset : in std_logic;
        address_t : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        imm_t : out std_logic_vector(7 downto 0);
        OPr2_t :  out std_logic_vector(DATA_WIDTH - 1 downto 0);
        Mre_t :  out std_logic;
        Mwe_t :  out std_logic;
        data_out_mem_t :out std_logic_vector(DATA_WIDTH - 1 downto 0); 
        data_in_mem_t :  out std_logic_vector(DATA_WIDTH - 1 downto 0); 
        RFs_t : out STD_LOGIC_VECTOR(1 downto 0);
        RFwa_t : out STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
        RFwe_t : out STD_LOGIC;
        OPr1a_t : out STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
        OPr1e_t : out STD_LOGIC;
        OPr2a_t : out STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
        OPr2e_t : out STD_LOGIC;
        ALUs_t : out STD_LOGIC_VECTOR(1 downto 0);
        ALUz_t : out STD_LOGIC;
        add_ms_t : out std_logic_vector(1 downto 0);
        PC_inc_t : out STD_LOGIC;
        PC_clr_t : out STD_LOGIC;
        PC_ld_t : out STD_LOGIC;
        IR_ld_t : out STD_LOGIC;
        op_t : out STD_LOGIC_VECTOR(ADDR_WIDTH -1 downto 0)
    );
   

end cpu;

architecture behav of cpu is
    --control unit
    component control_unit 
        port (
          reset : in STD_LOGIC; 
          clk : in STD_LOGIC; 
          ALUz : in STD_LOGIC;
          addr_in : in STD_LOGIC_VECTOR(DATA_WIDTH- 1 downto 0);
          ir_data_in : in STD_LOGIC_VECTOR(DATA_WIDTH- 1 downto 0);
          RFs : out STD_LOGIC_VECTOR(1 downto 0);
          RFwa : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
          RFwe : out STD_LOGIC;
          OPr1a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
          OPr1e : out STD_LOGIC;
          OPr2a : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
          OPr2e : out STD_LOGIC;
          ALUs : out STD_LOGIC_VECTOR(1 downto 0);
          ADDR : out STD_LOGIC_VECTOR(DATA_WIDTH- 1 downto 0);
          Mre : out STD_LOGIC;
          Mwe : out STD_LOGIC;
          imm : out STD_LOGIC_VECTOR(8 - 1 downto 0);
          add_ms : out std_logic_vector(1 downto 0);
          PC_inc : out STD_LOGIC;
          PC_clr : out STD_LOGIC;
          PC_ld : out STD_LOGIC;
          IR_ld : out STD_LOGIC;
          op : out STD_LOGIC_VECTOR(ADDR_WIDTH -1 downto 0)
        );
       end component;

       component datapath 
         port ( 
            rst     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            imm     : in std_logic_vector(7 downto 0); 
            input3      : in std_logic_vector(DATA_WIDTH -1 downto 0);
            RFs : in std_logic_vector(1 downto 0);
            ALUs : in std_logic_vector(1 downto 0);
            ALUz : out std_logic;
            RFwa : in std_logic_vector(ADDR_WIDTH -1 downto 0);
            RFwe : in std_logic;
            OPr1a : in std_logic_vector(ADDR_WIDTH -1 downto 0);
            OPr1e : in std_logic;
            OPr2a : in std_logic_vector(ADDR_WIDTH -1 downto 0);
            OPr2e : in std_logic;
            add_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
            data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0));
      end component;

      -- memory
      component memory 
        port (
          Clk: in  std_logic;       
          Reset : in  std_logic; 
          addr: in  std_logic_vector(DATA_WIDTH -1 downto 0);  
          Wen : in  std_logic;    
          Datain: in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0'); 
          Ren : in  std_logic;    
          Dataout: out std_logic_vector(DATA_WIDTH -1 downto 0)  
          );
      end component;

    signal address : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal imm :  std_logic_vector(7 downto 0);
    signal OPr2 :   std_logic_vector(DATA_WIDTH - 1 downto 0);--noi datapath oi mux cua control
    signal Mre :  std_logic;
    signal Mwe :  std_logic;
    signal data_out_mem : std_logic_vector(DATA_WIDTH - 1 downto 0); -- noi voi input3 datapath va ir_in 
    signal data_in_mem :  std_logic_vector(DATA_WIDTH - 1 downto 0); -- tuong duong data out cua datapath
    signal RFs :  STD_LOGIC_VECTOR(1 downto 0);
    signal RFwa :  STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
    signal RFwe :  STD_LOGIC;
    signal OPr1a :  STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
    signal OPr1e :  STD_LOGIC;
    signal OPr2a :  STD_LOGIC_VECTOR(ADDR_WIDTH- 1 downto 0);
    signal OPr2e :  STD_LOGIC;
    signal ALUs :  STD_LOGIC_VECTOR(1 downto 0);
    signal ALUz : STD_LOGIC;
    signal  add_ms :  std_logic_vector(1 downto 0);
    signal  PC_inc :  STD_LOGIC;
    signal  PC_clr :  STD_LOGIC;
    signal  PC_ld :  STD_LOGIC;
    signal  IR_ld :  STD_LOGIC;
    signal  op :  STD_LOGIC_VECTOR(ADDR_WIDTH -1 downto 0);
     
begin
    ctrl: control_unit
      port map (
        reset=>reset,
        clk=>clk,
        ALUz=>ALUz,
        addr_in=>OPr2,
        ir_data_in=>data_out_mem,
        RFs=>RFs,
        RFwa=>RFwa,
        RFwe=>RFwe,
        OPr1a=>OPr1a,
        OPr1e=>OPr1e,
        OPr2a=>OPr2a,
        OPr2e=>OPr2e,
        ALUs=>ALUs,
        ADDR=>address,
        Mre=>Mre,
        Mwe=>Mwe,
        imm=>imm,
        add_ms=>add_ms,
        PC_inc=>PC_inc,
        PC_clr=>PC_clr,
        PC_ld=>PC_ld,
        IR_ld=>IR_ld,
        op=>op);

    data:datapath
      port  map ( 
          rst =>reset,
          clk =>clk,
          imm =>imm,
          input3 =>data_out_mem,
          RFs =>RFs,
          ALUs =>ALUs,
          ALUz =>ALUz,
          RFwa =>RFwa,
          RFwe =>RFwe,
          OPr1a =>OPr1a,
          OPr1e =>OPr1e,
          OPr2a =>OPr2a,
          OPr2e =>OPr2e,
          add_out =>OPr2,
          data_out =>data_in_mem
        );

    mem :memory
      port map  (
          Clk => Clk,
          Reset => Reset,
          addr => address,
          Wen => Mwe,
          Datain => data_in_mem,
          Ren => Mre,
          Dataout => data_out_mem);


    address_t <= address ;
    Mre_t <= Mre;
    Mwe_t <= Mwe;
    data_out_mem_t <= data_out_mem;
    data_in_mem_t <= data_in_mem;

    --
    imm_t <= imm ;
    OPr2_t <= OPr2;--noi datapath oi mux cua control
   --
    Mre_t <= Mre ;
    Mwe_t <= Mwe ;
   --
    data_out_mem_t <= data_out_mem; -- noi voi input3 datapath va ir_in 
    data_in_mem_t <= data_in_mem; -- tuong duong data out cua datapath
   -- 
    RFs_t <= RFs;
    RFwa_t <= RFwa;
    RFwe_t <= RFwe;
   --
    OPr1a_t <= OPr1a;
    OPr1e_t <= OPr1e;
    OPr2a_t <= OPr2a;
    OPr2e_t <= OPr2e;
   --
    ALUs_t <= ALUs;
    ALUz_t <= ALUz;
    --
    add_ms_t <=add_ms;
    PC_inc_t <= PC_inc;
    PC_clr_t <=PC_clr;
    PC_ld_t <=PC_ld;
    IR_ld_t <=IR_ld;

    op_t <= op;

end behav;