
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux_2x1 IS 
	GENERIC (n: integer := 8);
	PORT(
		op0: IN std_logic_vector(n-1 downto 0);
		op1: IN std_logic_vector(n-1 downto 0);
		sig: IN std_logic;
		res: OUT std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE Mux_2x1_arch OF Mux_2x1 IS
BEGIN
	res <= op1 when (sig = '1') else op0;
END ARCHITECTURE;