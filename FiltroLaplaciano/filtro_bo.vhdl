library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.filtro_pack.all;

entity filtro_bo is
	generic(
		bits_per_sample   : positive := 8;
        origin_samples_per_block : positive := 100;
        origin_address_length    : positive := 7;
        origin_length            : positive := 10;
        output_samples_per_block : positive := 64;
        output_address_length : positive := 7
	);
	port(
		clk   : in std_logic;
        cEndOri, zEndOri, cEndOut, zEndOut, cDEMUX, zDEMUX, cREGCONV, escMEM     : in std_logic;
        sample_image : in image_mem(0 to origin_samples_per_block-1)(bits_per_sample-1 downto 0);
        doneIMG, maxDEMUX, validPixel : out std_logic;
        laplacian_image : out image_mem(0 to output_samples_per_block-1)(bits_per_sample-1 downto 0)
	);
end filtro_bo;
-- Não altere a definição da entidade!
-- Ou seja, não modifique o nome da entidade, nome das portas e tipos/tamanhos das portas!

-- Não alterar o nome da arquitetura!
architecture arch of filtro_bo is
    signal originEndCont, pixelAddress : unsigned(origin_address_length-1 downto 0);
    signal outputEndCont : unsigned(output_address_length-1 downto 0);
    signal demuxSel      : unsigned(2 downto 0);
    signal cP1, cP2, cP3, cP4, cP5 : std_logic;
    signal p1, p2, p3, p4, p5, pixel, laplacian_pixel, convolution_value, convolution_reg : unsigned (bits_per_sample-1 downto 0);
begin
    -- Contadores =====================================
    -- ADICIONAR DEPOIS OS SINAIS DE CONTROLE E STATUS
    END_ORI: ENTITY work.counter(behavior)
        generic map(
            N => origin_address_length
        )
        port map(
            clk    => clk,
            ci     => cEndOri,
            zi     => zEndOri,
            startNum => to_unsigned(origin_length+1, origin_address_length+1),
            over   => open,
            output => originEndCont
        );

    END_OUT: ENTITY work.counter(behavior)
        generic map(
            N => output_address_length
        )
        port map(
            clk    => clk,
            ci     => cEndOut,
            zi     => zEndOut,
            startNum => to_unsigned(0, output_address_length+1),
            over   => open,
            output => outputEndCont
        );

    END_DEMUX: ENTITY work.counter(behavior)
        generic map(
            N => 3
        )
        port map(
            clk    => clk,
            ci     => cDEMUX,
            zi     => zDEMUX,
            startNum => to_unsigned(0, 4),
            over   => open,
            output => demuxSel
        );
    
    -- DEMUX

    DEMUX: ENTITY work.demux(behavior)
        port map(
            sel => std_logic_vector(demuxSel),
            A   => cP1,
            B   => cP2,
            C   => cP3,
            D   => cP4,
            E   => cP5
        );
    
    -- REGISTRADORES

    REG_P1: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP1,
            d      => pixel,
            q      => p1
        );

    REG_P2: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP2,
            d      => pixel,
            q      => p2
        );

    REG_P3: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP3,
            d      => pixel,
            q      => p3
        );

    REG_P4: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP4,
            d      => pixel,
            q      => p4
        );

    REG_P5: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP5,
            d      => pixel,
            q      => p5
        );

    REG_CONV: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cREGCONV,
            d      => convolution_value,
            q      => convolution_reg
        );
    

    MEM: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => escMEM,
            d      => convolution_reg,
            q      => laplacian_pixel
        );

    -- COMPARADORES

    DEMUX_COMP: ENTITY work.comparator(behavior)
        generic map(
            N => 3
        )
        port map(
            a    => demuxSel,
            b    => to_unsigned(5, 3),
            comp => maxDEMUX
        );
    
    IMG_COMP: ENTITY work.comparator(behavior)
        generic map(
            N => output_address_length
        )
        port map(
            a    => outputEndCont,
            b    => to_unsigned(output_samples_per_block, output_address_length),
            comp => doneIMG
        );
    
    -- LÓGICA PARA PIXEL CENTRAL
    CENTRAL_PIXEL: ENTITY work.central_pixel_logic(arch)
        generic map(
            image_length   => origin_length,
            address_length => origin_address_length
        )
        port map(
            address => originEndCont,
            flag    => validPixel
        );
    
    -- LÓGICA PARA PEGAR ENDEREÇOS ADJACENTES AO PIXEL CENTRAL
    ADDRESS_LOGIC: ENTITY work.address_logic(arch)
        generic map(
            image_length   => origin_length,
            address_length => origin_address_length
        )
        port map(
            central_address => originEndCont,
            sel             => std_logic_vector(demuxSel),
            new_addres      => pixelAddress
        );
    

    -- CONVOLUÇÃO
    CONVOLUTION_RESULT: ENTITY work.laplacian_convolution(behavior)
        generic map(
            bits_per_sample => bits_per_sample
        )
        port map(
            p1    => p1,
            p2    => p2,
            p3    => p3,
            p4    => p4,
            p5    => p5,
            p_out => convolution_value
        );

    pixel <= sample_image(to_integer(pixelAddress));
    laplacian_image(to_integer(outputEndCont)) <= laplacian_pixel;
end architecture arch;