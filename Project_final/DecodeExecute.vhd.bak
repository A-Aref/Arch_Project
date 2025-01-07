LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DecodeExecute is
    generic (
        DATA_WIDTH : integer := 16 ; -- Default data width is 16 bits
		  Word : integer := 3
    );
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
		  --enable :in  STD_LOGIC;
		  Rsrc1_in : in STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Rsrc2_in : in STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Rd_in : in STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Read_data_1_in: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  Read_data_2_in: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  immd_in : in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  Rsrc1_out : out STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Rsrc2_out : out STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Rd_out : out STD_LOGIC_VECTOR (Word-1 DOWNTO 0);
		  Read_data_1_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  Read_data_2_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  immd_out : out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		  
		  --control signals
		  ------------------
		  JMPImm_in : in STD_LOGIC;
		  RegWrite_in : in STD_LOGIC;
		  mem_read_in: in STD_LOGIC;
		  mem_write_in: in STD_LOGIC;
--		  mem_to_reg_in: in STD_LOGIC;
		  hlt_in: in STD_LOGIC;   -- still need to be known 
		  setc_in: in STD_LOGIC;
		  In_sel_in : in STD_LOGIC;
		  out_sel_in :in STD_LOGIC;
		  sp_enable_in :in STD_LOGIC;
		  call_in: in STD_LOGIC;
		  pop_in: in STD_LOGIC;
		  push_in: in STD_LOGIC;
--		  INT_in:in STD_LOGIC;
		  RET_in: in STD_LOGIC;
		  RTI_in:in STD_LOGIC;
		  JmpEn_in:in STD_LOGIC ;
		  JmpSel_in:in std_logic_vector(1 downto 0);
		  ALUOp_in:in STD_LOGIC_VECTOR (2 downto 0);  -- alu opcode to select operation
		  FWBEn_in : in STD_LOGIC;
		  ALUsrc_in :in STD_LOGIC;
		  JMPImm_out : out STD_LOGIC;
		  RegWrite_out : out STD_LOGIC;
		  mem_read_out: out STD_LOGIC;
		  mem_write_out: out STD_LOGIC;
--		  mem_to_reg_out: out STD_LOGIC;
		  hlt_out: out STD_LOGIC; -- still need to be known 
		  setc_out : out STD_LOGIC;		 
		  In_sel_out : out STD_LOGIC;  
		  out_sel_out: out STD_LOGIC;		  
		  sp_enable_out : out STD_LOGIC;		  
		  call_out: out STD_LOGIC;
		  pop_out:out STD_LOGIC;
		  push_out:out STD_LOGIC;
--		  INT_out: out STD_LOGIC;
		  RET_out:out STD_LOGIC;
		  RTI_out:out STD_LOGIC;
		  JmpEn_out: out STD_LOGIC;
		  JmpSel_out:out std_logic_vector(1 downto 0);
		  ALUOp_out: out STD_LOGIC_VECTOR (2 downto 0);
		  FWBEn_out :out  STD_LOGIC;
		  ALUsrc_out: out STD_LOGIC;
		  src1_read_in: in STD_LOGIC;
		  src1_read_out: out STD_LOGIC;
		  src2_read_in: in STD_LOGIC;
		  src2_read_out: out STD_LOGIC;
			-------
			CurrentPC_in:in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			NextPC_in: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			CurrentPC_out: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			NextPC_out: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			inputin_f: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			inputout_f:out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)
    );
end DecodeExecute;

architecture Behavioral of DecodeExecute is
begin
    process(clk)
    begin
        if rising_edge(clk) then
				if reset = '1' then
						  Rsrc1_out <=(others =>'0');
						  Rsrc2_out  <=(others =>'0');
						  Read_data_1_out <=(others =>'0');
						  Read_data_2_out <=(others =>'0');
						  Rd_out <=(others =>'0');
						  immd_out <=(others =>'0');
						  JMPImm_out<='0';
						  RegWrite_out <='0';
						  mem_read_out<='0';
						  mem_write_out<='0';
						  --mem_to_reg_out<='0';
						  setc_out <='0';		 
						  In_sel_out <='0';  
						  out_sel_out<='0';		  
						  sp_enable_out <='0';		  
						  call_out<='0';
						  pop_out<='0';
						  push_out<='0';
--						  INT_out<='0';
						  RET_out<='0';
						  RTI_out<='0';
						  JmpEn_out<='0';
						  JmpSel_out <=(others =>'0');
						  ALUOp_out <=(others =>'0');
						  FWBEn_out <='0';				 
						  src1_read_out<='0';
						  src2_read_out<='0';
						  hlt_out<='0';	
						 ALUsrc_out<='0';	 
						CurrentPC_out <=(others =>'0');
						NextPC_out <=(others =>'0');
						inputout_f<=(others =>'0');
            elsif reset = '0' then	
--					if enable='1' then
                    Rsrc1_out <=Rsrc1_in;
						  Rsrc2_out <=Rsrc2_in;						 
						  Read_data_1_out<= Read_data_1_in;
						  Read_data_2_out <=Read_data_2_in;
						  Rd_out <=Rd_in;
						  immd_out <=immd_in;
						  JMPImm_out<=JMPImm_in;
						  RegWrite_out <=RegWrite_in;
						  mem_read_out<=mem_read_in;
						  mem_write_out<=mem_write_in;
						 -- mem_to_reg_out<=mem_to_reg_in;
						  setc_out <=setc_in;		 
						  In_sel_out <=In_sel_in;  
						  out_sel_out<=out_sel_in;		  
						  sp_enable_out <=sp_enable_in;		  
						  call_out<=call_in;
						  pop_out<=pop_in;
						  push_out<=push_in;
--						  INT_out<=INT_in;
						  RET_out<=RET_in;
						  RTI_out<=RTI_in;
						  JmpEn_out<=JmpEn_in;
						  JmpSel_out<=JmpSel_in;
						  ALUOp_out<=ALUOp_in;
						  FWBEn_out <=FWBEn_in;				 
						  src1_read_out<=src1_read_in;
						  src2_read_out<=src2_read_in;
						  hlt_out<=hlt_in;
						  ALUsrc_out<=ALUsrc_in;	
						  CurrentPC_out <=CurrentPC_in;
				       NextPC_out <= NextPC_in;
						 inputout_f<= inputin_f;
				end if;
        end if;
    end process;

end Behavioral;
