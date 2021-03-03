library ieee;
use ieee.std_logic_1164.all;

entity scan2ascii is
  port(
      ps2_code   : in std_logic_vector(7 downto 0);
      ascii_code : out std_logic_vector(7 downto 0)); -- ascii value
end scan2ascii;

architecture behavioral of scan2ascii is

begin

    process(ps2_code)
    begin
    
        case ps2_code is
            when x"1c" => ascii_code <= x"41"; --a
            when x"32" => ascii_code <= x"42"; --b
            when x"21" => ascii_code <= x"43"; --c
            when x"23" => ascii_code <= x"44"; --d
            when x"24" => ascii_code <= x"45"; --e
            when x"2b" => ascii_code <= x"46"; --f
			when x"34" => ascii_code <= x"47"; -- g
            when x"33" => ascii_code <= x"48"; -- h
            when x"43" => ascii_code <= x"49"; -- i
            when x"3b" => ascii_code <= x"4a"; -- j
            when x"42" => ascii_code <= x"4b"; -- k
            when x"4b" => ascii_code <= x"4c"; -- l
            when x"3a" => ascii_code <= x"4d"; -- m
            when x"31" => ascii_code <= x"4e"; -- n
            when x"44" => ascii_code <= x"4f"; -- o
            when x"4d" => ascii_code <= x"50"; -- p
            when x"15" => ascii_code <= x"51"; -- q
            when x"2d" => ascii_code <= x"52"; -- r
            when x"1b" => ascii_code <= x"53"; -- s
            when x"2c" => ascii_code <= x"54"; -- t
            when x"3c" => ascii_code <= x"55"; -- u
            when x"2a" => ascii_code <= x"56"; -- v
            when x"1d" => ascii_code <= x"57"; -- w
            when x"22" => ascii_code <= x"58"; -- x
            when x"35" => ascii_code <= x"59"; -- y
            when x"1a" => ascii_code <= x"5a"; -- z
            when x"45" => ascii_code <= x"30"; --0
            when x"16" => ascii_code <= x"31"; --1
            when x"1e" => ascii_code <= x"32"; --2
            when x"26" => ascii_code <= x"33"; --3
            when x"25" => ascii_code <= x"34"; --4
            when x"2e" => ascii_code <= x"35"; --5
            when x"36" => ascii_code <= x"36"; --6
            when x"3d" => ascii_code <= x"37"; --7
            when x"3e" => ascii_code <= x"38"; --8
            when x"46" => ascii_code <= x"39"; --9
            when others => ascii_code <= x"20"; -- blank space
        end case;
            
  end process;

end behavioral;



