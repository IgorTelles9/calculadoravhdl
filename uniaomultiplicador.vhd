library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uniaomultiplicador is 
	port (
	
	      a: in std_logic_vector(15 downto 0);
		  result: out std_logic_vector(31 downto 0);
		  b: in std_logic_vector(3 downto 0)
			);
			
end uniaomultiplicador;

architecture uniaomultiplicador_behavior of uniaomultiplicador is
   
   
    component multiplicadorBCD is 
	port (
	
	      a: in std_logic_vector(3 downto 0);
		  result: out std_logic_vector(7 downto 0);
		  b: in std_logic_vector(3 downto 0)
			);
			
	
    end component multiplicadorBCD;

    component somador8BCD is 
    	port (
    	
    	      a: in std_logic_vector(31 downto 0);
    		  result: out std_logic_vector(31 downto 0);
    		  b: in std_logic_vector(31 downto 0)
    		 
    			);
			
    end component somador8BCD;	
    
    signal R0: std_logic_vector(7 downto 0);
    signal R1: std_logic_vector(7 downto 0);
    signal R2: std_logic_vector(7 downto 0);
    signal R3: std_logic_vector(7 downto 0);
    signal R0_32: std_logic_vector(31 downto 0);
    signal R1_32: std_logic_vector(31 downto 0);
    signal R2_32: std_logic_vector(31 downto 0);
    signal R3_32: std_logic_vector(31 downto 0);
    signal R0_R1: std_logic_vector(31 downto 0);
    signal R2_R3: std_logic_vector(31 downto 0);
    
    
    begin
        
    Mult0: multiplicadorBCD port map(
        a=> a(3 downto 0),
        b=> b,
        result=> R0
        );    
    
    -- A multiplicação de cada algarismo BCD de A 
    -- está sendo feita com um dos algarismos de B  
    
    R0_32 <= "000000000000000000000000"&R0;
    
    Mult1: multiplicadorBCD port map(
        a=> a(7 downto 4),
        b=> b,
        result=> R1
        ); 
        
    R1_32 <=  "00000000000000000000"&R1&"0000"; 
        
    Mult2: multiplicadorBCD port map(
        a=> a(11 downto 8),
        b=> b,
        result=> R2
        );     
        
    R2_32 <= "0000000000000000"&R2&"00000000";
    
    
    Mult3: multiplicadorBCD port map(
        a=> a(15 downto 12),
        b=> b,
        result=> R3
        ); 
    
    R3_32 <= "000000000000"&R3&"000000000000";
    
    
    Sum01: somador8BCD port map(
        a => R0_32,
        b => R1_32,
        result => R0_R1
    
    );
        
    Sum23: somador8BCD port map(
        a => R2_32,
        b => R3_32,
        result => R2_R3
    
    );    
        
    Sumf: somador8BCD port map(
        a => R0_R1,
        b => R2_R3,
        result => result
    
    );    
        
        
        
end uniaomultiplicador_behavior;