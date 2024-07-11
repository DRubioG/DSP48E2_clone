library ieee;
use ieee.std_logic_1164.all;

entity MUX30 is
    port (
        in1 : in std_logic_vector(29 downto 0);
        in2 : in std_logic_vector(29 downto 0);
        output : out std_logic_vector(29 downto 0);
        sel : in std_logic
    );
end entity;

architecture arch_MUX18 of MUX18 is
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