----------------------------------------------------------------------------------
--  File:          ALU.vhd
--  Entity:        ALU
--  Architecture:  compute
--  Engineer:      Daniel Pittman
--  Last Modified: 05/26/23
--  Description:   32-bit Arithmetic Logic Unit for MIPS MicroProcessor
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.globals.all;

entity ALU is
    PORT (
            Op1          : IN std_logic_vector(N-1 downto 0);
            Op2          : IN std_logic_vector(N-1 downto 0);
            ALUOp        : IN std_logic_vector(3 downto 0);
            ALUResult    : OUT std_logic_vector(N-1 downto 0);
            Zero         : OUT std_logic);
end ALU;

architecture compute of alu is

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
        port map (A => Op1, SHIFT_AMT => Op2(M-1 downto 0), Y => sll_result);
    
    -- Instantiate the or component
    or_comp: entity work.LOR
        generic map (N => N)
        port map (A => Op1, B => Op2, Y => or_result);

    -- Instantiate the and component
    and_comp: entity work.LAnd
        generic map (N => N)
        port map (A => Op1, B => Op2, Y => and_result);

    -- Instantiate the xor component
    xor_comp: entity work.LXOR
        generic map (N => N)
        port map (A => Op1, B => Op2, Y => xor_result);

    -- Instantiate the slr component
    slr_comp: entity work.SLR
        generic map (N => N, M => M)
        port map (A => Op1, SHIFT_AMT => Op2(M-1 downto 0), Y => slr_result);
    
    -- Instantiate the sar component
    sar_comp: entity work.SAR
        generic map (N => N, M => M)
        port map (A => Op1, SHIFT_AMT => Op2(M-1 downto 0), Y => sar_result);
    
    -- Instantiate the Ripple Carry Component
    RippleAdd : entity work.NRippleCarry
        generic map (N => N)
        port map (A => Op1, B => Op2, OP => ALUOp(0), Sum => Adder_result);
    
    Multiply : entity work.Multiplier
        generic map (N => N)
            port map (A => Op1(N/2-1 downto 0), B => Op2(N/2-1 downto 0), P => Multi_result);
    
    zero_proc : process (all)
    begin
        if Op1 = Op2 then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;

    -- Use OP to control which operation to show/perform
    ALUResult <= sll_result when ALUOp = "1100" else
            slr_result when ALUOp = "1101" else
            sar_result when ALUOp = "1110" else
             or_result when ALUOp = "1000" else
            and_result when ALUOp = "1010" else
          adder_result when ALUOp = "0100" else
          adder_result when ALUOp = "0101" else
            xor_result when ALUOp = "1011" else
          multi_result;
end architecture;