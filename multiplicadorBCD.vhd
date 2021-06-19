library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicadorBCD is 
	port (
	
	     a: in std_logic_vector(3 downto 0);
		  result: out std_logic_vector(7 downto 0);
		  b: in std_logic_vector(3 downto 0)
			);
			
end multiplicadorBCD;	
		
architecture multiplicadorBCD_behavior of multiplicadorBCD is
	signal result_signal : unsigned (7 downto 0);
	signal unidade : unsigned (7 downto 0);
	signal dezena : unsigned (7 downto 0);
	signal unidade_std : std_logic_vector (7 downto 0);
	signal dezena_std : std_logic_vector (7 downto 0);
	
begin
	result_signal <= unsigned(a) * unsigned(b);
	unidade <= result_signal rem 10;
	dezena <= result_signal / 10;
	unidade_std <= std_logic_vector(unidade);
	dezena_std <= std_logic_vector(dezena);
	result <= dezena_std(3 downto 0) & unidade_std(3 downto 0);
	
	
end multiplicadorBCD_behavior;