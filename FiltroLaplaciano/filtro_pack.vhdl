library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package filtro_pack is
    type image_mem is array (natural range <>) of unsigned;

    -- Função que divide um vetor contínuo da imagem em um array
    -- Usamos ela para simular a memória da imagem.
    function to_imagem_mem(param : std_logic_vector; N : positive; P : positive)
    return image_mem;

    -- Função reutilizada da AP2. 
    -- Obtém o número de bits necessários para endereçar a quantidade de amostras da imagem.
    function address_length(samples_per_block : positive; parallel_samples : positive)
    return positive;

    -- Função reutilizada da AP2.
    -- Devolve um vetor contínuo de acordo com os valores no array image_mem
    function to_std_logic_vector(param : image_mem; N : positive; P : positive)
    return std_logic_vector;
end package filtro_pack;

package body filtro_pack is
    function address_length(samples_per_block : positive; parallel_samples : positive)
    return positive is
    begin
        return integer(ceil(log2(real(samples_per_block) / real(parallel_samples))));
    end function address_length;

    function to_imagem_mem(param : std_logic_vector; N : positive; P : positive)
    return image_mem is
        variable return_vector : image_mem(0 to P - 1)(N - 1 downto 0);
    begin
        for i in return_vector'range loop
            -- Cada amostra é extraída como uma fatia de N bits do std_logic_vector de entrada (param).
            return_vector(i) := unsigned(param(N * (i + 1) - 1 downto N * i));
        end loop;
        return return_vector;
    end function to_imagem_mem;

    function to_std_logic_vector(param : image_mem; N : positive; P : positive)
    return std_logic_vector is
        variable return_vector : std_logic_vector(N * P - 1 downto 0);
    begin
        for i in 0 to P - 1 loop
            return_vector(N * (i + 1) - 1 downto N * i) := std_logic_vector(param(i));
        end loop;
        return return_vector;
    end function to_std_logic_vector;
end package body filtro_pack;