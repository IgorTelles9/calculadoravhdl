library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador8BCD is 
	port (
	
	      a: in std_logic_vector(31 downto 0);
		  result: out std_logic_vector(31 downto 0);
		  b: in std_logic_vector(31 downto 0);
		  cout: out std_logic_vector(3 downto 0)
			);
			
end somador8BCD;


architecture somador8BCD_behavior of somador8BCD is
        signal R0: std_logic_vector(15 downto 0);
        signal R1: std_logic_vector(15 downto 0);
        signal cout0: std_logic_vector(3 downto 0);
        
        component somador4BCD is 
        	port (
        	      A: in std_logic_vector(15 downto 0);
        		  B: in std_logic_vector(15 downto 0);
        		  Sum: out std_logic_vector(15 downto 0);
        		  Cin: in std_logic_vector(3 downto 0);
        		  Cout: out std_logic_vector(3 downto 0)
        		);
			
        end component somador4BCD;
        
    begin
        
        Sum0 : somador4BCD port map(
            A=> a(15 downto 0),
            B=> b(15 downto 0),
            Sum => R0,
            Cin => "0000",
            Cout => cout0
        );
        
        Sum1 : somador4BCD port map(
            A=> a(31 downto 16),
            B=> b(31 downto 16),
            Sum => R1,
            Cin => cout0,
            Cout => cout
        );
        
        result <= R1&R0;
        

        
end somador8BCD_behavior;