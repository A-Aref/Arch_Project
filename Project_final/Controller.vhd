
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Controller IS 
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
END ENTITY;

ARCHITECTURE Controller_arch OF Controller IS
BEGIN
	
	ALUOp <= Opcode(2 downto 0) when Opcode(6 downto 3) = "0001" -- MOV,INC,NOT,ADD,SUB,AND
		else "110" when Opcode = "1010001"	-- LDM
		else "011" when Opcode = "1010000"	-- ADDI
		else "111" when Opcode(6) = '1' else "000";		-- LDD, STD, INT
	
	JMPImm <= '1' when Opcode(6 downto 5) = "01" else '0'; -- JMPImm
	HltSig <= '1' when Opcode = "0000001" else '0'; -- HLT
	SetC   <= '1' when Opcode = "0000010" else '0'; -- SetC
	INSel  <= '1' when Opcode = "0000011" else '0'; -- IN
	OUTSel <= '1' when Opcode = "0000100" else '0'; -- OUT
	
	ALUsrc <= Opcode(6);
	
	Src1Read <= '0' when Opcode = "0011111"		-- RTI
		or Opcode = "0011101"							-- RET
		or Opcode = "0010101"							-- POP
		or Opcode = "1010001"							-- LDM
		or Opcode(5) = '1'								-- JMPImm,INT
		or Opcode(6 downto 2) = "00000" else '1';	-- NOP,HLT,SETC,IN
	
	Src2Read <= '1' when Opcode = "0001011"	-- ADD
		or Opcode = "0001100"						-- SUB
		or Opcode = "0001101"						-- AND
		or Opcode = "1010011" else '0';			-- STD
	
	SpEn <=  '1' when Opcode(4) = '1' and Opcode(2) = '1' else '0';
	
	Push <= '1' when Opcode = "0010100" -- PUSH
		or Opcode = "0011100"				-- CALL
		or Opcode = "1111110" else '0';	-- INT
	
	Pop  <= '1' when Opcode = "0010101" -- POP
		or Opcode = "0011101"				-- RET
		or Opcode = "0011111" else '0';	-- RTI

	MemRead <= '1' when Opcode = "0010101" -- POP
		or Opcode = "1010010" else '0';		-- LDD

	MemWrt  <= '1' when Opcode = "0010100"	-- PUSH
		or Opcode = "1010011" else '0';		-- STD

	CALL <= '1' when Opcode = "0011100"				-- CALL
		or Opcode(6 downto 5) = "11" else '0';		-- INT

	INT <= '1' when Opcode(6 downto 5) = "11" else '0';-- INT
	
	RET  <= '1' when Opcode = "0011101" else '0'; -- RET
	
	RTI  <= '1' when Opcode = "0011111" else '0'; -- RTI
	
	JmpEn <= '1' when Opcode(4 downto 3) = "11" else '0';	-- JZ,JC,JN,JMP,CALL,RET,INT,RTI
	
	JmpSel <= Opcode(1 downto 0) when Opcode(4 downto 2) = "110"	-- JZ,JN,JC
		else "11";																	-- JMP,CALL,RET,INT,RTI
	
	WB <= '0' when Opcode(4 downto 3) = "11"	-- JZ,JC,JN,JMP,CALL,RET,INT,RTI
		or Opcode(6 downto 5) = "01"				-- JMPImm
		or Opcode = "1010011" 						--	STD
		or Opcode = "0010100" 						--	PUSH
		or Opcode = "0000000" 						-- NOP
		or Opcode = "0000001" 						-- HLT
		or Opcode = "0000010"						-- SETC
		or Opcode = "0000100" else '1';			-- OUT
		
	FWB <= '1' when Opcode(4 downto 3) = "11" else '0'; -- JZ,JC,JN,JMP,CALL,RET,INT,RTI
END ARCHITECTURE;
