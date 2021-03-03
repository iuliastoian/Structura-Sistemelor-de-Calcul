-- modulul transmitatorului
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned;

entity uart_tx is
    generic (BitRate: integer := 9_600); -- rata de biti;
    port (Clk: in std_logic; -- semnalele de intrare
          Rst: in std_logic;
          TxData: in std_logic_vector(7 downto 0); -- octetul care trebuie transmis
          Start: in std_logic; -- comanda de incepere a transmisiei
          -- semnalele de iesire
          Tx: out std_logic; -- linia pe care sunt transmise datele in mod serial
          TxRdy: out std_logic -- semnalul de stare
          );
end uart_tx;

architecture Behavioral of uart_tx is
-- starile automatului
type STATE_TYPE is (ready, load, send, waitbit, shift);
-- starea curenta
signal St: STATE_TYPE := ready;
-- semnal pentru contorizarea bitilor transmisi pe linia seriala
signal CntBit: integer := 0;
-- semnal pentru contorizarea ciclurilor de ceas
signal CntRate: integer := 0;
-- frecventa semnalului de ceas 100 MHz
constant CLK_FREQ: integer := 100_000_000;
-- numarul de cicluri de ceas corespunzatori duratei unui bit
constant T_BIT: integer := CLK_FREQ / BitRate;
-- semnalele de comanda
signal LdData, ShData, TxEn: std_logic;
-- semnalul pentru registrul de deplasare
signal TSR: std_logic_vector(9 downto 0) := (others => '0');
-- atribut pentru a evita modificarea numelor semnalelor dupa etapa de sinteza
attribute keep: string;
attribute keep of St, CntRate, CntBit, TSR: signal is "TRUE";
begin
    -- proces pentru registrul de deplasare TSR
    process (Clk, Rst)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                TSR <= (others => '0');
            elsif LdData = '1' then
                TSR <= '1' & TxData & '0'; -- 0 bitul de START si 1 bitul de STOP
            elsif ShData = '1' then
                TSR <= '0' & TSR(9 downto 1); -- deplasare la dreapta cu 1 bit
            end if;
        end if;
    end process;

    -- Automat de stare pentru unitatea de control a transmitatorului serial
    proc_control: process (Clk)
    begin
        if RISING_EDGE (Clk) then
            if (Rst = '1') then
                St <= ready;
            else
                case St is
                    -- se indica terminarea transmiterii unui octet
                    when ready =>
                        CntRate <= 0;
                        CntBit <= 0;
                        if (Start = '1') then
                            St <= load;
                        end if;
                    -- se incarca registrul de deplasare cu octetul care trebuie transmis
                    when load =>
                        St <= send;
                    -- se transmite 1 bit
                    when send =>
                        St <= waitbit;
                    -- se asteapta trecerea intervalului de timp egal cu durata unui bit
                    when waitbit =>
                        CntRate <= CntRate + 1;
                        if (CntRate = T_BIT) then
                            CntRate <= 0;
                            St <= shift;
                        end if;
                    -- registrul de deplasare se deplaseaza la dreapta cu 1 bit
                    when shift =>
                        CntBit <= CntBit + 1;
                        if (CntBit = 10) then
                            St <= ready;
                        else
                            St <= send;
                        end if;
                    when others =>
                        St <= ready;
                end case;
            end if;
        end if;
    end process proc_control;
    
    -- Setarea semnalelor de comanda
     LdData <= '1' when St = load else '0';
     ShData <= '1' when St = shift else '0';
     TxEn <= '0' when St = ready or St = load else '1';
    -- Setarea semnalelor de iesire
     Tx <= TSR(0) when TxEn = '1' else '1';
     TxRdy <= '1' when St = ready else '0'; 
    
end Behavioral;
