library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity displ7seg is
    port (
        -- semnalele de intrare
        data : in std_logic_vector(7 downto 0); -- linia de date pentru o cifra (cifra cea mai din dreapta)
        -- semnalele de iesire
        an  : out std_logic_vector (3 downto 0);  -- selectia anodului activ (in cazul acesta este activ anodul 4)
        seg : out std_logic_vector (7 downto 0)); -- selectia catozilor (segmentelor) cifrei active
end displ7seg;

architecture behavioral of displ7seg is

begin

    process(data)
    begin
    
        case data is
            when x"45" => seg <= "00000011"; -- "0"     
            when x"16" => seg <= "10011111"; -- "1" 
            when x"1e" => seg <= "00100101"; -- "2" 
            when x"26" => seg <= "00001101"; -- "3" 
            when x"25" => seg <= "10011001"; -- "4" 
            when x"2e" => seg <= "01001001"; -- "5" 
            when x"36" => seg <= "01000001"; -- "6" 
            when x"3d" => seg <= "00011111"; -- "7" 
            when x"3e" => seg <= "00000001"; -- "8"     
            when x"46" => seg <= "00001001"; -- "9" 
            when x"1C" => seg <= "00010001"; -- a
            when x"32" => seg <= "11000001"; -- b
            when x"21" => seg <= "01100011"; -- c
            when x"23" => seg <= "10000101"; -- d
            when x"24" => seg <= "01100001"; -- e
            when x"2b" => seg <= "01110001"; -- f
            when x"34" => seg <= "01000011"; -- g
            when x"33" => seg <= "11010001"; -- h
            when x"43" => seg <= "11011111"; -- i
            when x"3b" => seg <= "10000111"; -- j
            when x"42" => seg <= "01010001"; -- k
            when x"3a" => seg <= "01010101"; -- l
            when x"4b" => seg <= "11100011"; -- m
            when x"31" => seg <= "11010101"; -- n
            when x"44" => seg <= "11000101"; -- o
            when x"4d" => seg <= "00110001"; -- p
            when x"15" => seg <= "00011001"; -- q
            when x"2d" => seg <= "11110101"; -- r
            when x"1b" => seg <= "01001001"; -- s
            when x"2c" => seg <= "11100001"; -- t
            when x"3c" => seg <= "10000011"; -- u
            when x"2a" => seg <= "11000111"; -- v
            when x"1d" => seg <= "10101001"; -- w
            when x"22" => seg <= "10010001"; -- x
            when x"35" => seg <= "10001001"; -- y
            when x"1a" => seg <= "00100101"; -- z
            when others => seg <= "11111111"; -- toate segmentele stinse
        end case;
        
    end process;
    
    an <= "1110"; -- se activeaza cifra cea mai din dreapta

end behavioral;