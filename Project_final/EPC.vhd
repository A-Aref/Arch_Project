LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity EPC is 
	GENERIC (
		WIDTH: integer := 16
	);
port(

	final_address_in : in std_logic_vector(WIDTH-1 downto 0);  
	exception_signal,clk,rst : in std_logic;
	pc: in std_logic_vector(WIDTH-1 downto 0);  
	epc: out std_logic_vector(WIDTH-1 downto 0)
);
end entity;


architecture behavioural of EPC is
signal epc_internal : std_logic_vector(WIDTH-1 downto 0);  
  begin

	PROCESS(clk)
	BEGIN
		 IF rising_edge(clk) THEN
				IF rst = '1' THEN
						epc_internal <= (OTHERS => '0');
				ElSE
					IF exception_signal = '1' THEN
						epc_internal <= pc; -- Save current PC on exception
					END IF;
			  END IF;
		 END IF;
	END PROCESS;
	epc<= epc_internal;
end architecture;



