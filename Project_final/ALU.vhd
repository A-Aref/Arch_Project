
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU IS 
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
END ENTITY;

ARCHITECTURE ALU_arch OF ALU IS
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
	SIGNAL ZERO: std_logic_vector(n-1 downto 0);
	SIGNAL tempNOT,tempAND,tempADD,tempData,tempSUB_1,tempSUB_2,
		tempINC,tempADD_C0,tempRes: std_logic_vector(n-1 downto 0);
	SIGNAL F_tempADD,F_tempSUB,F_tempINC: std_logic;
	SIGNAL trash: std_logic;
BEGIN
	ZERO <= (others => '0');	-- SET WITH ZERO
	tempData <= not(data2);		-- FOR SUB
	tempNOT <= not(data1);
	tempAND <= data1 and data2;
	adder0: N_bit_adder PORT MAP (data1,data2,Carry,F_tempADD,tempADD);
	adder1: N_bit_adder PORT MAP (data1,(others=>'0'),'1',F_tempINC,tempINC);
	temp_adder: N_bit_adder PORT MAP ((others=>'0'),tempData,'1',trash,tempSUB_1);
	adder2: N_bit_adder PORT MAP (data1,tempSUB_1,Carry,F_tempSUB,tempSUB_2);
	adder3: N_bit_adder PORT MAP (data1,data2,'0',trash,tempADD_C0);
	
	
	
	WITH op SELECT
	tempRes <= 
		data1			when "000",
		tempINC		when "001",
		tempNOT		when "010",
		tempADD		when "011",
		tempSUB_2	when "100",
		tempAND		when "101",
		data2			when "110",
		tempADD_C0	when "111",
		(others=> '0') when others;
	
	WITH op SELECT
	Flags(2) <=
		F_tempINC when "001", -- INC
		F_tempADD when "011", -- ADD
		not(F_tempSUB) when "100", -- SUB
		'0' when others;
	
	U_Flags(2) <= '1' when op = "001" or op = "011" or op = "100" else '0'; -- INC,ADD,SUB
	U_Flags(1) <= '1' when op = "001" or op = "010" or op = "011" or op = "100" or op = "101" else '0';	-- NOT,INC,ADD,SUB,AND
	U_Flags(0) <= '1' when op = "001" or op = "010" or op = "011" or op = "100" or op = "101" else '0';	-- NOT,INC,ADD,SUB,AND
	
	Flags(1) <= tempRes(n-1);
	Flags(0) <= '1' when tempRes = ZERO else '0';
	res <= tempRes;
END ARCHITECTURE;