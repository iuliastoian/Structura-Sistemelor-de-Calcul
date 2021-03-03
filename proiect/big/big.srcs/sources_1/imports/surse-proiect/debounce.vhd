--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity debounce is
    generic (
        counter_size : integer := 20); -- dimensiunea numaratorului (20 de biti dau un timp de 10.5ms
                                       -- in care intrarea este stabila cu un clock de 100mhz)
    port(
        -- semnalele de intrare
        clk    : in  std_logic;  -- intrare clock 100mhz
        button : in  std_logic;  -- intrare semnal pentru care trebuie facut debounce
        -- semnalul de iesire
        result : out std_logic); -- semnalul pentru care s-a facut debounce
end debounce;

architecture logic of debounce is

signal flipflops   : std_logic_vector(1 downto 0); -- bistabil
signal counter_set : std_logic;                    -- sincronizeaza reset la zero
signal counter_out : std_logic_vector(counter_size downto 0) := (others => '0'); -- iesire numarator
  
begin

    counter_set <= flipflops(0) xor flipflops(1);       -- determina cand sa porneasca/reseteze numaratorul
  
    process(clk)
    begin
    
        if (clk'event and clk = '1') then
            flipflops(0) <= button;
            flipflops(1) <= flipflops(0);
            
            if(counter_set = '1') then                  -- reseteaza numaratorul pentru ca intrarea se schimba
                counter_out <= (others => '0');
            elsif(counter_out(counter_size) = '0') then -- timpul in care intrare este stabila nu s-a scurs inca
                counter_out <= counter_out + 1;
            else                                        -- timpul in care intrarea este stabila s-a scurs
                result <= flipflops(1);
            end if;
        end if;
        
    end process;
  
end logic;
