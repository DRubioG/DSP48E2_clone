library ieee;
use ieee.std_logic_1164.all;

entity Z is
    port (
        in1 : in std_logic_vector( downto 0);
        in2 : in std_logic_vector( downto 0);
        in3 : in std_logic_vector( downto 0);
        in4 : in std_logic_vector( downto 0);
        in5 : in std_logic_vector( downto 0);
        in6 : in std_logic_vector( downto 0);
        mux_in : in std_logic_vector(2 downto 0);
        output : out std_logic_vector( downto 0)
    );
end entity;

architecture arch_Z of Z is

begin

    output <= in1 when mux_in = "000" else
              in2 when mux_in = "001" else
              in3 when mux_in = "010" else
              in4 when mux_in = "011" else
              in5 when mux_in = "100" else
              in6 when mux_in = "101";  

end architecture;