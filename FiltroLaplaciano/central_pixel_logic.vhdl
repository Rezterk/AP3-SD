library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Esse componente serve de apoio para o BC. Nele, identificamos se o endereço recebido é válido
-- para as contas de convolução. Resumindo, verificamos se esse pixel pertence à alguma borda da
-- imagem.

-- OBS: No nosso sistema, o primeiro endereço passado já é válido. Assim, não verificamos a borda
--      de cima. O processo também termina antes que o endereço precise atingir a borda inferior.

-- `address` é o sinal de endereço enviado para ser verificado.
-- `flag` retorna '0' se o valor for inválido e '1' se for válido.
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