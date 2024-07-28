library ieee;
use ieee.std_logic_1164.all;

entity D_FF is
    generic (
        N : integer := 30
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        input : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture arch_D_FF of D_FF is

begin

    process(clk, rst, clr)
    begin
        if rst = '0' then
            output <= (others=>'0');
        elsif rising_edge(clk) then
            if ce = '1' then
                output <= input;
            end if;
        end if;
    end process;
    
end architecture;