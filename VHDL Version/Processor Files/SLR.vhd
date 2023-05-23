----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Daniel Pittman (dep7351@rit.edu)
-- 
-- Create Date: 01/30/2023
-- Design Name: SLR
-- Module Name: SLR - Behavioral
-- Project Name: Intro to Vivado and Simple ALU
-- Target Devices: Basys3 
-- 
-- Description: N-bit logical right shift (SLR) unit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity SLR is
    GENERIC (N : INTEGER := 32;      --bit width
             M : INTEGER := 5);     --shift bits
    PORT (
            A         : IN std_logic_vector(N-1 downto 0);
            SHIFT_AMT : IN std_logic_vector(M-1 downto 0);
            Y         : OUT std_logic_vector(N-1 downto 0));
end SLR;

architecture Behavioral of SLR is
 -- create array of vectors to hold each of n shifters
    type shifty_array is array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
    signal aSLR : shifty_array;

begin
    generateSLR: for i in 0 to N-1 generate
        aSLR(i)(N-1-i downto 0) <= A(N-1 downto i);
        right_fill: if i > 0 generate
            aSLR(i)(N-1 downto N-i) <= (others => '0');
        end generate right_fill;
    end generate generateSLR;

 -- The value of shift_amt (in binary) determines number of bits A is shifted
 -- Since shift_amt (in decimal) must not exceed n-1 so only M bits are used.
 -- The default or N=4, will require 2 shift bits (M=2), because 2^2 = 4, the Maximum shift.
 -- In all cases, 2^M = N.
 Y <= aSLR(TO_INTEGER(unsigned(SHIFT_AMT))) when
      (TO_INTEGER(unsigned(SHIFT_AMT)) < 32) else (others => '0');

end Behavioral;
