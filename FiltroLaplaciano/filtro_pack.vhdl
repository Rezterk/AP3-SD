library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package filtro_pack is
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
end package body filtro_pack;