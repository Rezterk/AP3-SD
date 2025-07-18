--------------------------------------------------
--	Author:      Ismael Seidel (entidade)
--	Created:     May 1, 2025
--
--	Project:     Exercício 6 de INE5406
--	Description: Contém a descrição de uma entidade para soma entre
--               dois valores sem sinal de N bits. A saída `sum` possui
--               N+1 bits para acomodar o possível carry da operação.
--               Todas as portas utilizam o tipo `unsigned`.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Somador sem sinal (unsigned) parametrizável para N bits.
-- Calcula a soma entre input_a e input_b.
-- A saída `sum` possui N+1 bits para representar corretamente o resultado.
entity unsigned_adder is
	generic(
		N : positive := 8 -- número de bits das entradas
	);
	port(
		input_a : in  unsigned(N - 1 downto 0); -- entrada A com N bits sem sinal
		input_b : in  unsigned(N - 1 downto 0); -- entrada B com N bits sem sinal
		sum     : out unsigned(N downto 0)      -- saída da soma com N+1 bits
	);
end unsigned_adder;

architecture arch of unsigned_adder is
begin
    sum <= UNSIGNED(resize(input_a, N + 1) + UNSIGNED(resize(input_b, N + 1)));
end architecture arch;