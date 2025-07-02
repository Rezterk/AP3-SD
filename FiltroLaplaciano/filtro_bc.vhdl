library ieee;
use ieee.std_logic_1164.all;

entity filtro_bc is
    port(
        clk                                : in  std_logic;       -- clock (sinal de relógio)
        rst_a                              : in  std_logic;       -- reset assíncrono ativo em nível alto
        start                              : in  std_logic;
        doneIMG, maxDEMUX, validPixel      : in  std_logic;
        done                               : out std_logic;
        cEndOri, cEndOut, cDEMUX, cREGCONV : out std_logic;
        zEndOri, zEndOut, zDEMUX           : out std_logic;
        escMEM                             : out std_logic
    );
end entity;
-- Não altere o nome da entidade nem da arquitetura!

architecture behavior of filtro_bc is
    type state is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
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

    lpe : PROCESS(current_state, start, doneIMG, validPixel, maxDEMUX)
    BEGIN
        CASE (current_state) IS
            WHEN S0 =>
                IF start = '1' THEN
                    next_state <= S2;
                ELSE
                    next_state <= S0;
                END IF;
            WHEN S1 =>
                IF doneIMG = '1' THEN 
                    next_state <= S8;
                ELSE 
                    next_state <= S2; 
                END IF;
            WHEN S2 =>
                IF validPixel = '1' THEN
                    next_state <= S3;
                ELSE
                    next_state <= S1;
                END IF;
            WHEN S3 =>
                IF maxDEMUX = '1' THEN 
                    next_state <= S5;
                ELSE 
                    next_state <= S4;
                END IF;
            WHEN S4 =>
                next_state <= S3;
            WHEN S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S1;
            when S8 =>
            	next_state <= S8;
        END CASE;
    END PROCESS lpe;

    ls : PROCESS(current_state)
    BEGIN
        CASE (current_state) IS
            WHEN S0 =>
                cEndOri  <= '1';
                zEndOri  <= '1';
                cEndOut  <= '1';
                zEndOut  <= '1';
                cDEMUX   <= '1';
                zDEMUX   <= '1';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            WHEN S1 =>
                cEndOri  <= '1';
                zEndOri  <= '0';
                cEndOut  <= '0';
                zEndOut  <= '-';
                cDEMUX   <= '0';
                zDEMUX   <= '-';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            WHEN S2 =>
                cEndOri  <= '0';
                zEndOri  <= '-';
                cEndOut  <= '0';
                zEndOut  <= '-';
                cDEMUX   <= '0';
                zDEMUX   <= '-';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            WHEN S3 =>
                cEndOri  <= '0';
                zEndOri  <= '-';
                cEndOut  <= '0';
                zEndOut  <= '-';
                cDEMUX   <= '0';
                zDEMUX   <= '-';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            WHEN S4 =>
                cEndOri  <= '0';
                zEndOri  <= '0';
                cEndOut  <= '0';
                zEndOut  <= '0';
                cDEMUX   <= '1';
                zDEMUX   <= '0';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            WHEN S5 =>
                cEndOri  <= '1';
                zEndOri  <= '0';
                cEndOut  <= '0';
                zEndOut  <= '0';
                cDEMUX   <= '1';
                zDEMUX   <= '1';
                cREGCONV <= '1';
                escMEM   <= '0';
                done     <= '0';
            WHEN S6 =>
                cEndOri  <= '0';
                zEndOri  <= '-';
                cEndOut  <= '0';
                zEndOut  <= '-';
                cDEMUX   <= '0';
                zDEMUX   <= '-';
                cREGCONV <= '0';
                escMEM   <= '1';
                done     <= '0';
            when S7 =>
                cEndOri  <= '0';
                zEndOri  <= '0';
                cEndOut  <= '1';
                zEndOut  <= '0';
                cDEMUX   <= '0';
                zDEMUX   <= '0';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '0';
            when S8 =>
                cEndOri  <= '0';
                zEndOri  <= '0';
                cEndOut  <= '0';
                zEndOut  <= '0';
                cDEMUX   <= '0';
                zDEMUX   <= '0';
                cREGCONV <= '0';
                escMEM   <= '0';
                done     <= '1';
        END CASE;
    END PROCESS ls;
end architecture;
