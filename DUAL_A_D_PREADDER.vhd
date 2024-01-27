library ieee;
use ieee.std_logic_1164.all;

entity DUAL_A_D_PREADDER is
    port(
        clk : in std_logic;
        A : in std_logic_vector(29 downto 0);
        ACIN : in std_logic_vector(29 downto 0);
        D : in std_logic_vector(26 downto 0);
        CEA1 : in std_logic;
        CEA2 : in std_logic;
        CED : in std_logic;
        CEAD : in std_logic;
        RSTA : in std_logic;
        RSTD : in std_logic;
        INMODE : in std_logic_vector(4 downto 0);
        ACOUT : out std_logic_vector(29 downto 0);
        XMUX : out std_logic_vector(29 downto 0);
        AMULT : out std_logic_vector(26 downto 0)
    );      
end entity;

architecture arch_DUAL_A_D_PREADDER of DUAL_A_D_PREADDER is
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

signal A1_out, A2_out : std_logic_vector(29 downto 0);
signal D_out, AD_out : std_logic_vector(26 downto 0);
signal MUX_INMODE_out : std_logic_vector(29 downto 0);
signal A2A1 : std_logic_vector(26 downto 0);
begin

A1 : D_FF
    generic map (
        N => 30
    )
    port map(
        clk => clk,
        rst => RSTA
        ce => CEA1,
        input => ,
        output => A1_out
    );

A2 : D_FF
    generic map (
        N => 30
    )
    port map(
        clk => clk,
        rst => RSTA
        ce => CEA1,
        input => ,
        output => A2_out
    );
D : D_FF
    generic map (
        N => 27
    )
    port map(
        clk => clk,
        rst => RSTD
        ce => CED,
        input => ,
        output => D_out
    );

AD : D_FF
    generic map (
        N => 27
    )
    port map(
        clk => clk,
        rst => RSTD
        ce => CEAD,
        input => ,
        output => AD_out
    );

MUX_INMODE_0 : MUX
    generic map(
        N => 30
    )
    port map (
        in1 => ,
        in2 => A1_out,
        output => MUX_INMODE_out,
        sel => INMODE(0)
    );

A2A1 <= MUX_INMODE_out and not INMODE(1);


end architecture;