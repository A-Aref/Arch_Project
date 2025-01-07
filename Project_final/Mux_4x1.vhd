
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Mux_4x1 IS 
	GENERIC (n: integer := 8);
	PORT(
		op0: IN std_logic_vector(n-1 downto 0);
		op1: IN std_logic_vector(n-1 downto 0);
		op2: IN std_logic_vector(n-1 downto 0);
		op3: IN std_logic_vector(n-1 downto 0);
		sig: IN std_logic_vector(1 downto 0);
		res: OUT std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE Mux_4x1_arch OF Mux_4x1 IS
	COMPONENT Mux_2x1 IS
		GENERIC (n: integer := 8);
		PORT(
		op0: IN std_logic_vector(n-1 downto 0);
		op1: IN std_logic_vector(n-1 downto 0);
		sig: IN std_logic;
		res: OUT std_logic_vector(n-1 downto 0)
	);
	END COMPONENT;
	SIGNAL wire_0,wire_1 :std_logic_vector(n-1 downto 0);
BEGIN
	u0:  Mux_2x1 GENERIC MAP(n) PORT MAP (op0,op1,sig(0),wire_0);
	u1:  Mux_2x1 GENERIC MAP(n) PORT MAP (op2,op3,sig(0),wire_1);
	u2:  Mux_2x1 GENERIC MAP(n) PORT MAP (wire_0,wire_1,sig(1),res);
END ARCHITECTURE;