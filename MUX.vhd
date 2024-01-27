library ieee;
use ieee.std_logic_1164.all;

entity MUX is
    generic(
        N : integer := 30
    );
    port (
        in1 : in std_logic_vector(N-1 downto 0);
        in2 : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0);
        sel : in std_logic
    );
end entity;

architecture arch_MUX of MUX is
begin
    
    process(in1, in2, sel)
    begin
        case sel is
            when '0' =>
                output <= in1;
            when '1' => 
                output <= in2;
        end case;
    end process;

end architecture;