library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicadorcompletoBCD is 
	port (
	
	      a: in std_logic_vector(15 downto 0);
	      b: in std_logic_vector(15 downto 0);
		  result: out std_logic_vector(31 downto 0)
			);
			
end multiplicadorcompletoBCD;

architecture multiplicadorcompletoBCD_behavior of multiplicadorcompletoBCD is
    signal R1:  std_logic_vector(31 downto 0);
    signal R2:  std_logic_vector(31 downto 0);
    signal R3:  std_logic_vector(31 downto 0);
    signal S0:  std_logic_vector(31 downto 0);
    signal S1:  std_logic_vector(31 downto 0);
    signal S2:  std_logic_vector(31 downto 0);
    signal S3:  std_logic_vector(31 downto 0);
    signal soma0_1: std_logic_vector(31 downto 0);
    signal soma2_3: std_logic_vector(31 downto 0);
    signal somaf : std_logic_vector(31 downto 0);

    
    component uniaomultiplicador is 
	port (
	      a: in std_logic_vector(15 downto 0);
		  result: out std_logic_vector(31 downto 0);
		  b: in std_logic_vector(3 downto 0)
		);
			
    end component uniaomultiplicador;
    
    component somador8BCD is 
	port (
	
	      a: in std_logic_vector(31 downto 0);
		  result: out std_logic_vector(31 downto 0);
		  b: in std_logic_vector(31 downto 0)
			);
			
    end component somador8BCD;
    
    begin
    
    Mult0: uniaomultiplicador port map(
        a => a,
        b => b(3 downto 0),
        result => S0
    );
    
    Mult1: uniaomultiplicador port map(
        a => a,
        b => b(7 downto 4),
        result => R1
    );
    
    S1 <= R1(27 downto 0) & "0000";
    
    Mult2: uniaomultiplicador port map(
        a => a,
        b => b(11 downto 8),
        result => R2
    );
    
    S2 <= R2(23 downto 0)& "00000000";
    
    Mult3: uniaomultiplicador port map(
        a => a,
        b => b(15 downto 12),
        result => R3
    );
    
    S3 <= R3(19 downto 0)& "000000000000";
    
    sum01: somador8BCD port map(
        a => S0,
        b => S1,
        result => soma0_1
    
    );
    
    sum23: somador8BCD port map(
        a => S2,
        b => S3,
        result => soma2_3
    
    );
    
    sumf: somador8BCD port map(
        a => soma0_1,
        b => soma2_3,
        result => somaf
    );
    
    result <= somaf;
    
end multiplicadorcompletoBCD_behavior;