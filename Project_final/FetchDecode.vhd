LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FetchDecode is
	generic (
        DATA_WIDTH : integer := 16  -- Default instruction width is 16 bits
    );
	port(				 
			  clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  enable : in STD_LOGIC;  --added enable
			  input_in:in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction1_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction2_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  input_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction1_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  instruction2_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
			  current_PC_in: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  next_PC_in: in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  current_PC_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) ;
			  next_PC_out: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0) 
        );
end FetchDecode;

architecture Behavioral of FetchDecode is
begin
    process(clk)
    begin
        if rising_edge(clk) then
				if reset = '1' then
					 input_out <= (others => '0'); 
					 instruction1_out <= (others => '0');  -- Output NOP on reset
					 instruction2_out <= (others => '0'); 
					 current_PC_out <= (others => '0'); 
					 next_PC_out <= (others => '0');
            elsif reset = '0' and enable='1' then --added enable
					 --if enable = '1'  then
--						  instruction1_out <= (others => '0');  -- Output NOP on reset
--						  instruction2_out <= (others => '0'); 
--						  current_PC_out <= (others => '0'); 
--						  next_PC_out <= (others => '0');
--					else
						 input_out <= input_in; 
                   instruction1_out <= instruction1_in;
						 instruction2_out <= instruction2_in;
						 current_PC_out <= current_PC_in; 
						 next_PC_out <= next_PC_in;
               end if;
				end if;
        --end if;
    end process;

end Behavioral;