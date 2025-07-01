library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity demux is
	port (
		sel: in std_logic_vector(3 downto 0);
		A, B, C, D, E, F, G, H, I: out std_logic	
	);
end demux;

architecture behavior of demux is
begin
	process(sel)
	BEGIN
		CASE sel is
		WHEN "0000" =>
			A <= '1';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0001" =>
			A <= '0';
			B <= '1';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0010" =>
			A <= '0';
			B <= '0';
			C <= '1';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0011" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '1';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0100" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '1';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0101" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '1';
			G <= '0';
			H <= '0';
			I <= '0';
		WHEN "0110" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '1';
			H <= '0';
			I <= '0';
		WHEN "0111" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '1';
			I <= '0';
		WHEN "1000" =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '1';
		WHEN OTHERS =>
			A <= '0';
			B <= '0';
			C <= '0';
			D <= '0';
			E <= '0';
			F <= '0';
			G <= '0';
			H <= '0';
			I <= '0';
		END CASE;
	END PROCESS;
end behavior;