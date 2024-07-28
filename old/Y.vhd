library ieee;
use ieee.std_logic_1164.all;

entity Y is
    port (
        in1 : in std_logic_vector( downto 0);
        in2 : in std_logic_vector( downto 0);
        in3 : in std_logic_vector( downto 0);
        in4 : in std_logic_vector( downto 0);
        mux_in : in std_logic_vector( downto 0);
        output : out std_logic_vector( downto 0);
    );
end entity;

architecture arch_Y  of Y is

begin

    output <= in1 when mux_in = "00" else
              in2 when mux_in = "01" else
              in3 when mux_in = "10" else
              in4;

end architecture;