library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Somador sem sinal (unsigned) parametrizável para N bits.
-- Calcula a soma entre input_a e input_b.
-- A saída `sum` possui N+1 bits para representar corretamente o resultado.
entity central_pixel_logic is
	generic(
		image_length : positive := 8;
        address_length     : positive := 4
	);
	port(
		address : in unsigned(address_length-1 downto 0);
        flag   : out std_logic
    );
end central_pixel_logic;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture arch of central_pixel_logic is
    signal remainder : unsigned(address'length-1 downto 0);
begin
    remainder <= address mod to_unsigned(image_length, address'length);
    process (remainder)
    begin
        if remainder = to_unsigned(0, address_length) then 
            flag <= '0';
        elsif remainder = to_unsigned(image_length-1, address_length) then
            flag <= '0';
        else
            flag <= '1';
        end if;
    end process;
end architecture arch;