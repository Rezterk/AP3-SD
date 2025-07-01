--------------------------------------------------
--	Author:          Ismael Seidel
--	Created:         Apr 5, 2025
--
--	Project:         Exercício 4 de INE5406
--	Description:     Contém a descrição de um módulo
-- 					 que faz a operação de clip. 
--                   clipped_value = max(min(value, HIGH), LOW).
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

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