library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Interface is 
	port (
	        HEX0: out std_logic_vector(6 downto 0);
	        HEX1: out std_logic_vector(6 downto 0);
	        HEX2: out std_logic_vector(6 downto 0);
	        HEX3: out std_logic_vector(6 downto 0);
	        HEX4: out std_logic_vector(6 downto 0);
	        HEX5: out std_logic_vector(6 downto 0);
	        HEX6: out std_logic_vector(6 downto 0);
	        HEX7: out std_logic_vector(6 downto 0);
	        SW: in std_logic_vector(17 downto 0);
	        LEDG: out std_logic_vector(3 downto 0);
	        LEDR: out std_logic_vector(17 downto 0);
	        V_BT: in std_logic_vector(3 downto 0)
			);
			
end Interface;	

architecture Interface_behavior of Interface is
    -- sinais de controle
    signal operacao: std_logic;
    signal reset: std_logic;
    signal AouB: std_logic;
    signal start: std_logic;
    signal ledsV : std_logic_vector(1 downto 0);
    
    -- sinais numericos 
    signal A_signal: std_logic_vector(15 downto 0);
    signal B_signal: std_logic_vector(15 downto 0);
    signal result_signal: std_logic_vector(31 downto 0);
    signal Cout: std_logic_vector(3 downto 0);

    -- sinais saidas 7 segmentos    
    signal displays_03 : std_logic_vector(15 downto 0);
    signal displays_47 : std_logic_vector(15 downto 0);

    --=-=-=- componentens -=-=-=-=-- 
    component decoder7seg is
        port ( 
            N0,N1,N2,N3 : in std_logic;
            A,B,C,D,E,F,G : out std_logic
        );
    end component decoder7seg;

    component CalculadoraBCD is 
    	port (
    	      operacao: in std_logic;
    	      A: in std_logic_vector(15 downto 0);
    		  B: in std_logic_vector(15 downto 0);
    		  result: out std_logic_vector(31 downto 0)
    		);
    			
    end component CalculadoraBCD;	

