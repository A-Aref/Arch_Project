
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY N_bit_adder IS 
	GENERIC (n: integer := 16);
	PORT (
		op0: IN std_logic_vector(n-1 downto 0);
		op1: IN std_logic_vector(n-1 downto 0);
		cin: IN std_logic;
		cout: OUT std_logic;
		res: OUT std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE N_bit_adder_arch OF N_bit_adder IS
	COMPONENT Full_adder IS 
		PORT(
			op0: IN std_logic;
			op1: IN std_logic;
			cin: IN std_logic;
			cout: OUT std_logic;
			res: OUT std_logic
		);
	END COMPONENT;
SIGNAL temp_cout:std_logic_vector(n downto 0);
BEGIN
	temp_cout(0)<= cin;
	loop1: FOR i in 0 TO n-1 GENERATE
		fx: Full_adder PORT MAP (op0(i),op1(i),temp_cout(i),temp_cout(i+1),res(i));
	END GENERATE;
	cout<= temp_cout(n);
END ARCHITECTURE;