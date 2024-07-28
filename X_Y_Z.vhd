library ieee;
use ieee.std_logic_1164.all;

entity X_Y_Z is
    port(
        PCOUT_in : in std_logic_vector(46 downto 0);
        A_B_in : in std_logic_vector(46 downto 0);
        M_in : in std_logic_vector(46 downto 0);
        C_in : in std_logic_vector(46 downto 0);
        PCIN_in : in std_logic_vector(46 downto 0);
        P_in : in std_logic_vector(46 downto 0);
        opmode_in : in std_logic_vector(6 downto 0);
        X_out : out std_logic_vector(46 downto 0);
        Y_out : out std_logic_vector(46 downto 0);
        Z_out : out std_logic_vector(46 downto 0)
    );
end entity;

architecture arch_X_Y_Z of X_Y_Z is

begin

    X_out <= (others=>'0') when opmode(1 downto 0) = "00" else
             M_in when opmode(3 downto 0) = "0101" else
             P_in when opmode(1 downto 0) = "10" else
             A_B_in when opmode(1 downto 0) = "11";
            

    Y_out <= (others=>'0') when opmode(3 downto 2) = "00" else
             M_in when opmode(3 downto 0) = "0101" else
             (others=>'1') when opmode(3 downto 2) = "10" else
             C_in when opmode(3 downto 2) = "11";

    Z_out <= (others=>'0') when opmode(6 downto 4) = "000" else
             PCIN_in when opmode(6 downto 4) = "001" else
             P_in when opmode(6 downto 4) = "010" else
             C_in when opmode(6 downto 4) = "011" else
             P_in when opmode(6 downto 0) = "1001000" else
             PCIN_in(PCIN_in'range - 17 downto 17) & (others=>PCIN_in(0)) when opmode(6 downto 4) = "101" else
             P_in(P_in'range-17 downto 17) & (others=>P_in(0)) when opmode(6 downto 4) = "110";

end architecture;