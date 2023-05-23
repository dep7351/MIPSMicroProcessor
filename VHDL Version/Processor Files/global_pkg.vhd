----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Daniel Pittman (dep7351@rit.edu)
-- 
-- Create Date: 01/17/2023
-- Design Name: globals
-- Module Name: globals - package (library)
-- Project Name: Intro to Vivado and Simple ALU
-- Target Devices: Dasys3 
-- 
-- Description: Constants used in top and test bench level Xilinx
--              does not like generics in the top level of a design
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
package globals is
    constant N : INTEGER := 32; -- changed from 4 to 32
    constant M : INTEGER := 5; -- changed from 2 to 5
end;
