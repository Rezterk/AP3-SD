library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Multiplicador com sinal (signed) parametrizável para N bits.
-- Calcula a multiplicação entre a e b.
-- A saída `mult` possui N*2+1 bits para representar corretamente o resultado.
entity signed_multiplier is
	generic(
		N : positive := 4 -- número de bits armazenados
	);
	port(
		a,b : in signed(N-1 downto 0);
        mult: out signed(N*2-1 downto 0)
	);
end signed_multiplier;

architecture behavior OF signed_multiplier is
begin
    mult <= a * b;
end architecture behavior;