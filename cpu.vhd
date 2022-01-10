library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port(
        clk : in std_logic;
        reset : in std_logic;

        address_t : out std_logic_vector(15 downto 0);

        imm_t : out std_logic_vector(7 downto 0);
        OPr2_t :  out std_logic_vector(15 downto 0);--noi datapath oi mux cua control
        --
         Mre_t :  out std_logic;
         Mwe_t :  out std_logic;
        --
         data_out_mem_t :out std_logic_vector(15 downto 0); -- noi voi w2 datapath va ir_in 
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
        
         --  de test
        add_ms_t : out std_logic_vector(1 downto 0);
        PC_inc_t : out STD_LOGIC;
        PC_clr_t : out STD_LOGIC;
        PC_ld_t : out STD_LOGIC;
        IR_ld_t : out STD_LOGIC;

        op_t : out STD_LOGIC_VECTOR(3 downto 0)
    );
   

end cpu;

architecture behav of cpu is
    --control unit
    component control_unit 
        GENERIC ( ADDR_WIDTH : integer := 4);
           port (
               reset : in STD_LOGIC; 
               clk : in STD_LOGIC; 
               ALUz : in STD_LOGIC;
       
               addr_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);--noi voi opr2
       
               ir_data_in : in STD_LOGIC_VECTOR(16 - 1 downto 0);--noi voi data out o memory
               --
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
       end component;

       -- datapath
       component datapath 
        Generic (
          DATA_WIDTH : integer   := 16;     -- Data Width
          ADDR_WIDTH : integer   := 4     -- Address width
          );
         port ( -- you will need to add more ports here as design grows
                rst     : in STD_LOGIC;
                clk     : in STD_LOGIC;
                --
              --w0 <=> ALUr
                  imm     : in std_logic_vector(7 downto 0); -- w1 <=> imm
                  w2      : in std_logic_vector(DATA_WIDTH -1 downto 0); -- w2 <=> data_out
                RFs : in std_logic_vector(1 downto 0);
      
                --
              ALUs : in std_logic_vector(1 downto 0);
              ALUz : out std_logic;
              --
            RFwa : in std_logic_vector(3 downto 0);
            RFwe : in std_logic;
            OPr1a : in std_logic_vector(3 downto 0);
            OPr1e : in std_logic;
            OPr2a : in std_logic_vector(3 downto 0);
            OPr2e : in std_logic;
            add_out : out std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0)
            -- de test alu
            --ALU_out : out std_logic_vector(15 downto 0)
              );
      end component;

      -- memory
      component dpmem 
        generic (
          DATA_WIDTH        :     integer   := 16;     -- Word Width
          ADDR_WIDTH        :     integer   := 16      -- Address width
          );
      
        port (
          -- Writing
          Clk              : in  std_logic;          -- clock
          Reset             : in  std_logic; -- Reset input
          addr              : in  std_logic_vector(ADDR_WIDTH -1 downto 0);   --  Address
          -- Writing Port
          Wen               : in  std_logic;          -- Write Enable
          Datain            : in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');   -- Input Data
          -- Reading Port
          
          Ren               : in  std_logic;          -- Read Enable
          Dataout           : out std_logic_vector(DATA_WIDTH -1 downto 0)   -- Output data
          
          );
      end component;

      signal address : std_logic_vector(15 downto 0);
      signal imm :  std_logic_vector(7 downto 0);
      signal OPr2 :   std_logic_vector(15 downto 0);--noi datapath oi mux cua control
      --
      signal Mre :  std_logic;
      signal Mwe :  std_logic;
      --
      signal data_out_mem : std_logic_vector(15 downto 0); -- noi voi w2 datapath va ir_in 
      signal data_in_mem :  std_logic_vector(15 downto 0); -- tuong duong data out cua datapath

      -- 
      signal RFs :  STD_LOGIC_VECTOR(1 downto 0);
      signal RFwa :  STD_LOGIC_VECTOR(4 - 1 downto 0);
      signal RFwe :  STD_LOGIC;
      --
      signal OPr1a :  STD_LOGIC_VECTOR(4 - 1 downto 0);
      signal OPr1e :  STD_LOGIC;
      signal OPr2a :  STD_LOGIC_VECTOR(4 - 1 downto 0);
      signal OPr2e :  STD_LOGIC;
      --
      signal ALUs :  STD_LOGIC_VECTOR(1 downto 0);
      signal ALUz : STD_LOGIC;

      --
      --  de test
     signal  add_ms :  std_logic_vector(1 downto 0);
     signal  PC_inc :  STD_LOGIC;
     signal  PC_clr :  STD_LOGIC;
     signal  PC_ld :  STD_LOGIC;
     signal  IR_ld :  STD_LOGIC;

     signal  op :  STD_LOGIC_VECTOR(3 downto 0);

      
     
begin
    ctrl: control_unit
    
    port
     map(reset,clk,ALUz,OPr2,data_out_mem,RFs,RFwa,
    RFwe,OPr1a,OPr1e,Opr2a,OPr2e,ALUs,address,Mre,Mwe,imm,add_ms,
    PC_inc,PC_clr,PC_ld,IR_ld);
    
    data:datapath
    port map(reset,clk,imm,data_out_mem,RFs,ALUs,ALUz,RFwa,RFwe,
    OPr1a,OPr1e,Opr2a,OPr2e,OPr2,data_in_mem);

    mem :dpmem
    port map(clk,reset,address,Mwe,data_in_mem,Mre,data_out_mem);


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
    data_out_mem_t <= data_out_mem; -- noi voi w2 datapath va ir_in 
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