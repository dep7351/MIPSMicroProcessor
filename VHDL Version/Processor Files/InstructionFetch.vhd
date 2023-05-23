-------------------------------------------------
--  File:          InstructionFetch.vhd
--  Entity:        InstructionFetch
--  Architecture:  Fetch
--  Engineer:      Daniel Pittman
--  Last Modified: 05/23/23
--  Description:   The instruction fetch stage of the MIPS MicroProcessor
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionFetch is
    generic (Bytes : integer := 1023);
    port (
        clk         : in std_logic; -- System Clock
        rst         : in std_logic; -- Active High Reset, Async
        branch      : in std_logic; -- PCSrc Signal, Active High
        branchAmt   : in std_logic_vector(27 downto 0); -- the amount to increment the program counter by
        Instruction : out std_logic_vector(31 downto 0) -- instruction fetched from memory
    );
end entity;

architecture Fetch of InstructionFetch is

    signal addr  : std_logic_vector(27 downto 0);
    signal d_out : std_logic_vector(31 downto 0);
    signal PC    : std_logic_vector(27 downto 0) := (others => '0');

begin

    memory : entity work.InstructionMemory
        generic map (Bytes => bytes)
        port map (addr => addr, d_out => d_out);

    fetchProc : process (clk, rst)
    begin
        if rst = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            if branch = '0' then
                PC <= std_logic_vector(to_unsigned(to_integer(UNSIGNED(PC)) + 4,28));
            else
                PC <= std_logic_vector(to_unsigned(to_integer(UNSIGNED(PC)) + to_integer(UNSIGNED(branchAmt)),28));
            end if;
        end if;
    end process;

    addr <= PC;
    Instruction <= d_out;

end architecture;