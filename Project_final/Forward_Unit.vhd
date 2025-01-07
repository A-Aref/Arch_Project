LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forward_Unit is 
port(
	Rsrc1_out_D,Rsrc2_out_D,dest_out_mem,dest_out_ex : in std_logic_vector(2 downto 0);
	Rsrc1_out_f,Rsrc2_out_f,dest_out_dec : in std_logic_vector(2 downto 0); 
	Src1Read_f,Src2Read_f,Src1Read_d,Src2Read_d,mem_read_out_D,regwrite_out_mem,regwrite_out_ex: in std_logic;
	
	en_pc,en_FD,load_flush,selector1,selector2,selector3: out std_logic
);
end entity;

architecture behaviour of Forward_Unit is

  begin
		
		--selector3<='0';--will be set to 1 if there is forwarding
		

		selector1 <= '0' when (regwrite_out_ex = '1' and dest_out_ex = Rsrc1_out_D and Src1Read_d='1') else
						 '1' when (regwrite_out_mem = '1' and dest_out_mem = Rsrc1_out_D and Src1Read_d='1') else
						 'U';
						 

		selector2 <= '0' when (regwrite_out_ex = '1' and dest_out_ex = Rsrc2_out_D and Src2Read_d='1') else
						 '1' when (regwrite_out_mem = '1' and dest_out_mem = Rsrc2_out_D and Src2Read_d='1') else
						 'U';
						 
		selector3 <= '1' when (regwrite_out_ex = '1' and ((dest_out_ex = Rsrc1_out_D and Src1Read_d='1') or (dest_out_ex = Rsrc2_out_D and Src2Read_d='1'))) else
						 '1' when (regwrite_out_mem = '1' and ((dest_out_mem = Rsrc1_out_D and Src1Read_d='1') or (dest_out_mem = Rsrc2_out_D and Src2Read_d='1'))) else
						 '0';  
		
		
		
				
		en_pc <= '0' when ((Rsrc1_out_f = dest_out_dec and Src1Read_f='1') or 
								 (Rsrc2_out_f = dest_out_dec and Src2Read_f='1')) and 
								 mem_read_out_D='1' else '1';

		en_FD <= '0' when ((Rsrc1_out_f = dest_out_dec and Src1Read_f='1') or 
								 (Rsrc2_out_f = dest_out_dec and Src2Read_f='1')) and 
								 mem_read_out_D='1' else '1'; 

		load_flush <= '1' when ((Rsrc1_out_f = dest_out_dec and Src1Read_f='1') or 
										 (Rsrc2_out_f = dest_out_dec and Src2Read_f='1')) and 
										 mem_read_out_D='1' else '0'; 
end architecture;