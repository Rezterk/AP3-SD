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
	signal m3 : signed(bits_per_sample*2-1 downto 0);
	signal result_sum0_2  : signed(m3'length downto 0);
	signal result_sum1	  : signed(m3'length+1 downto 0);
	signal result_sum2, clipped_out_value   : signed(m3'length+2 downto 0);
	signal result_sum0_1  : signed(bits_per_sample+1 downto 0);
begin

	-- MULTIPLICADOR
	MULT: ENTITY work.signed_multiplier(behavior)
		generic map(
			N => bits_per_sample
		)
		port map(
			a    => signed(p3),
			b    => to_signed(-4, bits_per_sample),
			mult => m3
		);
	
	-- ÁRVORE DE SOMADORES
	-- ===== NÍVEL 0 =====
	SUM0_1: ENTITY work.signed_adder(arch)
		generic map(
			N => bits_per_sample+1
		)
		port map(
			input_a => signed(resize(p1, bits_per_sample+1)),
			input_b => signed(resize(p2, bits_per_sample+1)),
			sum     => result_sum0_1
		);

	SUM0_2: ENTITY work.signed_adder(arch)
		generic map(
			N => m3'length
		)
		port map(
			input_a => m3,
			input_b => signed(resize(p4, m3'length)),
			sum     => result_sum0_2
		);
	
	-- ===== NÍVEL 1 =====
	SUM1: ENTITY work.signed_adder(arch)
		generic map(
			N => m3'length+1
		)
		port map(
			input_a => resize(result_sum0_1, m3'length+1),
			input_b => result_sum0_2,
			sum     => result_sum1
		);

	-- ===== NÍVEL 2 =====
	
	SUM2: ENTITY work.signed_adder(arch)
		generic map(
			N => m3'length+2
		)
		port map(
			input_a => result_sum1,
			input_b => signed(resize(p5, m3'length+2)),
			sum     => result_sum2
		);

	-- CLIP do PIXEL resultante

	CLIP: ENTITY work.clip(behavior)
		generic map(
			N    => result_sum2'length,
			LOW  => 0,
			HIGH => (2**bits_per_sample)-1
		)
		port map(
			value         => result_sum2,
			clipped_value => clipped_out_value
		);
	

	-- Fornecendo a saída no tamanho esperado
	p_out <= unsigned(clipped_out_value(p_out'range));

end behavior;