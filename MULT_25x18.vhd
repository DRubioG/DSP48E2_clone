library ieee;
use ieee.std_logic_1164.all;

entity MULT_25x18 is
    port(
        clk : in std_logic;
        input_1 : in std_logic_vector(24 downto 0);
        input_2 : in std_logic_vector(17 downto 0);
        output : out std_logic_vector(47 downto 0)
    );
end entity;

architecture arch_MULT_25x18 of MULT_25x18 is

begin

end architecture;