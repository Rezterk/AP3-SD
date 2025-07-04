library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.filtro_pack.all;

entity filtro_bo is
	generic(
		bits_per_sample   : positive := 8;
        origin_samples_per_block : positive := 25;
        origin_address_length    : positive := 6;
        origin_length            : positive := 5;
        output_samples_per_block : positive := 9;
        output_address_length : positive := 4
	);
	port(
		clk   : in std_logic;
        cEndOri, zEndOri, cEndOut, zEndOut, cREGCONV, lerMEM, escMEM : in std_logic;
        sMemEnd, cP1, cP2, cP3, cP4, cP5 : in std_logic;
        opADDRESS: in std_logic_vector(2 downto 0);
        sample_image : in image_mem(0 to origin_samples_per_block-1)(bits_per_sample-1 downto 0);
        doneIMG, validPixel : out std_logic;
        laplacian_image : out image_mem(0 to output_samples_per_block-1)(bits_per_sample-1 downto 0)
	);
end filtro_bo;

architecture arch of filtro_bo is
    signal EndOri, EndPixels : unsigned(origin_address_length-1 downto 0);
    signal nextEndOri : unsigned(origin_address_length downto 0);
    signal nextEndOri_mux, memEnd : std_logic_vector(origin_address_length-1 downto 0);
    signal nextEndOut, EndOut : unsigned(output_address_length downto 0);
    signal nextEndOut_mux : std_logic_vector(output_address_length downto 0);
    signal p1, p2, p3, p4, p5, convolutionValue, convolutionReg, valueOriMem : unsigned (bits_per_sample-1 downto 0);
begin
    -- CONTADORES PARA ENDEREÇOS ===========================
    ORIGIN_ADDRESS: ENTITY work.unsigned_register(behavior)
        generic map(
            N => origin_address_length
        )
        port map(
            clk    => clk,
            enable => cEndOri,
            d      => unsigned(nextEndOri_mux),
            q      => EndOri
        );

    FILTERED_ADDRESS: ENTITY work.unsigned_register(behavior)
        generic map(
            N => output_address_length+1
        )
        port map(
            clk    => clk,
            enable => cEndOut,
            d      => unsigned(nextEndOut_mux),
            q      => EndOut
        );

    -- SOMADORES (INCREMENTO de ENDEREÇOS)
    SUM_END_ORI: ENTITY work.unsigned_adder(arch)
        generic map(
            N => origin_address_length
        )
        port map(
            input_a => EndOri,
            input_b => to_unsigned(1, origin_address_length),
            sum     => nextEndOri
        );


    SUM_END_OUT: ENTITY work.unsigned_adder(arch)
        generic map(
            N => output_address_length
        )
        port map(
            input_a => EndOut(output_address_length-1 downto 0),
            input_b => to_unsigned(1, output_address_length),
            sum     => nextEndOut
        );

    -- MUXES (PARA RESETAR ENDEREÇOS)
    MUX_END_ORI: ENTITY work.mux_2to1(behavior)
        generic map(
            N => origin_address_length
        )
        port map(
            sel  => zEndOri,
            in_0 => std_logic_vector(nextEndOri(EndOri'range)),
            in_1 => std_logic_vector(to_unsigned(origin_length+1, origin_address_length)),
            y    => nextEndOri_mux
        );

    MUX_END_OUT: ENTITY work.mux_2to1(behavior)
        generic map(
            N => output_address_length+1
        )
        port map(
            sel  => zEndOut,
            in_0 => std_logic_vector(nextEndOut),
            in_1 => std_logic_vector(to_unsigned(0, output_address_length+1)),
            y    => nextEndOut_mux
        );

    -- ======================================================
    

    -- REGISTRADORES DE PIXELS PARA CONVOLUÇÃO
    PIXEL1: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP1,
            d      => valueOriMem,
            q      => p1
        );
    
    PIXEL2: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP2,
            d      => valueOriMem,
            q      => p2
        );
    
    PIXEL3: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP3,
            d      => valueOriMem,
            q      => p3
        );

    PIXEL4: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP4,
            d      => valueOriMem,
            q      => p4
        );

    PIXEL5: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cP5,
            d      => valueOriMem,
            q      => p5
        );
    
    -- REGISTRADOR PARA O RESULTADO DA CONVOLUÇÃO
    CONVOLUTION_RESULT: ENTITY work.unsigned_register(behavior)
        generic map(
            N => bits_per_sample
        )
        port map(
            clk    => clk,
            enable => cREGCONV,
            d      => convolutionValue,
            q      => convolutionReg
        );


    -- VERIFICAÇÃO DE PIXEL CENTRAL VÁLIDO
    VALID_PIXEL: ENTITY work.central_pixel_logic(arch)
        generic map(
            image_length   => origin_length,
            address_length => origin_address_length
        )
        port map(
            address => EndOri,
            flag    => validPixel
        );
    

    -- LÓGICA PARA ENDEREÇOS VIZINHOS DO PIXEL CENTRAL
    ADDRESS_LOGIC: ENTITY work.address_logic(arch)
        generic map(
            image_length   => origin_length,
            address_length => origin_address_length
        )
        port map(
            central_address => EndOri,
            sel             => opADDRESS,
            new_addres      => EndPixels
        );

    -- COMPARADOR DE IMAGEM
    COMP_DONE_IMG: ENTITY work.comparator(behavior)
        generic map(
            N => output_address_length+1
        )
        port map(
            a    => EndOut,
            b    => to_unsigned(output_samples_per_block, output_address_length+1),
            comp => doneIMG
        );
    


    -- MÓDULO DE CONVOLUÇÃO (Filtor Laplaciano)
    CONVOLUTION: ENTITY work.laplacian_convolution(behavior)
        generic map(
            bits_per_sample => bits_per_sample
        )
        port map(
            p1    => p1,
            p2    => p2,
            p3    => p3,
            p4    => p4,
            p5    => p5,
            p_out => convolutionValue
        );
    
    -- MUX QUE DECIDE ENTRE O ENDEREÇO DO PIXEL CENTRAL OU SEUS VIZINHOS
    MUX_END_MEM: ENTITY work.mux_2to1(behavior)
        generic map(
            N => origin_address_length
        )
        port map(
            sel  => sMemEnd,
            in_0 => std_logic_vector(EndOri),
            in_1 => std_logic_vector(EndPixels),
            y    => memEnd
        );
    

    -- SIMULAÇÃO DA MEMÓRIA DA IMAGEM ORIGINAL
    MEM_ORI_READ: process(memEnd, lerMEM, sample_image)
    begin
        if lerMEM = '1' then
            valueOriMem <= sample_image(to_integer(unsigned(memEnd)));
        else
            valueOriMem <= to_unsigned(0, bits_per_sample);
        end if;
    end process;

    -- SIMULAÇÃO DA MEMÓRIA DA IMAGEM FILTRADA
    MEM_OUT_WRITE: process(EndOut, convolutionReg, escMEM)
    begin
        if escMEM = '1' then
            laplacian_image(to_integer(EndOut)) <= convolutionReg;
        end if;
    end process;
end architecture arch;