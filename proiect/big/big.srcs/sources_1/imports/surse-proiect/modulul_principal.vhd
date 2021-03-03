library ieee;
use ieee.std_logic_1164.all;

entity modulul_principal is
    generic(
        clk_freq                  : integer := 100_000_000; -- clock de 100mhz al sistemului
        ps2_debounce_counter_size : integer := 9);          -- se seteaza astfel incat 2^size/clk_freq = 5us (size = 9 pentru 100mhz)
    port(
        -- semnalele de intrare
        clk        : in  std_logic; -- intrare de clock a sistemului
        start      : in std_logic;
        rst        : in std_logic;  -- intrare de resetare a sistemului
        ps2_clk    : in  std_logic; -- semnal de clock de la tastatura ps2
        ps2_data   : in  std_logic; -- semnal de date de la tastatura ps2
        -- semnalele de iesire
        an    : out std_logic_vector (3 downto 0);  -- anozii afisorului
        seg   : out std_logic_vector (7 downto 0);  -- catozii afisorului
        Tx    : out std_logic;
        TxRdy : out std_logic);
end modulul_principal;

architecture behavioral of modulul_principal is

signal ps2_code_new : std_logic;                    -- flag care indica transmisia unui nou cod din componenta ps2_keyboard
signal ps2_code     : std_logic_vector(7 downto 0); -- codul transmis de catre componenta ps2_keyboard
signal ascii_code   : std_logic_vector(7 downto 0); -- codul de scanare translatat in cod ascii

signal startD       : std_logic; -- semnalul butonului de start dupa debounce
signal resetD       : std_logic; -- semnalul butonului de reset dupa debounce
                                   
begin

    -- se instantiaza logica interfetei ps2 cu tastatura
    kb:  entity work.ps2_keyboard
        generic map(clk_freq => clk_freq, debounce_counter_size => ps2_debounce_counter_size)
        port map(
            clk => clk,
            ps2_clk => ps2_clk,
            ps2_data => ps2_data,
            ps2_code_new => ps2_code_new,
            ps2_code => ps2_code);
            
        s2a:  entity work.scan2ascii
        port map(
            ps2_code => ps2_code,
            ascii_code => ascii_code);
    
    -- maparea pentru modulul transmitatorului serial
    uart_tx: entity WORK.uart_tx
        generic map (BitRate => 9_600)
        port map (Clk => clk,
            Rst => resetD,
            TxData => ascii_code,
            Start => startD,
            Tx => Tx,
            TxRdy => TxRdy);

    -- debounce pentru semnalul butonului de start
    startBtn: entity work.debounce_clasic
    PORT MAP(Clk => clk, Rst => rst, Din => start, Qout => startD);

    -- debounce pentru semnalul butonului de reset
    resetBtn: entity work.debounce_clasic
    PORT MAP(Clk => clk, Rst => rst, Din => rst, Qout => resetD);
    
    -- se instantiaza afisorul de sapte segmente
    ssd: entity work.displ7seg
        port map (
            data => ps2_code,
            an => an,
            seg => seg);
    
end behavioral;