library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_logic_testbench is
end address_logic_testbench;

architecture behavior of address_logic_testbench is
    signal central_address : unsigned(5 downto 0);
    signal sel    			: std_logic_vector (2 downto 0);
	 signal new_addres		: unsigned(5 downto 0);
begin
    al: entity work.address_logic
        generic map (
            image_length => 8,
            address_length => 6
        )
        port map (
            central_address => central_address,
				sel => sel,
				new_addres => new_addres
        );

    test_proc: process
    begin
        -- Testes de address 9
        central_address <= to_unsigned(9, 6); sel <= "000"; wait for 1 ms; assert new_addres = to_unsigned(1, 6) report "Erro no endereço 9, pos 0";
		  central_address <= to_unsigned(9, 6); sel <= "001"; wait for 1 ms; assert new_addres = to_unsigned(8, 6) report "Erro no endereço 9, pos 1";
		  central_address <= to_unsigned(9, 6); sel <= "010"; wait for 1 ms; assert new_addres = to_unsigned(9, 6) report "Erro no endereço 9, pos 2";
		  central_address <= to_unsigned(9, 6); sel <= "011"; wait for 1 ms; assert new_addres = to_unsigned(10, 6) report "Erro no endereço 9, pos 3";
		  central_address <= to_unsigned(9, 6); sel <= "100"; wait for 1 ms; assert new_addres = to_unsigned(17, 6) report "Erro no endereço 9, pos 4";
		  
		  -- Testes de address 14
		  central_address <= to_unsigned(14, 6); sel <= "000"; wait for 1 ms; assert new_addres = to_unsigned(6, 6) report "Erro no endereço 14, pos 0";
		  central_address <= to_unsigned(14, 6); sel <= "001"; wait for 1 ms; assert new_addres = to_unsigned(13, 6) report "Erro no endereço 14, pos 1";
		  central_address <= to_unsigned(14, 6); sel <= "010"; wait for 1 ms; assert new_addres = to_unsigned(14, 6) report "Erro no endereço 14, pos 2";
		  central_address <= to_unsigned(14, 6); sel <= "011"; wait for 1 ms; assert new_addres = to_unsigned(15, 6) report "Erro no endereço 14, pos 3";
		  central_address <= to_unsigned(14, 6); sel <= "100"; wait for 1 ms; assert new_addres = to_unsigned(22, 6) report "Erro no endereço 14, pos 4";

		  -- Testes de address 35
        central_address <= to_unsigned(35, 6); sel <= "000"; wait for 1 ms; assert new_addres = to_unsigned(27, 6) report "Erro no endereço 35, pos 0";
		  central_address <= to_unsigned(35, 6); sel <= "001"; wait for 1 ms; assert new_addres = to_unsigned(34, 6) report "Erro no endereço 35, pos 1";
		  central_address <= to_unsigned(35, 6); sel <= "010"; wait for 1 ms; assert new_addres = to_unsigned(35, 6) report "Erro no endereço 35, pos 2";
		  central_address <= to_unsigned(35, 6); sel <= "011"; wait for 1 ms; assert new_addres = to_unsigned(36, 6) report "Erro no endereço 35, pos 3";
		  central_address <= to_unsigned(35, 6); sel <= "100"; wait for 1 ms; assert new_addres = to_unsigned(43, 6) report "Erro no endereço 35, pos 4";
		  
		  -- Testes de address 46
        central_address <= to_unsigned(46, 6); sel <= "000"; wait for 1 ms; assert new_addres = to_unsigned(38, 6) report "Erro no endereço 46, pos 0";
		  central_address <= to_unsigned(46, 6); sel <= "001"; wait for 1 ms; assert new_addres = to_unsigned(45, 6) report "Erro no endereço 46, pos 1";
		  central_address <= to_unsigned(46, 6); sel <= "010"; wait for 1 ms; assert new_addres = to_unsigned(46, 6) report "Erro no endereço 46, pos 2";
		  central_address <= to_unsigned(46, 6); sel <= "011"; wait for 1 ms; assert new_addres = to_unsigned(47, 6) report "Erro no endereço 46, pos 3";
		  central_address <= to_unsigned(46, 6); sel <= "100"; wait for 1 ms; assert new_addres = to_unsigned(54, 6) report "Erro no endereço 46, pos 4";
		  
		  -- Testes de address 53
        central_address <= to_unsigned(53, 6); sel <= "000"; wait for 1 ms; assert new_addres = to_unsigned(45, 6) report "Erro no endereço 53, pos 0";
		  central_address <= to_unsigned(53, 6); sel <= "001"; wait for 1 ms; assert new_addres = to_unsigned(52, 6) report "Erro no endereço 53, pos 1";
		  central_address <= to_unsigned(53, 6); sel <= "010"; wait for 1 ms; assert new_addres = to_unsigned(53, 6) report "Erro no endereço 53, pos 2";
		  central_address <= to_unsigned(53, 6); sel <= "011"; wait for 1 ms; assert new_addres = to_unsigned(54, 6) report "Erro no endereço 53, pos 3";
		  central_address <= to_unsigned(53, 6); sel <= "100"; wait for 1 ms; assert new_addres = to_unsigned(61, 6) report "Erro no endereço 53, pos 4";
		  
        report "Testbench finalizado com sucesso.";
        wait;
    end process;
end;
