LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CPU IS 
	PORT(
		clk,rst: IN std_logic;
		Input: IN std_logic_vector(15 downto 0);
		Output: OUT std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE CPU_arch OF CPU IS

	COMPONENT N_DFF IS 
		GENERIC (WIDTH: integer := 16);
		PORT(
			clk, rst, en : IN std_logic;
			d: IN std_logic_vector(WIDTH-1 downto 0);
			q: OUT std_logic_vector(WIDTH-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT INST_Mem IS 
		GENERIC (WIDTH: integer := 16; ADDRESS_BITS: integer := 12);
		PORT(
			clk : IN std_logic;
			add: IN std_logic_vector(ADDRESS_BITS-1 downto 0);
			out_inst_1: OUT std_logic_vector(WIDTH-1 downto 0);
			out_inst_2: OUT std_logic_vector(WIDTH-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT N_bit_adder IS 
		GENERIC (n: integer := 16);
		PORT (
			op0: IN std_logic_vector(n-1 downto 0);
			op1: IN std_logic_vector(n-1 downto 0);
			cin: IN std_logic;
			cout: OUT std_logic;
			res: OUT std_logic_vector(n-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT Reg_File IS 
		GENERIC (
			WIDTH: integer := 16;
			ADDRESS_BITS: integer := 3
		);
		PORT(
			clk, rst, WE : IN std_logic;
			Data_In: IN std_logic_vector(WIDTH-1 downto 0);
			Data_Out1, Data_Out2 : OUT std_logic_vector(WIDTH-1 downto 0);
			read_add_1, read_add_2, write_add : IN std_logic_vector(ADDRESS_BITS-1 downto 0)
		);
	END COMPONENT;

	COMPONENT ALU IS 
		GENERIC (n: integer := 16);
		PORT
		(
			data1: IN std_logic_vector(n-1 downto 0);
			data2: IN std_logic_vector(n-1 downto 0);
			op: IN std_logic_vector(2 downto 0);
			Carry: IN std_logic;
			res: OUT std_logic_vector(n-1 downto 0);
			Flags: OUT std_logic_vector(2 downto 0);
			U_Flags: OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT CCR IS 
		GENERIC (WIDTH: integer := 3);
		PORT(
			clk, rst, WBEn,setC : IN std_logic;
			Update: IN std_logic_vector(WIDTH-1 downto 0);
			d0,d1: IN std_logic_vector(WIDTH-1 downto 0);
			q: OUT std_logic_vector(WIDTH-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT SP IS 
		GENERIC (WIDTH: integer := 16);
		PORT(
			clk, rst, push,pop : IN std_logic;
			q: OUT std_logic_vector(WIDTH-1 downto 0)
		);
	END COMPONENT;

	COMPONENT Data_Mem IS 
		GENERIC (
			WIDTH: integer := 16;
			ADDRESS_BITS: integer := 12
		);
		PORT(
			clk, rst, WE,RE : IN std_logic;
			Data_In: IN std_logic_vector(WIDTH-1 downto 0);
			add :		IN std_logic_vector(ADDRESS_BITS-1 downto 0);
			Data_Out : OUT std_logic_vector(WIDTH-1 downto 0)
		);
	END COMPONENT;
	
	  -- Fetch/Decode Pipeline Register
     COMPONENT FetchDecode IS
        generic  (
            DATA_WIDTH: integer := 16
        );
        port(				 
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  enable : in STD_LOGIC;  
			  input_in:in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction1_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction2_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  input_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction1_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction2_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  current_PC_in: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  next_PC_in: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  current_PC_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  next_PC_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) 
        );
		END COMPONENT; 
		COMPONENT DecodeExecute IS 
			generic (
				  DATA_WIDTH : integer := 16;  -- Default data width is 16 bits
				  Word : integer := 3
			 );
			Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
--		  enable :in  STD_LOGIC;
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
		  -----
		  	CurrentPC_in:in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);  --- should be delayed for exception handling
			NextPC_in: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			CurrentPC_out: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			NextPC_out: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			inputin_f: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			inputout_f:out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0)
		
    );
		END COMPONENT;

	COMPONENT Controller IS 
		PORT(
			Opcode:	IN std_logic_vector(6 downto 0);
			JMPImm:	OUT std_logic;
			HltSig:	OUT std_logic; 
			SetC:		OUT std_logic; 
			INSel:	OUT std_logic; 
			OUTSel:	OUT std_logic;
			ALUsrc:	OUT std_logic;
			Src1Read:OUT std_logic;
			Src2Read:OUT std_logic;
			SpEn:		OUT std_logic;
			Pop:		OUT std_logic;
			Push:		OUT std_logic;
			MemRead:	OUT std_logic;
			MemWrt:	OUT std_logic;
			CALL:		OUT std_logic;
			INT:		OUT std_logic;
			RET:		OUT std_logic;
			RTI:		OUT std_logic;
			JmpEn:	OUT std_logic;
			JmpSel:	OUT std_logic_vector(1 downto 0);
			WB:		OUT std_logic;
			FWB:		OUT std_logic;
			ALUOp:	OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	component Forward_Unit is 
	port(
		Rsrc1_out_D,Rsrc2_out_D,dest_out_mem,dest_out_ex : in std_logic_vector(2 downto 0);
	Rsrc1_out_f,Rsrc2_out_f,dest_out_dec : in std_logic_vector(2 downto 0); 
	Src1Read_f,Src2Read_f,Src1Read_d,Src2Read_d,mem_read_out_D,regwrite_out_mem,regwrite_out_ex: in std_logic;
	
	en_pc,en_FD,load_flush,selector1,selector2,selector3: out std_logic
	);
	end component;
	
	component Exception_Handling is 
	GENERIC (
		Width: integer := 16
	);
	port(
		final_address : in std_logic_vector(Width-1 downto 0);  -- we enter here the address (11 downto 0)
		jmp_res: in std_logic_vector(Width-1 downto 0);
		jmp_yes: in std_logic;
		is_pop : in std_logic;
		mem_read,Mem_write_all: in std_logic;
		sp_or_memory: out std_logic;
		exception_signal : out std_logic
		--final_address_out: out std_logic_vector(Width-1 downto 0)
	);
	end component;
	
	COMPONENT EPC IS
		 	GENERIC (
					WIDTH: integer := 16
				);
			port(
				final_address_in : in std_logic_vector(WIDTH-1 downto 0);  
				exception_signal,clk,rst : in std_logic;
				pc: in std_logic_vector(WIDTH-1 downto 0);  
				epc: out std_logic_vector(WIDTH-1 downto 0)
			);
		END COMPONENT;
	SIGNAL PC,nextPC,IM_PC_1,Instr_1_Fetch,IM_PC_2,Data_OUT_1,Data_OUT_2,WB_Result: std_logic_vector(15 downto 0);
	SIGNAL Reg_data,ALU_SRC_1,ALU_SRC_2,result,DM_Data_In,DM_Addr,DM_Data_OUT,Stack_Pointer,flag_PC: std_logic_vector(15 downto 0);
	SIGNAL jmpRes,jmp_addr,Input_PC_1,Input_PC_2,PCAdd_2,Add_jmp_imm: std_logic_vector(15 downto 0); 
	SIGNAL U_Flags,Flags_IN,Flags_OUT,ALUOp: std_logic_vector(2 downto 0);
	SIGNAL WB,FWBEn,enable_Pc: std_logic;
	
	--update for pipline registers
	SIGNAL Instruction1,Instruction2,CurrentPC,NextPC_f,input_out_f,input_out_D,CurrentPC_D,NextPC_D: std_logic_vector(15 downto 0);
	SIGNAL Rsrc1_out_D, Rsrc2_out_D ,Rd_out_D :  STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL Read_data_1_out_D,Read_data_2_out_D,data2_out_MOD,immd_out_D  : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL  JMPImm_out_D,RegWrite_out_D ,mem_read_out_D,mem_write_out_D,hlt_out_D,setc_out_D ,In_sel_out_D ,out_sel_out_D,	  
				  sp_enable_out_D ,call_out_D, pop_out_D,push_out_D,RET_out_D,RTI_out_D,JmpEn_out_D ,
				  src1_read_out_D,src2_read_out_D,ALUsrc_out_D,FWBEn_out_D: STD_LOGIC;
	SIGNAL JmpSel_out_D : std_logic_vector(1 downto 0);
	SIGNAL ALUOp_out_D : std_logic_vector(2 downto 0);
	
	-- end update
	
	-- update for exception 
	Signal epc_out,final_address_E : std_logic_vector(15 downto 0);
	Signal sp_or_memory_out,exception_signal_out,jump_or_type_of_exception: std_logic;
	---- end update for exception

	
	-----------------------------------
	-------------MARWAN----------------
	-----------------------------------

	SIGNAL in_EX_MEM,out_EX_MEM: std_logic_vector(85 downto 0);
	SIGNAL in_MEM_WB,out_MEM_WB: std_logic_vector(43 downto 0);
	SIGNAL nextpc_out_ex,pc_out_ex,result_out_ex,data2_out_ex,DM_Data_OUT_mem,result_out_mem,Data_OUT_MOD: std_logic_vector(15 downto 0);
	SIGNAL flags_out_ex,jmp_mod_flags,FWBV,dest_out_ex,dest_out_mem: std_logic_vector(2 downto 0);
	SIGNAL enable_EX_MEM:std_logic;
	SIGNAL enable_MEM_WB:std_logic;
	SIGNAL hlt_out_ex,MemWrt_out_ex,pop_out_ex,push_out_ex,spEN_out_ex,Call_out_ex,MemRead_out_ex,RET_out_ex,RTI_out_ex,WB_out_ex,FWBEn_out_ex,FWEn_MOD,OutSel_out_ex,JmpEn_out_ex,JmpImm_out_ex:std_logic;
	SIGNAL WB_out_mem,FWBEn_out_mem,OUTSel_out_mem,JmpEn_out_mem,RTI_out_mem,RET_out_mem,JMPImm_out_mem:std_logic;
	SIGNAL JmpSel_out_ex,JmpSel_out_mem: std_logic_vector(1 downto 0);
	
	SIGNAL en_pc_forw,en_fetdec,load_flush,sel_src1_forw,sel_src2_forw,sel_forw_all, flush_all: std_logic;
	SIGNAL JMPImm_aflush,WB_aflush,MemRead_aflush,MemWrt_aflush,HltSig_aflush,SetC_aflush,INSel_aflush,OUTSel_aflush,SpEn_aflush,CALL_aflush,Pop_aflush,Push_aflush,RET_aflush,RTI_aflush,JmpEn_aflush,FWBEn_aflush,ALUsrc_aflush,Src1Read_aflush,Src2Read_aflush: std_logic;
	SIGNAL JmpSel_aflush: std_logic_vector(1 downto 0);
	SIGNAL ALUOp_aflush: std_logic_vector(2 downto 0);
	SIGNAL input_aflush,nextPC_aflush,pc_aflush,IM_PC_2_aflush,Instr_1_Fetch_aflush: STD_LOGIC_VECTOR (15 DOWNTO 0);
	--------------------------------------------------------
	--------------------------------------------------------

	SIGNAL trash: std_logic;
	SIGNAL	JMPImm:	std_logic;
	SIGNAL	HltSig:	std_logic; 
	SIGNAL	SetC:		std_logic; 
	SIGNAL	INSel:	std_logic; 
	SIGNAL	OUTSel:	std_logic;
	SIGNAL	ALUsrc:	std_logic;
	SIGNAL	Src1Read:std_logic;
	SIGNAL	Src2Read:std_logic;
	SIGNAL	SpEn,SP_rst:		std_logic;
	SIGNAL	Pop:		std_logic;
	SIGNAL	Push:		std_logic;
	SIGNAL	MemRead,Mem_read_all:	std_logic;
	SIGNAL	MemWrt,Mem_write_all:	std_logic;
	SIGNAL	CALL:		std_logic;
	SIGNAL	INT:		std_logic;
	SIGNAL	RET:		std_logic;
	SIGNAL	RTI:		std_logic;
	SIGNAL	JmpEn,jmp_yes,jmpMux,WBSel,WBSel_out_mem:	std_logic;
	SIGNAL	JmpSel:	std_logic_vector(1 downto 0);
BEGIN
	
	------------------------------
	----------- FETCH ------------
	------------------------------
	
	enable_Pc <= not(hlt_out_ex) and en_pc_forw;--forward
	PC_com: N_DFF PORT MAP (clk,rst,enable_Pc,INput_PC_2,PC);
	Int_Mem: INST_Mem PORT MAP (clk,PC(11 downto 0),IM_PC_1,IM_PC_2);
	PCAdd_2 <= (0 => IM_PC_1(15) and not(IM_PC_1(14)),others => '0');
	PC_Add: N_bit_adder PORT MAP (PC,PCAdd_2,'1',trash,nextPC);
	--Update for pipline registers
	
	------------------------------
	--------- FETCH/DEC ----------
	------------------------------
	
	Instr_1_Fetch <= IM_PC_1 when JMPImm = '0' else (others => '0');
			--------------------------------------------------------------
			-------------------------FLUSHING-----------------------------
			--------------------------------------------------------------
			input_aflush<= (others => '0') when flush_all='1' else Input;
			Instr_1_Fetch_aflush<=(others => '0') when flush_all='1' else Instr_1_Fetch;
			IM_PC_2_aflush<= (others => '0') when flush_all='1' else IM_PC_2;
			pc_aflush<= (others => '0') when flush_all='1' else pc;
			nextPC_aflush<= (others => '0') when flush_all='1' else nextPC;
			--------------------------------------------------------------
			--------------------------------------------------------------
	
	fetc_decode: FetchDecode PORT MAP (clk,rst,en_fetdec,input_aflush,Instr_1_Fetch_aflush,IM_PC_2_aflush,input_out_f,Instruction1,Instruction2,pc_aflush,nextPC_aflush,CurrentPC,NextPC_f);
	
	------------------------------
	------------ DEC -------------
	------------------------------

	Registers: Reg_File PORT MAP (clk,rst,WB_out_mem,WB_Result,Data_OUT_1,Data_OUT_2,Instruction1(5 downto 3), Instruction1(2 downto 0), dest_out_mem);
	Reg_data <= (0 => Instruction1(3),others=>'0') when INT = '1' else Data_OUT_1;   -- this for the mux that chooses between data out1 and index
	-- R1-extended (index)
	
	Control: Controller PORT MAP (
		Instruction1(15 downto 9),
		JMPImm,
		HltSig,
		SetC,
		INSel,
		OUTSel,
		ALUsrc,
		Src1Read,
		Src2Read,
		SpEn,
		Pop,
		Push,
		MemRead,
		MemWrt,
		CALL,
		INT,
		RET,
		RTI,
		JmpEn,
		JmpSel,
		WB,
		FWBEn,
		ALUOp
	);
	
	
	Add_jmp_imm(15 downto 12) <= "0000";
	Add_jmp_imm(11 downto 0) <= Instruction1(11 downto 0);
	INput_PC_2 <= Input_PC_1 when JMPImm = '0' else Add_jmp_imm;
	
	------------------------------
	---------- DEC/EXC -----------
	------------------------------
	JMPImm_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else JMPImm;
	WB_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else WB;
	MemRead_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else MemRead;
	MemWrt_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else MemWrt;
	HltSig_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else HltSig;
	SetC_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else SetC;
	INSel_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else INSel;
	OUTSel_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else OUTSel;
	SpEn_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else SpEn;
	CALL_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else CALL;
	Pop_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else Pop;
	Push_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else Push;
	RET_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else RET;
	RTI_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else RTI;
	JmpEn_aflush<= '0' when flush_all='1' or load_flush='1' or JMPImm = '1' else JmpEn;
	JmpSel_aflush<= (others => '0') when flush_all='1' or load_flush='1' or JMPImm = '1' else JmpSel;
	ALUOp_aflush<= (others => '0') when flush_all='1' or load_flush='1' or JMPImm = '1' else ALUOp;
	FWBEn_aflush<= '0'when flush_all='1' or load_flush='1' or JMPImm = '1' else FWBEn;
	ALUsrc_aflush<='0' when flush_all='1' or load_flush='1' or JMPImm = '1' else ALUsrc;
	Src1Read_aflush<='0' when flush_all='1' or load_flush='1' or JMPImm = '1' else Src1Read;
	Src2Read_aflush<='0' when flush_all='1' or load_flush='1' or JMPImm = '1' else Src2Read;
	
	
	decode_execute:DecodeExecute PORT MAP (clk,rst,Instruction1(5 downto 3), Instruction1(2 downto 0),Instruction1(8 downto 6),Reg_data,Data_OUT_2,Instruction2,
	Rsrc1_out_D, Rsrc2_out_D ,Rd_out_D,Read_data_1_out_D,Read_data_2_out_D,immd_out_D,
	JMPImm_aflush,WB_aflush,MemRead_aflush,MemWrt_aflush,HltSig_aflush,SetC_aflush,INSel_aflush,OUTSel_aflush,SpEn_aflush,CALL_aflush,Pop_aflush,Push_aflush,RET_aflush,RTI_aflush,JmpEn_aflush,JmpSel_aflush,ALUOp_aflush,FWBEn_aflush,ALUsrc_aflush,
	JMPImm_out_D,RegWrite_out_D ,mem_read_out_D,mem_write_out_D,hlt_out_D,setc_out_D ,In_sel_out_D ,out_sel_out_D,	  
	sp_enable_out_D ,call_out_D, pop_out_D,push_out_D,RET_out_D,RTI_out_D,JmpEn_out_D,JmpSel_out_D,ALUOp_out_D ,
	FWBEn_out_D,ALUsrc_out_D,Src1Read_aflush,src1_read_out_D,Src2Read_aflush,src2_read_out_D,CurrentPC,NextPC_f,CurrentPC_D,NextPC_D,input_out_f,input_out_D);
	
	------------------------------
	------------ EXC -------------
	------------------------------
	
			--------------------------------------------
			-----------------FORWARDING-----------------
			--------------------------------------------
			forwardu: Forward_Unit PORT MAP (Rsrc1_out_D,Rsrc2_out_D,dest_out_mem,dest_out_ex,Instruction1(5 downto 3), Instruction1(2 downto 0),Rd_out_D,Src1Read,Src2Read,src1_read_out_D,src2_read_out_D,mem_read_out_D,WB_out_mem,WB_out_ex,en_pc_forw,en_fetdec,load_flush,sel_src1_forw,sel_src2_forw,sel_forw_all);
			ALU_SRC_1 <= result_out_ex when (sel_forw_all = '1' and sel_src1_forw = '0') else
							 WB_Result when (sel_forw_all = '1' and sel_src1_forw = '1') else
							 input_out_D when (sel_forw_all /= '1' and In_sel_out_D = '1') else
							 Read_data_1_out_D;

			ALU_SRC_2 <= immd_out_D when (ALUsrc_out_D = '1') else
							 result_out_ex when (sel_forw_all = '1' and sel_src2_forw = '0') else
							 WB_Result when (sel_forw_all = '1' and sel_src2_forw = '1') else
							 Read_data_2_out_D;
							 
			data2_out_MOD <= result_out_ex when (sel_forw_all = '1' and sel_src2_forw = '0') else
							 WB_Result when (sel_forw_all = '1' and sel_src2_forw = '1') else
							 Read_data_2_out_D;
			--------------------------------------------
			-------------END FORWARDING-----------------
			--------------------------------------------
	ALU_C : ALU PORT MAP (ALU_SRC_1,ALU_SRC_2,ALUOp_out_D,Flags_OUT(2),result,Flags_IN,U_Flags);  --U
	Flags: CCR PORT MAP (clk,rst,FWBEn_out_mem,setc_out_D,U_Flags,FWBV,Flags_IN,Flags_OUT);
	
	------------------------------
	---------- EXC/MEM -----------
	------------------------------
	in_EX_MEM <= '0' & NextPC_D & CurrentPC_D & result & data2_out_MOD & 
             Flags_OUT & Rd_out_D & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & "00" & '0' & '0' when flush_all = '1' else
             hlt_out_D & NextPC_D & CurrentPC_D & result & data2_out_MOD & 
             Flags_OUT & Rd_out_D & mem_write_out_D & pop_out_D & push_out_D & 
             sp_enable_out_D & call_out_D & mem_read_out_D & RET_out_D & 
             RTI_out_D & RegWrite_out_D & FWBEn_out_D & out_sel_out_D & 
             JmpSel_out_D & JmpEn_out_D & JMPImm_out_D;
	enable_EX_MEM <= not(hlt_out_ex);
	EX_MEM: N_DFF GENERIC MAP (86) PORT MAP (clk,rst,enable_EX_MEM,in_EX_MEM,out_EX_MEM);
	hlt_out_ex <= out_EX_MEM(85);
	nextpc_out_ex<=out_EX_MEM(84 downto 69);
	pc_out_ex<=out_EX_MEM(68 downto 53);
	result_out_ex<=out_EX_MEM(52 downto 37);
	data2_out_ex<=out_EX_MEM(36 downto 21);
	flags_out_ex<=out_EX_MEM(20 downto 18);
	dest_out_ex<=out_EX_MEM(17 downto 15);
	MemWrt_out_ex<=out_EX_MEM(14);
	pop_out_ex<=out_EX_MEM(13);
	push_out_ex<=out_EX_MEM(12);
	spEN_out_ex<=out_EX_MEM(11);
	Call_out_ex<=out_EX_MEM(10);
	MemRead_out_ex<=out_EX_MEM(9);
	RET_out_ex<=out_EX_MEM(8);
	RTI_out_ex<=out_EX_MEM(7);
	WB_out_ex<=out_EX_MEM(6);
	FWBEn_out_ex<=out_EX_MEM(5);
	OutSel_out_ex<=out_EX_MEM(4);
	JmpSel_out_ex<=out_EX_MEM(3 downto 2);
	JmpEn_out_ex<=out_EX_MEM(1);
--	JmpImm_out_ex<=out_EX_MEM(0);
	
	------------------------------
	------------ MEM -------------
	------------------------------
	SP_rst <= (sp_or_memory_out and exception_signal_out) or rst;
	Stack_P: SP PORT MAP(clk,SP_rst,push_out_ex,pop_out_ex,Stack_Pointer); --changed
	DM_Addr <= Stack_Pointer when spEN_out_ex = '1' else result_out_ex; --changed
	flag_PC(15 downto 13) <= flags_out_ex; --changed
	flag_PC(12)<= '0';
	flag_PC(11 downto 0) <= nextpc_out_ex(11 downto 0); --changed
	DM_Data_In <= flag_PC when Call_out_ex = '1' else result_out_ex when push_out_ex = '1' else data2_out_ex; --changed
	Mem_read_all <= MemRead_out_ex or RET_out_ex or RTI_out_ex;--changed
	Mem_write_all <= Call_out_ex or MemWrt_out_ex;
	
	-- update for exception 
	-- pop should be updated to be out of execute marwan 
	-- there should be flush signal that enter the 
	exception_unit: Exception_Handling port map (DM_Addr,jmpRes,jmp_yes,pop_out_ex,Mem_read_all,Mem_write_all,sp_or_memory_out,exception_signal_out);  --created
	  -- Address to Memory Logic
   final_address_E <= (others => '0') when (exception_signal_out = '1') else DM_Addr; 
	
	epc_register:EPC port map(DM_Addr,exception_signal_out,clk,rst,pc_out_ex,epc_out); --created
	DM: Data_Mem PORT MAP (clk,rst,Mem_write_all,Mem_read_all,DM_Data_In,final_address_E(11 downto 0),DM_Data_OUT); --changed
	---- end update for exception
	
	
	
	jmpMux <= '1' when JmpSel_out_ex = "11" else	flags_out_ex(0) when JmpSel_out_ex = "00" else  flags_out_ex(1) when JmpSel_out_ex = "01" else flags_out_ex(2); --changed
	jmp_yes <= jmpMux and JmpEn_out_ex; --changed
	jmp_addr(15 downto 12) <= (others => '0');
	jmp_addr(11 downto 0) <= DM_Data_OUT(11 downto 0);
	jmpRes <= jmp_addr when RTI_out_ex = '1' or RET_out_ex = '1' else result_out_ex; --changed
	WBSel <= jmp_yes or Mem_read_all; --added
	jmp_mod_flags(2) <= '0' when JmpSel_out_ex = "10" and jmp_yes = '1' else flags_out_ex(2);
	jmp_mod_flags(1) <= '0' when JmpSel_out_ex = "01" and jmp_yes = '1' else flags_out_ex(1);
	jmp_mod_flags(0) <= '0' when JmpSel_out_ex = "00" and jmp_yes = '1' else flags_out_ex(0);
	FWEn_MOD <= FWBEn_out_ex when jmp_yes = '1' else '0';
	Data_OUT_MOD(15 downto 12) <= (jmp_mod_flags & '0') when jmp_yes = '1' and RTI_out_ex = '0' else DM_Data_OUT(15 downto 12);
	Data_OUT_MOD(11 downto 0) <= DM_Data_OUT(11 downto 0);
	
	flush_all<=jmp_yes or rst or exception_signal_out;
	
	-----------------------------
	---------- MEM/WB -----------
	-----------------------------
	
	in_MEM_WB<= Data_OUT_MOD & result_out_ex & dest_out_ex & '0' & '0' & '0' & "00" & '0' & '0' & '0' & '0' when rst='1' or exception_signal_out='1' else
					Data_OUT_MOD & result_out_ex & dest_out_ex & WB_out_ex & FWEn_MOD & OUTSel_out_ex & JmpSel_out_ex & JmpEn_out_ex & RTI_out_ex & RET_out_ex & WBSel;

	enable_MEM_WB <= '1';
	MEM_WB : N_DFF GENERIC MAP (44) PORT MAP (clk,rst,enable_MEM_WB,in_MEM_WB,out_MEM_WB);
	DM_Data_OUT_mem<=out_MEM_WB(43 downto 28);
	result_out_mem<=out_MEM_WB(27 downto 12);
	dest_out_mem<=out_MEM_WB(11 downto 9);
	WB_out_mem<=out_MEM_WB(8);
	FWBEn_out_mem<=out_MEM_WB(7);
	OUTSel_out_mem<=out_MEM_WB(6);
--	JmpSel_out_mem<=out_MEM_WB(5 downto 4);
--	JmpEn_out_mem<=out_MEM_WB(3);
--	RTI_out_mem<=out_MEM_WB(2);
--	RET_out_mem<=out_MEM_WB(1);
	WBSel_out_mem<=out_MEM_WB(0);
	
	-----------------------------
	------------ WB -------------
	-----------------------------
	
	--changed order
	WB_Result <= DM_Data_OUT_mem when WBSel_out_mem = '1' else result_out_mem;
	Output_Reg : N_DFF PORT MAP (clk,rst,OUTSel_out_mem,WB_Result,Output);
	FWBV <= WB_Result(15 downto 13);
	--end change order
	
	-- update for exception
	--mux at exception
	jump_or_type_of_exception <= sp_or_memory_out when exception_signal_out='1' else jmp_yes; --mux near exception 
	--first stage mux from the design before pc
	Input_PC_1 <= jmpRes   when (jump_or_type_of_exception='1' and exception_signal_out= '0')
				--else NextPC_D when jump_or_type_of_exception='0' and exception_signal_out= '0';
				else "0000000000000010" when (jump_or_type_of_exception='0' and exception_signal_out= '1')
				else "0000000000000001"	when (jump_or_type_of_exception='1' and exception_signal_out= '1')
				else nextPC;
	--for flushing
	-- end update for exception
	
	
END ARCHITECTURE;