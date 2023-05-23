library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionFetch is
    generic (Bytes : integer := 1023);
    port (
        clk         : in std_logic; -- System Clock
        rst         : in std_logic; -- Active High Reset, Async
        Instruction : out std_logic_vector(31 downto 0) -- instruction fetched from memory
    );
end entity;

architecture JesusChrist of InstructionFetch is

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
            PC <= std_logic_vector(to_unsigned(to_integer(UNSIGNED(PC)) + 4,28));
        end if;
    end process;

    addr <= PC;
    Instruction <= d_out;

end architecture;