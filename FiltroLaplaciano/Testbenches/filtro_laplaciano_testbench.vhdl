library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filtro_laplaciano_testbench is
end entity filtro_laplaciano_testbench;

architecture behavior of filtro_laplaciano_testbench is

    constant C_IMAGE_LENGTH      : positive := 5;
    constant C_BITS_PER_SAMPLE   : positive := 8;
    constant C_SAMPLES_PER_BLOCK : positive := 25;
    constant C_CLK_PERIOD        : time := 100 ms;

    type T_IMAGE_MATRIX is array (0 to C_IMAGE_LENGTH - 1, 0 to C_IMAGE_LENGTH - 1) of
        std_logic_vector(C_BITS_PER_SAMPLE - 1 downto 0);
	
    --MATRIZ 5X5 (VALORES HEX PARA DIGITAR MAIS FACIL)
    constant C_INPUT_IMAGE : T_IMAGE_MATRIX := (
        (x"01", x"01", x"03", x"02", x"02"), -- Linha 0
        (x"01", x"01", x"03", x"02", x"02"), -- Linha 1
        (x"01", x"01", x"01", x"03", x"03"), -- Linha 2
        (x"02", x"02", x"01", x"04", x"04"), -- Linha 3
        (x"02", x"02", x"01", x"04", x"04")  -- Linha 4
    );

    signal s_clk             : std_logic := '0';
    signal s_reset           : std_logic;
    signal s_start           : std_logic;
    signal s_done            : std_logic;
    signal s_image           : std_logic_vector(C_BITS_PER_SAMPLE * C_SAMPLES_PER_BLOCK - 1 downto 0);
    signal s_laplacian_image : std_logic_vector(C_BITS_PER_SAMPLE * (C_IMAGE_LENGTH - 2) ** 2 - 1 downto 0);

begin
    DUT : entity work.filtro_laplaciano
    generic map(
        image_length      => C_IMAGE_LENGTH,
        bits_per_sample   => C_BITS_PER_SAMPLE,
        samples_per_block => C_SAMPLES_PER_BLOCK
    )
    port map(
        clk             => s_clk,
        reset           => s_reset,
        start           => s_start,
        image           => s_image,
        laplacian_image => s_laplacian_image,
        done            => s_done
    );

    clk_process : process
    begin
        s_clk <= '0';
        wait for C_CLK_PERIOD / 2;
        s_clk <= '1';
        wait for C_CLK_PERIOD / 2;
    end process clk_process;

    stimulus_process : process
    begin
        report "Iniciando simulação do filtro Laplaciano...";

        s_reset <= '0';
        s_start <= '0';
        s_image <= C_INPUT_IMAGE(0, 0) & C_INPUT_IMAGE(0, 1) & C_INPUT_IMAGE(0, 2) & C_INPUT_IMAGE(0, 3) & C_INPUT_IMAGE(0, 4) &
                   C_INPUT_IMAGE(1, 0) & C_INPUT_IMAGE(1, 1) & C_INPUT_IMAGE(1, 2) & C_INPUT_IMAGE(1, 3) & C_INPUT_IMAGE(1, 4) &
                   C_INPUT_IMAGE(2, 0) & C_INPUT_IMAGE(2, 1) & C_INPUT_IMAGE(2, 2) & C_INPUT_IMAGE(2, 3) & C_INPUT_IMAGE(2, 4) &
                   C_INPUT_IMAGE(3, 0) & C_INPUT_IMAGE(3, 1) & C_INPUT_IMAGE(3, 2) & C_INPUT_IMAGE(3, 3) & C_INPUT_IMAGE(3, 4) &
                   C_INPUT_IMAGE(4, 0) & C_INPUT_IMAGE(4, 1) & C_INPUT_IMAGE(4, 2) & C_INPUT_IMAGE(4, 3) & C_INPUT_IMAGE(4, 4);
        
        -- Fase de Reset
        s_reset <= '1';
        wait for C_CLK_PERIOD;
        s_reset <= '0';
        wait for C_CLK_PERIOD;

        report "Iniciando o processo.";
        
        -- Gera um pulso no sinal 'start'
        s_start <= '1';
        wait for C_CLK_PERIOD;
        s_start <= '0';
        
        -- Fase de Espera
        report "Aguardando o sinal 'done' do componente...";
        wait until s_done = '1';

        -- Fase de Verificação e Conclusão
        report "Processamento concluído! O sinal 'done' foi ativado." severity note;
        
        report "Valor da imagem de entrada (s_image): " & to_string(s_image);
        report "Valor da imagem Laplaciana (s_laplacian_image): " & to_string(s_laplacian_image);
        
        -- Fim da simulação
        report "Simulação encerrada." severity failure;
        wait;

    end process stimulus_process;

end architecture behavior;