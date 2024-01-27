library ieee;
use ieee.std_logic_1164.all;

entity DUAL_B_REGISTER is
    port(
        clk : in std_logic;
        B : in std_logic_vector(17 downto 0);
        BCIN : in std_logic_vector(17 downto 0);
        BCOUT : out std_logic_vector(17 downto 0);
        XMUX : out std_logic_vector(17 downto 0);
        BMULT : out std_logic_vector(17 downto 0);

        CEB1 : in std_logic;
        RSTB : in std_logic;
        CEB2 : in std_logic;
        INMODE :  in std_logic_vector(4 downto 0);
    );
end entity;

architecture arch_DUAL_B_REGISTER of DUAL_B_REGISTER is
    component D_FF18 is
        port(
            clk : in std_logic;
            rst : in std_logic;
            ce : in std_logic;
            input : in std_logic_vector(17 downto 0);
            output : out std_logic_vector(17 downto 0)
        );
    end component;

    component MUX18 is
        port (
            in1 : in std_logic_vector(17 downto 0);
            in2 : in std_logic_vector(17 downto 0);
            output : out std_logic_vector(17 downto 0);
            sel : in std_logic
        );
    end component;

signal B1_out, B2_out : std_logic_vector(17 downto 0);
signal B2B1 : std_logic_vector(17 downto 0);
signal mux_inmode_4_out : std_logic_vector(17 downto 0);

begin

B1 : D_FF18 
    port map(
        clk => clk,
        rst => RSTB,
        ce => CEB1,
        input => ,
        output => B1_out
    );
    

B2 : D_FF18 
    port map(
        clk => clk,
        rst => RSTB,
        ce => CEB2,
        input => ,
        output => B2_out
    );

MUX_INMODE_4:  MUX18 
        port map (
            in1 => 
            in2 => B1_out,
            output => mux_inmode_4_out,
            sel => INMODE(4)
        );

    B2B1 <= not INMODE(1) and mux_inmode_4_out;

end architecture;