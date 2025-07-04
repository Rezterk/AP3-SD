library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CONSIDERANDO A MEMÓRIA COMO UMA MATRIZ
-- [--,p1,--]
-- [p2,cP,p3]
-- [--,p4,--]

-- O sinal de entrada 'central_address' nos dá o Endereço do pixel central. A partir dele
-- obtemos o endereço de seus vizinhos.
-- Consideramos m[x][y] igual a matriz da memória, x = linha e y = coluna para facilitar a
-- explicação da lógica. O valor m[0][0] seria o pixel central (cP).

-- OBS: Nosso sistema foi feito pensando somente para a convolução Laplaciana. Dessa forma,
--      o kernel usado na convolução tem '0' nas pontas da matriz. Então, para economizar
--      cálculos, não pegamos esses pixels, pois eles serão zerados na convolução.
entity address_logic is
	generic(
		image_length : positive := 8;
        address_length     : positive := 6
	);
	port(
		central_address : in unsigned(address_length-1 downto 0); -- Endereço do pixel central
        sel             : in std_logic_vector (2 downto 0);       -- Seletor decide qual vizinho será devolvido
        new_addres      : out unsigned(address_length-1 downto 0) -- Endereço do pixel escolhido
    );
end address_logic;

architecture arch of address_logic is
    signal sum_factor : signed(central_address'length downto 0);
    signal sum_result : signed(central_address'length+1 downto 0);
begin
    process(sel)
    begin
        case sel is
        when "000" =>
            sum_factor <= to_signed(-image_length, sum_factor'length); -- m[-1][0] Vizinho de cima
        when "001" =>
            sum_factor <= to_signed(-1, sum_factor'length);            -- m[0][-1] Vizinho à esquerda
        when "010" =>
            sum_factor <= to_signed(0, sum_factor'length);             -- m[0][0]  Próprio cP
        when "011" =>
            sum_factor <= to_signed(1, sum_factor'length);             -- m[0][+1] Vizinho à direita
        when "100" =>
            sum_factor <= to_signed(image_length, sum_factor'length);  -- m[+1][0] Vizinho de baixo
        when others =>
            sum_factor <= to_signed(0, sum_factor'length);
        end case;
    end process;
    
    -- Somador devolve o Endereço correto para acessar o vizinho do pixel central que foi requisitado.
    ADDER: ENTITY work.signed_adder(arch)
            GENERIC MAP (
                n => sum_factor'length
            ) PORT MAP (
                -- A soma é sinalizada, logo o sinal do endereço precisa ser aumentado para ser sinalizado.
                input_a => signed(resize(central_address, sum_factor'length)),
                input_b => sum_factor,
                sum => sum_result
            );
    
    new_addres <= unsigned(sum_result(address_length-1 downto 0));
end architecture arch;