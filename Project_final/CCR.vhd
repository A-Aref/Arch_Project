
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CCR IS 
	GENERIC (WIDTH: integer := 3);
	PORT(
		clk, rst, WBEn,setC : IN std_logic;
		Update: IN std_logic_vector(WIDTH-1 downto 0);
		d0,d1: IN std_logic_vector(WIDTH-1 downto 0);
		q: OUT std_logic_vector(WIDTH-1 downto 0)
	);
END ENTITY;

ARCHITECTURE CCR_arch OF CCR IS
	signal curr: std_logic_vector(2 downto 0);
BEGIN
	PROCESS(clk,rst)
	BEGIN
		IF(rst='1') THEN
			curr <= (others=>'0');
		ELSIF	rising_edge(clk) THEN
			IF WBEn = '1' THEN
				curr <= d0;
			ELSIF setC = '1' THEN
				curr(2) <= '1';
			ELSE
				IF Update(2) = '1' THEN
					curr(2) <= d1(2);
				END IF;
				IF Update(1) = '1' THEN
					curr(1) <= d1(1);
				END IF;
				IF Update(0) = '1' THEN
					curr(0) <= d1(0);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	q <= curr;
END ARCHITECTURE;