
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Data_Mem IS 
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
END ENTITY;

ARCHITECTURE Data_Mem_arch OF Data_Mem IS
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
			MEM(to_integer(unsigned(add))) <= Data_In;
		END IF;
	END PROCESS;
	Data_Out <= MEM(to_integer(unsigned(add))) when RE = '1' else (others => '0');
END ARCHITECTURE;