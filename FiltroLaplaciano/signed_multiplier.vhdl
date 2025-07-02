library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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