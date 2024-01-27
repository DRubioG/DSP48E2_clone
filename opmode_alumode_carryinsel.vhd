library ieee;
use ieee.std_logic_1164.all;

entity opmode_alumode_carryinsel is
    port (
        clk : in std_logic;
        OPMODE : in std_logic_vector(8 downto 0);
        CECTRL : in std_logic;
        RSTCTRL : in std_logic;
        ALUMODE : in std_logic_vector(3 downto 0);
        CEALUMODE : in std_logic;
        RSTALUMODE : in std_logic;
        CARRYINSEL : in std_logic_vector(2 downto 0);
        W_X_Y_Z : out std_logic_vector(8 downto 0);
        add_sub : out std_logic_vector(3 downto 0);
        carry_input : out std_logic_vector(2 downto 0)
    );
end entity;

architecture arch_opmode_alumode_carryinsel of opmode_alumode_carryinsel is
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

signal D_FF1_out : std_logic_vector(8 downto 0);
signal D_FF2_out : std_logic_vector(3 downto 0);
signal D_FF3_out : std_logic_vector(2 downto 0);

begin

D_FF1 : D_FF
    generic map (
        N => 9
    );
    port map(
        clk => clk,
        rst => RSTCTRL,
        ce => CECTRL,
        input => OPMODE,
        output => D_FF1_out
    );

D_FF2 : D_FF
    generic map (
        N => 4
    );
    port map(
        clk => clk,
        rst => RSTALUMODE,
        ce => CEALUMODE,
        input => ALUMODE,
        output => D_FF2_out
    );

D_FF3 : D_FF
    generic map (
        N => 3
    );
    port map(
        clk => clk,
        rst => RSTCTRL,
        ce => CECTRL,
        input => CARRYINSEL,
        output => D_FF3_out
    );

MUX1 : MUX
    generic map(
        N => 9
    );
    port map(
        in1 => OPMODE,
        in2 => D_FF1_out,
        output => W_X_Y_Z,
        sel => 
    );

MUX2 : MUX
    generic map(
        N => 4
    );
    port map(
        in1 => ALUMODE,
        in2 => D_FF2_out,
        output => add_sub,
        sel => 
    );

MUX3 : MUX
    generic map(
        N => 3
    );
    port map(
        in1 => CARRYINSEL,
        in2 => D_FF3_out,
        output => carry_input,
        sel => 
    );

end architecture;