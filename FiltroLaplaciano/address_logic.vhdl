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
		central_address : in unsigned(address_length-1 downto 0);
        sel : in std_logic_vector (3 downto 0);
        new_addres : out unsigned(address_length-1 downto 0)
    );
end central_pixel_logic;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture arch of central_pixel_logic is
    signal sum_factor, sum_result, resized_central_address : signed(central_address'length downto 0);
begin
    process(sel)
    begin
        case sel is
        when "0000" =>
            sum_factor <= to_signed(-image_length-1, sum_factor'length);
        when "0001" =>
            sum_factor <= to_signed(-image_length, sum_factor'length);
        when "0010" =>
            sum_factor <= to_signed(1+image_length, sum_factor'length);
        when "0011" =>
            sum_factor <= to_signed(-1, sum_factor'length);
        when "0100" =>
            sum_factor <= to_signed(0, sum_factor'length);
        when "0101" =>
            sum_factor <= to_signed(1, sum_factor'length);
        when "0110" =>
            sum_factor <= to_signed(image_length-1, sum_factor'length);
        when "0111" =>
            sum_factor <= to_signed(image_length, sum_factor'length);
        when "1000" =>
            sum_factor <= to_signed(image_length+1, sum_factor'length);
        when others =>
            sum_factor <= to_signed(0, sum_factor'length);
        end case;
    end process;
    
    ADDER: ENTITY work.signed_adder(arch)
            GENERIC MAP (
                n => sum_factor'length
            ) PORT MAP (
                input_a => resized_central_address,
                input_b => sum_factor,
                sum => sum_result
            );
    
    resized_central_address <= signed(resize(central_address, sum_factor'length));
    sum_result <= signed(resize(central_address, sum_factor'length));
    new_addres <= unsigned(sum_result(address_length downto 0));
end architecture arch;