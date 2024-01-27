library ieee;
use ieee.std_logic_1164.all;

entity D_FF is
    port(
        clk : in std_logic;
        rst : in std_logic;
        clr : in std_logic;
        input : in std_logic;
        output : out std_logic;
    );
end entity;