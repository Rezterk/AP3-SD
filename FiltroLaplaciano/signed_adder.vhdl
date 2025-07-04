library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Somador com sinal (signed) parametrizável para N bits.
-- Calcula a soma entre input_a e input_b.
-- A saída `sum` possui N+1 bits para representar corretamente o resultado.
entity signed_adder is
	generic(
		N : positive := 8 -- número de bits das entradas
	);
	port(
		input_a : in  signed(N - 1 downto 0); -- entrada A com N bits sem sinal
		input_b : in  signed(N - 1 downto 0); -- entrada B com N bits sem sinal
		sum     : out signed(N downto 0)      -- saída da soma com N+1 bits
	);
end signed_adder;

architecture arch of signed_adder is
begin
    sum <= SIGNED(resize(input_a, N + 1) + SIGNED(resize(input_b, N + 1)));
end architecture arch;