begin
 

	BouAentradas: process (V_BT(0),V_BT(2),start) 
    -- Verifica qual entrada (A ou B) deve receber os sinais dos interruptores
    begin 
    	if (V_BT(2) = '1' and V_BT(0) = '0') then --botao 0 apertado
	        AouB <= '1';
	        
	    elsif (V_BT(2) = '0' and V_BT(0) = '1') then -- botao (2) reset apertado
	        AouB <= '0';
	        
	    elsif (V_BT(2) = '1' and V_BT(0) = '1' and AouB = '0') then -- situacao inicial
	        AouB <= '0';
	        
	    end if;
	end process;
	
	start_entradas: process (V_BT(1),V_BT(2)) -- decide quando deve exibir entradas ou saidas
    	begin 
        
    	 if  V_BT(2) = '1' and V_BT(1) = '0' then
	        start <= '1';
	        
	    elsif V_BT(2) = '0' and V_BT(1)  = '1' then 
	        start <= '0';
	        
	    elsif V_BT(2) = '1' and V_BT(1) = '1' and start = '0' then 
	        start <= '0';
	        
	   end if;
	end process;	
	
    entradas : process (SW, AouB, start) -- controla os dispositivos de entrada e os leds
    -- Quando AouB é 0 o valor selecionado pelos SW irá definir A
	-- Quando AouB é 1 o valor selecionado pelos SW irá definir B
	begin
	
	if (start = '0') then 
	    LEDR(1 downto 0) <= "00";
    	 if AouB = '0' then
    	    A_signal <= SW(15 downto 0);
    	    B_signal <= "0000000000000000";
    	    LEDG(1 downto 0) <= "01";
    	 elsif AouB = '1' then
    	    B_signal <= SW(15 downto 0);
    	    LEDG(1 downto 0) <= "10";
    	 end if;
    end if; 
	 
	 operacao <= SW(16);
	 
	 if operacao = '0' and start ='1' then
	    LEDR(1 downto 0) <= "01";
	    LEDG(1 downto 0) <= "00";
	 elsif operacao = '1' and start ='1' then
	    LEDR(1 downto 0) <= "10";
	    LEDG(1 downto 0) <= "00";
	 end if;
	 
	end process;
	
	-- controla os led vermelho que indicam se a calculadora está exibindo resultados e qual operacao 
	
	 --=-=-=-=-=-=-=Operações-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                 
	                
	 Cal: CalculadoraBCD port map(
	          operacao => operacao,
    	      A => A_signal,
    		  B => B_signal,
    		  result => result_signal
	 );
	 
	 -- Selecionando o que deve ser passado para os quatro primeiros displays
	 with start select 
	    displays_03 <= result_signal(15 downto 0) when '1', --(UndMilhar Centena Dezena Unidade)
	                   A_signal when '0';
	                   
	-- Selecionando o que deve ser passado para os quatro últimos displays                   
	with start select 
	    displays_47 <= result_signal(31 downto 16) when '1', --(DezMilhao UndMilhao CentMilhar DezMilhar)
	                   B_signal when '0';
	 
	                 
	 --=-=-=-=-=-=-=Displays-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  
	 
	 -- PRIMEIROS QUATRO DISPLAYS 
	 -- EXIBEM A ENTRADA A OU A PRIMEIRA METADE DA SAIDA 
    	D7SA0: decoder7seg 
		    port map (
		        -- entradas bcd
		        N0 => displays_03(3),
		        N1 => displays_03(2),
		        N2 => displays_03(1),
		        N3 => displays_03(0), 
		        -- saida dos leds
                A => HEX0(0),
                B => HEX0(1),
                C => HEX0(2),
                D => HEX0(3),
                E => HEX0(4),
                F => HEX0(5),
                G => HEX0(6)
		    );
		    
		D7SA1: decoder7seg 
		    port map (
		        -- entradas bcd 
		        N0 => displays_03(7),
		        N1 => displays_03(6),
		        N2 => displays_03(5),
		        N3 => displays_03(4),
		        -- saidas dos leds
                A => HEX1(0),
                B => HEX1(1),
                C => HEX1(2),
                D => HEX1(3),
                E => HEX1(4),
                F => HEX1(5),
                G => HEX1(6)
		    );
		   
        D7SB0: decoder7seg 
		    port map (
		        -- entradas bcd
		        N0 => displays_03(11),
		        N1 => displays_03(10),
		        N2 => displays_03(9),
		        N3 => displays_03(8), 
		        -- saida dos leds
                A => HEX2(0),
                B => HEX2(1),
                C => HEX2(2),
                D => HEX2(3),
                E => HEX2(4),
                F => HEX2(5),
                G => HEX2(6)
		    );
		    
		D7SB1: decoder7seg 
		    port map (
		        -- entradas bcd 
		        N0 => displays_03(15),
		        N1 => displays_03(14),
		        N2 => displays_03(13),
		        N3 => displays_03(12),
		        -- saidas dos leds
                A => HEX3(0),
                B => HEX3(1),
                C => HEX3(2),
                D => HEX3(3),
                E => HEX3(4),
                F => HEX3(5),
                G => HEX3(6)
		    );
		    
     -- ÚLTIMOS QUATRO DISPLAYS 
	 -- EXIBEM A ENTRADA B OU A ÚLTIMA METADE DA SAIDA     
    	D7SS0: decoder7seg 
		    port map (
		        -- saidas bcd
		        N0 => displays_47(3),
		        N1 => displays_47(2),
		        N2 => displays_47(1),
		        N3 => displays_47(0), 
		        -- saida dos leds
                A => HEX4(0),
                B => HEX4(1),
                C => HEX4(2),
                D => HEX4(3),
                E => HEX4(4),
                F => HEX4(5),
                G => HEX4(6)
		    );
		    
		D7SS1: decoder7seg 
		    port map (
		        -- saidas bcd 
		        N0 => displays_47(7),
		        N1 => displays_47(6),
		        N2 => displays_47(5),
		        N3 => displays_47(4),
		        -- saidas dos leds
                A => HEX5(0),
                B => HEX5(1),
                C => HEX5(2),
                D => HEX5(3),
                E => HEX5(4),
                F => HEX5(5),
                G => HEX5(6)
		    );
		   
        D7SS2: decoder7seg 
		    port map (
		        -- saidas bcd
		        N0 => displays_47(11),
		        N1 => displays_47(10),
		        N2 => displays_47(9),
		        N3 => displays_47(8), 
		        -- saida dos leds
                A => HEX6(0),
                B => HEX6(1),
                C => HEX6(2),
                D => HEX6(3),
                E => HEX6(4),
                F => HEX6(5),
                G => HEX6(6)
		    );
		    
		D7SS3: decoder7seg 
		    port map (
		        -- saidas bcd 
		        N0 => displays_47(15),
		        N1 => displays_47(14),
		        N2 => displays_47(13),
		        N3 => displays_47(12),
		        -- saidas dos leds
                A => HEX7(0),
                B => HEX7(1),
                C => HEX7(2),
                D => HEX7(3),
                E => HEX7(4),
                F => HEX7(5),
                G => HEX7(6)
		    );
end Interface_behavior;