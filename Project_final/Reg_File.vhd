
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Reg_File IS 
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
END ENTITY;

ARCHITECTURE Reg_File_arch OF Reg_File IS
	type ram_type is array((2**ADDRESS_BITS)-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
	signal MEM : ram_type;
BEGIN
	PROCESS(clk,rst)
	BEGIN
		IF (rst='1') THEN
			FOR loc IN 0 TO (2**ADDRESS_BITS)-1 LOOP
				MEM(loc) <= (others => '0');
			END LOOP;
		ELSIF	rising_edge(clk) and WE='1' THEN
			MEM(to_integer(unsigned(write_add))) <= Data_In;
		END IF;
	END PROCESS;
	Data_Out1 <= Data_In when write_add = read_add_1 and WE = '1' else MEM(to_integer(unsigned(read_add_1)));
	Data_Out2 <= Data_In when write_add = read_add_2 and WE = '1' else MEM(to_integer(unsigned(read_add_2)));
END ARCHITECTURE;