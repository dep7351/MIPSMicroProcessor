library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity NRippleCarry is
    generic ( N : integer := 32);
    port (
        A   : in std_logic_vector(N-1 downto 0);
        B   : in std_logic_vector(N-1 downto 0);
        OP  : in std_logic;
        Sum : out std_logic_vector(N-1 downto 0));
end entity;

architecture God of NRippleCarry is
    signal result  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal carrys  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal operand : std_logic_vector(N-1 downto 0) := (others => '0');
begin

    xor_proc: process (B,OP) is begin
        for i in N-1 downto 0 loop
            operand(i) <= (B(i) XOR OP);
        end loop;
    end process;

    FullAdder0 : entity work.FullAdder
        port map (
            X => A(0), Y => operand(0), CarryIn => OP, 
            Sum => result(0), CarryOut => Carrys(0));

    FullAdders : for i in 1 to N-1 generate
    begin
        FullAdder : entity work.FullAdder
            port map (
                X => A(i), Y => operand(i), CarryIn => Carrys(i - 1), 
                Sum => result(i), CarryOut => carrys(i));
    end generate;
    
    sum <= result;

end architecture;