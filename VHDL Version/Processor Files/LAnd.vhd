------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Daniel Pittman (dep7351@rit.edu)
--
-- Create Date: 1/30/2023
-- Design Name: LAnd
-- Module Name: LAnd - dataflow
-- Project Name: Intro to Vivado and Simple ALU
-- Target Devices: Basys3
--
-- Description: N-bit bitwise AND unit
------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;

entity LAnd is
    GENERIC (N : INTEGER := 32); -- bit width
    PORT (
            A : IN std_logic_vector(N-1 downto 0);
            B : IN std_logic_vector(N-1 downto 0);
            Y : OUT std_logic_vector(N-1 downto 0));
end LAnd;

architecture dataflow of LAnd is
begin
    Y <= A and B;
end dataflow;