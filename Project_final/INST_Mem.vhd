
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY INST_Mem IS 
	GENERIC (WIDTH: integer := 16; ADDRESS_BITS: integer := 12);
	PORT(
		clk : IN std_logic;
		add: IN std_logic_vector(ADDRESS_BITS-1 downto 0);
		out_inst_1: OUT std_logic_vector(WIDTH-1 downto 0);
		out_inst_2: OUT std_logic_vector(WIDTH-1 downto 0)
	);
END ENTITY;

ARCHITECTURE INST_Mem_arch OF INST_Mem IS
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
	type ram_type is array((2**ADDRESS_BITS)-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
	signal MEM : ram_type := (0=>"0000011000000000",
	1 => "0000100000000000",
	others => (others => '0'));
	
	signal temp,pc_2: std_logic_vector(WIDTH-1 downto 0);
	signal INT,trash: std_logic;
BEGIN
	MEM <= (	13 => "0011100000011000",
				12 => "0000100000011000",
				11 => "0000000000000100",
				10 => "1010010011000000",
				9 => 	"0000000000000100",
				8 => 	"1010011000000010",
				7 => 	"0001011010001000",
				6 => 	"0000000000001010",
				5 => 	"1010001001000000",
				4 => 	"0000011000000000",
				3 => 	"0000001000000000",
				2 => 	"0000001000000000",
				1 => 	"0000001000000000",
				0 => 	"0100000000000100",
				others => (others => '0'));
	u0: N_bit_adder GENERIC MAP(12) PORT MAP (add,(others => '0'),'1',trash,pc_2(11 downto 0));
	temp <= MEM(to_integer(unsigned(add)));
	INT <= temp(WIDTH-1) and temp(WIDTH-2);
	out_inst_1 <= temp;
	out_inst_2 <=  "0000" & MEM(3)(11 downto 0) when INT = '1'
		else MEM(to_integer(unsigned(pc_2(11 downto 0))));
END ARCHITECTURE;