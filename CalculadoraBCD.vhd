library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CalculadoraBCD is 
	port (
	      operacao: in std_logic;
	      A: in std_logic_vector(15 downto 0);
		  B: in std_logic_vector(15 downto 0);
		  result: out std_logic_vector(31 downto 0)
		);
			
end CalculadoraBCD;	
		
architecture CalculadoraBCD_behavior of CalculadoraBCD is

    signal reset: std_logic;
    -- Sinais para resultado da soma 
    signal sum_signal_16: std_logic_vector(15 downto 0);
    signal sum_signal: std_logic_vector(31 downto 0);
    -- Sinais do resultado da multiplicação 
    signal mult_signal: std_logic_vector(31 downto 0);
    signal mult_signal_completo: std_logic_vector(31 downto 0);
    -- Sinais do cout 
    signal coutsum: std_logic_vector(3 downto 0);
    signal AouB: std_logic;-- Sinal para apontar o número A ou o número 
    -- resultados finais
    signal result_signal: std_logic_vector(31 downto 0);
    signal cout_signal: std_logic_vector(3 downto 0);

------------------ Chamada dos componentes utilizados na CalculadoraBCD---------------------
    component multiplicadorcompletoBCD is 
	port (
	
	      a: in std_logic_vector(15 downto 0);
	      b: in std_logic_vector(15 downto 0);
		  result: out std_logic_vector(31 downto 0)
			);
			
    end component multiplicadorcompletoBCD;

    component somador4BCD is 
    	port (
    	
    	      A: in std_logic_vector(15 downto 0);
    		  B: in std_logic_vector(15 downto 0);
    		  Cin : in std_logic_vector(3 downto 0);
    		  Sum: out std_logic_vector(15 downto 0);
    		  Cout: out std_logic_vector(3 downto 0)
    		
    		);
    			
    end component somador4BCD;

--------------------------------------------------------------------------------------------
    begin
    
    -- Soma  
    Sum4: somador4BCD port map(
          A => A,
		  B => B,
		  Cin => "0000",
		  Sum => sum_signal_16,
		  Cout => coutsum
    );
    
    -- transformando a soma de 4 digitos (16 bits) em 8 digitos (32 bits)
    Sum_signal <=  "000000000000" & coutsum & sum_signal_16;
    
    -- Multiplicação
    Mult4: multiplicadorcompletoBCD port map(
          A => A,
		  B => B,
		  result => mult_signal
    );
    
    -- Transformação do resultado da multiplicação para 4 digitos em BCD
    
    -- Quando operacao for 0 o resultado da Soma irá aparecer na inteface.
    -- Quando operacao for 1 o resultado da Multiplicação irá aparecer na inteface.
    
    with operacao select
         result_signal <= Sum_signal when '0', 
                          mult_signal when '1';
    
    result <= result_signal;
    
end CalculadoraBCD_behavior;		