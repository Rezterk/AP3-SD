library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity central_pixel_logic_testbench is
end central_pixel_logic_testbench;

architecture behavior of central_pixel_logic_testbench is
    signal address : unsigned(5 downto 0);
    signal flag    : std_logic;
begin
    cpl: entity work.central_pixel_logic
        generic map (
            image_length => 8,
            address_length => 6
        )
        port map (
            address => address,
            flag    => flag
        );

    stim_proc: process
    begin
        -- Testes de borda (espera flag = '0')
        address <= "001111"; wait for 100 ms; assert flag = '0' report "Erro no endereço 15 (coluna 7)";
        address <= "010000"; wait for 100 ms; assert flag = '0' report "Erro no endereço 16 (coluna 0)";
        address <= "010111"; wait for 100 ms; assert flag = '0' report "Erro no endereço 23 (coluna 7)";
        address <= "100000"; wait for 100 ms; assert flag = '0' report "Erro no endereço 32 (coluna 0)";
        address <= "101000"; wait for 100 ms; assert flag = '0' report "Erro no endereço 40 (coluna 0)";
        address <= "011000"; wait for 100 ms; assert flag = '0' report "Erro no endereço 24 (coluna 0)";
        address <= "110000"; wait for 100 ms; assert flag = '0' report "Erro no endereço 48 (coluna 0)";
        address <= "011111"; wait for 100 ms; assert flag = '0' report "Erro no endereço 31 (coluna 7)";
        address <= "100111"; wait for 100 ms; assert flag = '0' report "Erro no endereço 39 (coluna 7)";
        address <= "101111"; wait for 100 ms; assert flag = '0' report "Erro no endereço 47 (coluna 7)";

        -- Testes de endereços centrais (espera flag = '1')
        address <= "001001"; wait for 100 ms; assert flag = '1' report "Erro no endereço 9";
        address <= "001010"; wait for 100 ms; assert flag = '1' report "Erro no endereço 10";
        address <= "001011"; wait for 100 ms; assert flag = '1' report "Erro no endereço 11";
        address <= "001100"; wait for 100 ms; assert flag = '1' report "Erro no endereço 12";
        address <= "001101"; wait for 100 ms; assert flag = '1' report "Erro no endereço 13";
        address <= "001110"; wait for 100 ms; assert flag = '1' report "Erro no endereço 14";

        address <= "010001"; wait for 100 ms; assert flag = '1' report "Erro no endereço 17";
        address <= "010010"; wait for 100 ms; assert flag = '1' report "Erro no endereço 18";
        address <= "010011"; wait for 100 ms; assert flag = '1' report "Erro no endereço 19";
        address <= "010100"; wait for 100 ms; assert flag = '1' report "Erro no endereço 20";
        address <= "010101"; wait for 100 ms; assert flag = '1' report "Erro no endereço 21";
        address <= "010110"; wait for 100 ms; assert flag = '1' report "Erro no endereço 22";

        address <= "110001"; wait for 100 ms; assert flag = '1' report "Erro no endereço 49";
        address <= "110010"; wait for 100 ms; assert flag = '1' report "Erro no endereço 50";
        address <= "110011"; wait for 100 ms; assert flag = '1' report "Erro no endereço 51";
        address <= "110100"; wait for 100 ms; assert flag = '1' report "Erro no endereço 52";
        address <= "110101"; wait for 100 ms; assert flag = '1' report "Erro no endereço 53";
        address <= "110110"; wait for 100 ms; assert flag = '1' report "Erro no endereço 54";

        report "Testbench finalizado com sucesso.";
        wait;
    end process;
end;
