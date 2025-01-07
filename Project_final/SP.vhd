
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SP IS 
	GENERIC (WIDTH: integer := 16);
	PORT(
		clk, rst, push,pop : IN std_logic;
		q: OUT std_logic_vector(WIDTH-1 downto 0)
	);
END ENTITY;

ARCHITECTURE SP_arch OF SP IS
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
	SIGNAL curr,added: std_logic_vector(WIDTH-1 downto 0);
	SIGNAL trash: std_logic;
BEGIN
	u0: N_bit_adder PORT MAP (curr,(others => '0'),'1',trash,added);
	PROCESS(clk,rst)
	BEGIN
		IF(rst='1') THEN
			curr <= (15=>'0',14=>'0',13=>'0',12=>'0', others=> '1');
		ELSIF	rising_edge(clk) THEN
			IF push = '1' THEN
				curr <= std_logic_vector(unsigned(curr) - 1);
			ELSIF pop = '1' THEN
				curr <= std_logic_vector(unsigned(curr) + 1);
			END IF;
		END IF;
	END PROCESS;
	q <= added when pop = '1' else curr;
END ARCHITECTURE;