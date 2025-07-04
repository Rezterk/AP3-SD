library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity comparator is
	generic (
		N: positive := 8
	);
	port (
		a, b: in unsigned(N-1 downto 0);
		comp: out std_logic
	);
end comparator;

-- Componente simples que apenas compara se a = b.
architecture behavior of comparator is
begin
	PROCESS (a, b)
    BEGIN
        if a = b then
            comp <= '1';
        else
            comp <= '0';
        end if;
    END PROCESS;
end behavior;