library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filtro_bo is
	generic(
		bits_per_sample   : positive := 8;
        samples_per_block : positive := 64;
        address_length    : positive := 7
	);
	port(
		clk   : in std_logic;
        image : out 
	);
end filtro_bo;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture arch of filtro_bo is
begin
    -- Contadores =====================================
    END_ORI: ENTITY work.unsigned_register
        generic map(
            N => address_length
        )
        port map(
            clk    => clk,
            enable => enable,
            d      => d,
            q      => q
        );
    
end architecture arch;