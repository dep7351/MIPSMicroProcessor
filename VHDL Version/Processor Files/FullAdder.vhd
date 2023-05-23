library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FullAdder is
    port (
        X        : in std_logic;
        Y        : in std_logic;
        CarryIn  : in std_logic;
        sum      : out std_logic;
        CarryOut : out std_logic);
end entity;

architecture Glory of FullAdder is
begin
    Sum <= (X XOR Y) XOR CarryIn;
    CarryOut <= (CarryIn AND (X XOR Y)) OR (Y AND X);
end architecture;