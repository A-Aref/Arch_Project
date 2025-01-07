LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Exception_Handling is 
	GENERIC (
		Width: integer := 16
	);
port(
	final_address : in std_logic_vector(Width-1 downto 0);  -- we enter here the address (11 downto 0)
	jmp_res: in std_logic_vector(Width-1 downto 0);
	jmp_yes: in std_logic;
	is_pop : in std_logic;
	mem_read,Mem_write_all: in std_logic;
	sp_or_memory: out std_logic;
	exception_signal : out std_logic
	--final_address_out: out std_logic_vector(Width-1 downto 0)
);
end entity;

architecture behavioural of Exception_Handling is
Signal is_invalid_address : std_logic;
  begin
		-- want to make sure that wen memory range exceeded we go to 4096 not return to 0

		-- Address Validation Logic
    is_invalid_address <= '1' when ((final_address > "0000111111111111") and (mem_read = '1' or Mem_write_all='1')) or ((jmp_res > "0000111111111111") and jmp_yes = '1') else '0';  --0x0fff

    -- Raise Exception Signal Logic
    exception_signal <= '1' when (is_invalid_address = '1') else '0';

    -- SP or MEM Signal Logic
    sp_or_memory <= is_pop; -- 1 for empty stack, 0 for invalid memory address.

  

end architecture;