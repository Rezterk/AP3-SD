library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

-- Componente criado para uma Atividade Prática anterior e que está sendo reutilizado.
-- Esse componente verifica se os valores que serão passados para um Pixel estão dentro
-- de seu intervalo de tamanho. Caso não esteja, seu valor é atualizado seguindo os limites
-- do pixel.

-- `value` é o valor recebido para ser clippado.
-- `clipped_value` retorna o valor corretamente clippado.
entity clip is
	generic (
		N: positive := 9;
		LOW: integer := 0;
		HIGH: integer := 255
	);
	port (
		value: in signed(N-1 downto 0);
		clipped_value: out signed(N-1 downto 0)	
	);
end clip;

architecture behavior of clip is
begin
	clip_value: process(all)
	begin
		if to_integer(value) > HIGH then
			clipped_value <= to_signed(HIGH, clipped_value'length);
		elsif (to_integer(value) < LOW) then
			clipped_value <= to_signed(LOW, clipped_value'length);
		else
			clipped_value <= value;
		end if;
	end process clip_value;
end behavior;