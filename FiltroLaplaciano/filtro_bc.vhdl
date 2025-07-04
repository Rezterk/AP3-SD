library ieee;
use ieee.std_logic_1164.all;

entity filtro_bc is
    port(
        clk                        : in  std_logic;       -- clock (sinal de relógio)
        rst_a                      : in  std_logic;       -- reset assíncrono ativo em nível alto
        start                      : in  std_logic;
        doneIMG, validPixel        : in  std_logic;
        done                       : out std_logic;
        lerMEM, escMEM, sMemEnd    : out std_logic;
        cP1, cP2, cP3, cP4, cP5    : out std_logic;
        cEndOri, cEndOut, cREGCONV : out std_logic;
        zEndOri, zEndOut           : out std_logic;
        opADDRESS                  : out std_logic_vector(2 downto 0)
    );
end entity;
-- Não altere o nome da entidade nem da arquitetura!

architecture behavior of filtro_bc is
    type state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
    signal current_state, next_state : state;
begin
    reg_state : PROCESS(clk, rst_a)
    BEGIN
        IF rst_a = '1' THEN
            current_state <= S0;
        ELSIF rising_edge(clk) THEN
            current_state <= next_state;
        END IF;
    END PROCESS reg_state;

    lpe : PROCESS(current_state, start, doneIMG, validPixel)
    BEGIN
        CASE (current_state) IS
        	when S0 =>
        		if start = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
        	when S1 =>
        		next_state <= S2;
        	when S2 =>
        		if doneIMG = '1' then
                    next_state <= S13;
                else
                    next_state <= S3;
                end if;
        	when S3 =>
        		if validPixel = '1' then
                    next_state <= S4;
                else
                    next_state <= S12;
                end if;
        	when S4 =>
        		next_state <= S5;
        	when S5 =>
        		next_state <= S6;
        	when S6 =>
        		next_state <= S7;
        	when S7 =>
        		next_state <= S8;
        	when S8 =>
        		next_state <= S9;
        	when S9 =>
        		next_state <= S10;
        	when S10 =>
        		next_state <= S11;
        	when S11 =>
        		next_state <= S12;
        	when S12 =>
        		next_state <= S2;
            when S13 =>
                next_state <= S13;
            when others =>
                next_state <= S0;
        END CASE;
    END PROCESS lpe;

    ls : PROCESS(current_state)
    BEGIN
        CASE (current_state) IS
            WHEN S0 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            WHEN S1 =>
                cEndOri   <= '1';
                zEndOri   <= '1';
                cEndOut   <= '1';
                zEndOut   <= '1';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            WHEN S2 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            WHEN S3 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            WHEN S4 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '1';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '1';
                escMEM    <= '0';
                lerMEM    <= '1';
                opADDRESS <= "000";
                done      <= '0';
            WHEN S5 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '1';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '1';
                escMEM    <= '0';
                lerMEM    <= '1';
                opADDRESS <= "001";
                done      <= '0';
            WHEN S6 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '1';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '1';
                escMEM    <= '0';
                lerMEM    <= '1';
                opADDRESS <= "010";
                done      <= '0';
            when S7 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '1';
                cP5       <= '0';
                sMemEnd   <= '1';
                escMEM    <= '0';
                lerMEM    <= '1';
                opADDRESS <= "011";
                done      <= '0';
            when S8 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '1';
                sMemEnd   <= '1';
                escMEM    <= '0';
                lerMEM    <= '1';
                opADDRESS <= "100";
                done      <= '0';
            when S9 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '1';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '0';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            when S10 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '0';
                escMEM    <= '1';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            when S11 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '1';
                zEndOut   <= '0';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '0';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            when S12 =>
                cEndOri   <= '1';
                zEndOri   <= '0';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '0';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
            when S13 =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '1';
            when others =>
                cEndOri   <= '0';
                zEndOri   <= '-';
                cEndOut   <= '0';
                zEndOut   <= '-';
                cREGCONV  <= '0';
                cP1       <= '0';
                cP2       <= '0';
                cP3       <= '0';
                cP4       <= '0';
                cP5       <= '0';
                sMemEnd   <= '-';
                escMEM    <= '0';
                lerMEM    <= '0';
                opADDRESS <= "---";
                done      <= '0';
        END CASE;
    END PROCESS ls;
end architecture;
