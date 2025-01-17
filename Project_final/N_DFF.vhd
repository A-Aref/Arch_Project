
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY N_DFF IS 
	GENERIC (WIDTH: integer := 16);
	PORT(
		clk, rst, en : IN std_logic;
		d: IN std_logic_vector(WIDTH-1 downto 0);
		q: OUT std_logic_vector(WIDTH-1 downto 0)
	);
END ENTITY;

ARCHITECTURE N_DFF_arch OF N_DFF IS
BEGIN
	PROCESS(clk,rst)
	BEGIN
		IF(rst='1') THEN
			q <= ( others=>'0' );
		ELSIF	rising_edge(clk) and en = '1' THEN
			q <= d;
		END IF;
	END PROCESS;
END ARCHITECTURE;