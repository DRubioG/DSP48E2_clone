library ieee;
use ieee.std_logic_1164.all;

entity output_port is
    generic (
        N : integer
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        input : in std_logic_vector(N-1 downto 0);
        output : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture arch_output_port of output_port is
    component MUX is
        generic(
            N : integer := 30
        );
        port (
            in1 : in std_logic_vector(N-1 downto 0);
            in2 : in std_logic_vector(N-1 downto 0);
            output : out std_logic_vector(N-1 downto 0);
            sel : in std_logic
        );
    end component;

    component D_FF is
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
    end component;

signal aux : std_logic_vector(N-1 downto 0);
begin

MUX_1 : MUX
        generic(
            N => N
        )
        port (
            in1 => input,
            in2 => aux,
            output => output,
            sel => 
        );

D_FF_1 : D_FF
        generic map(
            N => N
        )
        port map(
            clk => clk,
            rst => rst,
            ce => en,
            input => input,
            output => aux
        );

end architecture;