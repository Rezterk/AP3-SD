library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity demux is
	port (
		sel: in std_logic_vector(2 downto 0);
		A, B, C, D, E: out std_logic	
	);
end demux;

architecture behavior of demux is
begin
	process(sel)
	BEGIN
		CASE sel is
		WHEN "000" =>
			A <= '1';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
		WHEN "001" =>
			A <= '0';
			B <= '1';
			C <= '0';
			D <= '0';
			E <= '0';
		WHEN "010" =>
			A <= '0';
			B <= '0';
			C <= '1';
			D <= '0';
			E <= '0';
		WHEN "011" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '1';
			E <= '0';
		WHEN "100" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '1';
		WHEN OTHERS =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
		END CASE;
	END PROCESS;
end behavior;