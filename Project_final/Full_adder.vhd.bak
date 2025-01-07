
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Full_adder IS 
	PORT(
		op0: IN std_logic;
		op1: IN std_logic;
		cin: IN std_logic;
		cout: OUT std_logic;
		res: OUT std_logic
	);
END ENTITY;

ARCHITECTURE Full_adder_arch OF Full_adder IS
SIGNAL x0,x1,x2:std_logic;
BEGIN
	x0<= op0 and op1;
	x1<= op0 xor op1;
	x2<= x1 and cin;
	cout<= x2 or x0;
	res <= x1 xor cin;
END ARCHITECTURE;