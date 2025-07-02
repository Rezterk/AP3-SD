library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package filtro_pack is
    --TODO: DECLARAR TIPO ARRAY PARA MEMÓRIA
    type image_mem is array (natural range <>) of unsigned;

    function to_imagem_mem(param : std_logic_vector; N : positive; P : positive)
    return image_mem;

    -- Calcula o número de bits necessários para indexar todos os grupos parciais de amostras
    -- dentro de um bloco completo. O número de grupos é (samples_per_block / parallel_samples),
    -- e o resultado é o menor inteiro maior ou igual a log2 desse valor.
    function address_length(samples_per_block : positive; parallel_samples : positive)
    return positive;
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
end package body filtro_pack;