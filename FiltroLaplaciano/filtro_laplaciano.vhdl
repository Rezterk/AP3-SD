library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.filtro_pack.all;

entity filtro_laplaciano is
	generic(
		image_length      : positive := 10;
        bits_per_sample   : positive := 8;
        samples_per_block : positive := 100
	);
	port(
		clk   : in std_logic;
        start, reset : in std_logic;
        image : in std_logic_vector(bits_per_sample * samples_per_block - 1 downto 0);
        laplacian_image : out std_logic_vector(bits_per_sample * (image_length-2)**2 - 1 downto 0);
        done : std_logic
    );
end filtro_laplaciano;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture arch of filtro_laplaciano is
    signal image_array : image_mem(0 to samples_per_block-1)(bits_per_sample-1 downto 0);
    signal laplacian_image_array : image_mem(0 to (image_length-2)**2-1)(bits_per_sample-1 downto 0);
    signal cEndOri, zEndOri, cEndOut, zEndOut, cDEMUX, zDEMUX, cREGCONV, escMEM, doneIMG, maxDEMUX, validPixel : std_logic;
begin
    -- BO
    BO: ENTITY work.filtro_bo(arch)
        generic map(
            bits_per_sample          => bits_per_sample,
            origin_samples_per_block => samples_per_block,
            origin_address_length    => address_length(samples_per_block, 1),
            origin_length            => image_length,
            output_samples_per_block => (image_length-2)**2,
            output_address_length    => address_length((image_length-2)**2, 1)
        )
        port map(
            clk             => clk,
            cEndOri         => cEndOri,
            zEndOri         => zEndOri,
            cEndOut         => cEndOut,
            zEndOut         => zEndOut,
            cDEMUX          => cDEMUX,
            zDEMUX          => zDEMUX,
            cREGCONV        => cREGCONV,
            escMEM          => escMEM,
            sample_image    => image_array,
            doneIMG         => doneIMG,
            maxDEMUX        => maxDEMUX,
            validPixel      => validPixel,
            laplacian_image => laplacian_image_array
        );
    
    BC: ENTITY work.filtro_bc
        port map(
            clk        => clk,
            rst_a      => reset,
            start      => start,
            doneIMG    => doneIMG,
            maxDEMUX   => maxDEMUX,
            validPixel => validPixel,
            done       => done,
            cEndOri    => cEndOri,
            cEndOut    => cEndOut,
            cDEMUX     => cDEMUX,
            cREGCONV   => cREGCONV,
            zEndOri    => zEndOri,
            zEndOut    => zEndOut,
            zDEMUX     => zDEMUX,
            escMEM     => escMEM
        );

    image_array <= to_imagem_mem(image, bits_per_sample, samples_per_block);
    laplacian_image <= to_std_logic_vector(laplacian_image_array, bits_per_sample, (image_length-2)**2);
end architecture arch;