----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology (RIT)
-- Engineer: Daniel Pittman (dep7351@rit.edu)
-- 
-- Create Date: 01/17/2023
-- Design Name: alu4
-- Module Name: alu4 - structural
-- Project Name: Intro to Vivado and Simple ALU
-- Target Devices: Dasys3 
-- 
-- Description: Partial 32-bit Arithmetic Logic Unit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.globals.all; -- provides N and M to top level 

entity ALU is
    PORT (
            in1     : IN std_logic_vector(N-1 downto 0);
            in2     : IN std_logic_vector(N-1 downto 0);
            control : IN std_logic_vector(3 downto 0); -- extended Opcode to 4 bits
            out1    : OUT std_logic_vector(N-1 downto 0));
end ALU;

architecture structural of alu is

-- creating signals for each operation to be given the computation result

    signal sll_result   : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1100
    signal or_result    : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1000
    signal and_result   : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1010
    signal xor_result   : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1011
    signal slr_result   : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1101
    signal sar_result   : std_logic_vector(N-1 downto 0) := (others => '0'); -- 1110
    signal Adder_result : std_logic_vector(N-1 downto 0) := (others => '0'); -- 0100/0101
    signal multi_result : std_logic_vector(N-1 downto 0) := (others => '0'); -- 0110
    
begin

    -- Instantiate the SLL unit
    sll_comp: entity work.sllN
        generic map (N => N, M => M)
        port map (A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => sll_result);
    
    -- Instantiate the or component
    or_comp: entity work.LOR
        generic map (N => N)
        port map (A => in1, B => in2, Y => or_result);

    -- Instantiate the and component
    and_comp: entity work.LAnd
        generic map (N => N)
        port map (A => in1, B => in2, Y => and_result);

    -- Instantiate the xor component
    xor_comp: entity work.LXOR
        generic map (N => N)
        port map (A => in1, B => in2, Y => xor_result);

    -- Instantiate the slr component
    slr_comp: entity work.SLR
        generic map (N => N, M => M)
        port map (A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => slr_result);
    
    -- Instantiate the sar component
    sar_comp: entity work.SAR
        generic map (N => N, M => M)
        port map (A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => sar_result);
    
    -- Instantiate the Ripple Carry Component
    RippleAdd : entity work.NRippleCarry
        generic map (N => N)
        port map (A => in1, B => in2, OP => control(0), Sum => Adder_result);
    
    Multiply : entity work.Multiplier
        generic map (N => N)
            port map (A => in1(N/2-1 downto 0), B => in2(N/2-1 downto 0), P => Multi_result);

    -- Use OP to control which operation to show/perform
    out1 <= sll_result when control = "1100" else
            slr_result when control = "1101" else
            sar_result when control = "1110" else
             or_result when control = "1000" else
            and_result when control = "1010" else
          adder_result when control = "0100" else
          adder_result when control = "0101" else
            xor_result when control = "1011" else
          multi_result;
end structural;