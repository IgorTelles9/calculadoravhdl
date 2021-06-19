library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity somadorBCD is 
	port (
	     
		  A: in std_logic_vector(3 downto 0);
		  B: in std_logic_vector(3 downto 0);
		  Cin:in std_logic_vector(3 downto 0);
		  Sum: out std_logic_vector(3 downto 0);
		  Cout: out std_logic_vector(3 downto 0)
		  
			);
end somadorBCD;

architecture somadorBCD_behavior of somadorBCD is

signal sumsig: std_logic_vector(3 downto 0);
signal restante: std_logic_vector(3 downto 0);
signal completo:std_logic_vector(3 downto 0);
signal coutsignal: std_logic_vector(3 downto 0);
signal restante_completo : std_logic_vector(4 downto 0);
signal completo_cheio: std_logic_vector(4 downto 0);

begin

	completo_cheio <= ("0"&A) + ("0"&B) + ("0"&Cin);
	restante_completo <= completo - "01010";
	restante <= restante_completo(3 downto 0);
	completo <= completo_cheio(3 downto 0);
	
	with completo_cheio select 
	coutsignal <= "0001" when 
						"01010"|"01011"|"01100"|"01101"|"01110"|"01111"|
						"10000"|"10001"|"10010"|"10011",
						"0000" when others;
	
	with coutsignal select
	sumsig<= restante when "0001",
			    completo when others;
					
	Sum <= sumsig;
	Cout<= coutsignal;
					

end somadorBCD_behavior;