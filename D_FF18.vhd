library ieee;
use ieee.std_logic_1164.all;

entity D_FF18 is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        input : in std_logic_vector(17 downto 0);
        output : out std_logic_vector(17 downto 0)
    );
end entity;

architecture arch_D_FF18 of D_FF18 is

begin

    process(clk, rst, clr)
    begin
        if rst = '0' then
            output <= (others=>'0');
        elsif ce = '1' then
            if rising_edge(clk) then
                output <= input;
            end if;
        end if;
    end process;
    
end architecture;