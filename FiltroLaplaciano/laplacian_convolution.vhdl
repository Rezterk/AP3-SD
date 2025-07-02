library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity laplacian_convolution is
	generic (
		bits_per_sample: positive := 9
	);
	port (
		p1, p2, p3, p4, p5 : in unsigned(bits_per_sample-1 downto 0);
		p_out			   : out unsigned(bits_per_sample-1 downto 0)
	);
end laplacian_convolution;

architecture behavior of laplacian_convolution is
	signal m3, clipped_mult_value : signed(bits_per_sample*2+1 downto 0);
	signal resized_p1, resized_p2, resized_p3, resized_p4 : signed(bits_per_sample downto 0);
	signal result_sum0_1, result_sum0_2 : signed(bits_per_sample+1 downto 0);
	signal resized_p5, result_sum1 : signed(bits_per_sample+2 downto 0);
	signal result_sum2, clipped_out_value : signed(bits_per_sample+3 downto 0);
begin

	-- MULTIPLICADOR
	MULT: ENTITY work.signed_multiplier(behavior)
		generic map(
			N => bits_per_sample+1
		)
		port map(
			a    => resized_p3,
			b    => to_signed(-4, bits_per_sample+1),
			mult => m3
		);
	
	-- ÁRVORE DE SOMADORES
	-- ===== NÍVEL 0 =====
	SUM0_1: ENTITY work.signed_adder(arch)
		generic map(
			N => bits_per_sample+1
		)
		port map(
			input_a => resized_p1,
			input_b => resized_p2,
			sum     => result_sum0_1
		);

	SUM0_2: ENTITY work.signed_adder(arch)
		generic map(
			N => bits_per_sample+1
		)
		port map(
			input_a => clipped_mult_value(bits_per_sample downto 0),
			input_b => resized_p4,
			sum     => result_sum0_2
		);
	
	-- ===== NÍVEL 1 =====
	SUM1: ENTITY work.signed_adder(arch)
		generic map(
			N => bits_per_sample+2
		)
		port map(
			input_a => result_sum0_1,
			input_b => result_sum0_2,
			sum     => result_sum1
		);

	-- ===== NÍVEL 2 =====
	
	SUM2: ENTITY work.signed_adder(arch)
		generic map(
			N => bits_per_sample+3
		)
		port map(
			input_a => result_sum1,
			input_b => resized_p5,
			sum     => result_sum2
		);

	-- CLIP do PIXEL resultante

	CLIP_P: ENTITY work.clip(behavior)
		generic map(
			N    => bits_per_sample+4,
			LOW  => 0,
			HIGH => (p_out'length**2)-1
		)
		port map(
			value         => result_sum2,
			clipped_value => clipped_out_value
		);
	
	-- CLIP do NÚMERO MULTIPLICADO
	
	CLIP_M: ENTITY work.clip(behavior)
		generic map(
			N    => bits_per_sample*2+2,
			LOW  => 0,
			HIGH => (p_out'length**2)-1
		)
		port map(
			value         => m3,
			clipped_value => clipped_mult_value
		);
	

	-- Aumentando os pixels para Sinalizar
	resized_p1 <= signed(resize(p1, bits_per_sample+1));
	resized_p2 <= signed(resize(p2, bits_per_sample+1));
	resized_p3 <= signed(resize(p3, bits_per_sample+1));
	resized_p4 <= signed(resize(p4, bits_per_sample+1));
	resized_p5 <= signed(resize(p5, bits_per_sample+3)); -- Como o p5 será o último a ser somado, seu tamanho será diferente

	-- Fornecendo a saída no tamanho esperado
	p_out <= unsigned(clipped_out_value(p_out'range));

end behavior;