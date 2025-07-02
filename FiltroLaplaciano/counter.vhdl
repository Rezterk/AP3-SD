library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity counter is
	generic (
        N : positive := 3
    );
    port (
        clk : in std_logic;
		ci, zi: in std_logic;
        startNum : in unsigned(N downto 0);
        over : out std_logic;
        output : out unsigned(N-1 downto 0)
	);
end counter;

architecture behavior of counter is
    signal i_sum, i_reg : unsigned(N downto 0);
    signal i_mux        : std_logic_vector(N downto 0);
begin

    SUM: ENTITY work.unsigned_adder
        generic map(
            N => N
        )
        port map(
            input_a => i_reg(N-1 downto 0),
            input_b => to_unsigned(1, N),
            sum     => i_sum
        );
    
    REG: ENTITY work.unsigned_register
        generic map(
            N => N+1
        )
        port map(
            clk    => clk,
            enable => ci,
            d      => unsigned(i_mux),
            q      => i_reg
        );
    
    MUX: ENTITY work.mux_2to1
        generic map(
            N => N+1
        )
        port map(
            sel  => zi,
            in_0 => std_logic_vector(i_sum),
            in_1 => std_logic_vector(startNum),
            y    => i_mux
        );
    

    output <= i_reg(N-1 downto 0);
    over <= i_reg(N);
end behavior;