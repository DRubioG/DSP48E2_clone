library ieee;
use ieee.std_logic_1164.all;

entity CARRYINSEL is
    port(
        clk : in std_logic;
        CARRYIN : in std_logic;
        CARRYCASCIN : in std_logic;
        CARRYCASCOUT : in std_logic;
        CECARRYIN : in std_logic;
        RSTALLCARRYIN : in std_logic;
        CEM : in std_logic;
        P : in std_logic;
        PCIN : in std_logic;
        CARRYINSEL : in std_logic;
        CIN : out std_logic
    );
end entity;

architecture arch_CARRYINSEL of CARRYINSEL is
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
begin
    

A1 : D_FF
    generic map (
        N => 1
    );
    port map(
        clk => clk,
        rst => RSTA
        ce => CECARRYIN,
        input => CARRYIN,
        output => A1_out
    );

A1 : D_FF
    generic map (
        N => 1
    );
    port map(
        clk => clk,
        rst => RSTALLCARRYIN
        ce => CEM,
        input => ,
        output => A1_out
    );


    process(CARRYINSEL)
    begin
        case CARRYINSEL is
            when "000" => CIN <= ;
            when "001" => CIN <= PCIN;
            when "010" => CIN <= CARRYCASCIN;
            when "011" => CIN <= not PCIN;
            when "100" => CIN <= CARRYCASCOUT;
            when "101" => CIN <= P;
            when "110" => CIN <= ;
            when "111" => CIN <= not P;
        end case;
    end process;
end architecture;