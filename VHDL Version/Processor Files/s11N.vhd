----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Daniel Pittman (dep7351@rit.edu)
-- 
-- Create Date: 01/17/2023
-- Design Name: s11N
-- Module Name: s11N - Behavioral
-- Project Name: Intro to Vivado and Simple ALU
-- Target Devices: Dasys3 
-- 
-- Description: N-bit logical left shift (SLL) unit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity sllN is -- note: I accidentally put a one instead of L
    GENERIC (N : INTEGER := 32;      --bit width
             M : INTEGER := 5);     --shift bits
    PORT (
            A         : IN std_logic_vector(N-1 downto 0);
            SHIFT_AMT : IN std_logic_vector(M-1 downto 0);
            Y         : OUT std_logic_vector(N-1 downto 0));
end sllN;

architecture Behavioral of sllN is
 -- create array of vectors to hold each of n shifters
    type shifty_array is array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
    signal aSLL : shifty_array;

begin
    generateSLL: for i in 0 to N-1 generate
        aSLL(i)(N-1 downto i) <= A(N-1-i downto 0);
        left_fill: if i > 0 generate
            aSLL(i)(i-1 downto 0) <= (others => '0');
        end generate left_fill;
    end generate generateSLL;

 -- The value of shift_amt (in binary) determines number of bits A is shifted
 -- Since shift_amt (in decimal) must not exceed n-1 so only M bits are used.
 -- The default or N=4, will require 2 shift bits (M=2), because 2^2 = 4, the Maximum shift.
 -- In all cases, 2^M = N.
 Y <= aSLL(TO_INTEGER(unsigned(SHIFT_AMT))) when
      (TO_INTEGER(unsigned(SHIFT_AMT)) < 32) else (others => '0');

end Behavioral;
