library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity somador4BCD is 
	port (
	     
		  A: in std_logic_vector(15 downto 0);
		  B: in std_logic_vector(15 downto 0);
		  Cin:in std_logic_vector(3 downto 0);
		  Sum: out std_logic_vector(15 downto 0);
		  Cout: out std_logic_vector(3 downto 0)
		  
		  
			);
end somador4BCD;

architecture somador4BCD_behavior of somador4BCD is
        signal sum0: std_logic_vector(3 downto 0);
        signal sum1: std_logic_vector(3 downto 0);
        signal sum2: std_logic_vector(3 downto 0);
        signal sum3: std_logic_vector(3 downto 0);
        signal cout0: std_logic_vector(3 downto 0);
        signal cout1: std_logic_vector(3 downto 0);
        signal cout2: std_logic_vector(3 downto 0);
        signal cout3: std_logic_vector(3 downto 0);
        
        
    component somadorBCD is 
    	port (
    	     
    		  A: in std_logic_vector(3 downto 0);
    		  B: in std_logic_vector(3 downto 0);
    		  Cin:in std_logic_vector(3 downto 0);
    		  Sum: out std_logic_vector(3 downto 0);
    		  Cout: out std_logic_vector(3 downto 0)
    		  
    		  
    			);
    end component somadorBCD;

    begin

    som0: somadorBCD port map(
        A => a(3 downto 0),
        B => b(3 downto 0),
        Cin => Cin,
        Cout => cout0,
        Sum => sum0
    );    
     
    som1: somadorBCD port map(
        A => a(7 downto 4),
        B => b(7 downto 4),
        Cin => cout0,
        Cout => cout1,
        Sum => sum1
    ); 
    
    som2: somadorBCD port map(
        A => a(11 downto 8),
        B => b(11 downto 8),
        Cin => cout1,
        Cout => cout2,
        Sum => sum2
    );
    som3: somadorBCD port map(
        A => a(15 downto 12),
        B => b(15 downto 12),
        Cin => cout2,
        Cout => cout3,
        Sum => sum3
    );
    
    Cout <= cout3;
    Sum <= sum3 & sum2 & sum1 & sum0; 
        
    
        
        
end somador4BCD_behavior;