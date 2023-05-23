library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity Multiplier is
    generic (N : integer := 32);
    port (
        A, B   : in std_logic_vector(N/2 - 1 downto 0);
        P      : out std_logic_vector(N-1 downto 0));
end entity;

architecture Hell of Multiplier is
type and_array is array(0 to N/2-1) of std_logic_vector(N/2-1 downto 0);
type adder_array is array (0 to N/2-1) of std_logic_vector(N/2-2 downto 0);
signal and_results : and_array := (others => (others => '0') );
signal carrys : adder_array := (others => (others => '0') );
signal sums : adder_array := (others => (others => '0') );
signal result : Std_logic_vector(N-1 downto 0);
begin

    and_proc : process(A,B) is begin
        for i in 0 to N/2-1 loop -- i represents the ith A column
            for j in 0 to N/2-1 loop -- j represents the jth B Row
                and_results(i)(j) <= A(i) AND B(j); -- notice the results of this are stored in (column)(row) format
            end loop;
        end loop;
    end process;

    generateRow : for j in 0 to N/2-2 generate -- going through jth rows
    begin
        generateColumn : for i in 0 to N/2-1 generate -- going through ith columns
        begin
            generation : if j = 0 generate

                generation2: if i = 0 generate
                    FullAdder_00: entity work.FullAdder -- top right full adder connection
                        port map (X => and_results(i)(j+1), Y => and_results(i+1)(j), CarryIn => '0', Sum => result(j+1), CarryOut => carrys(i)(j));
                elsif i= N/2-1 generate
                    FullAdder_firstrowend: entity work.FullAdder -- end of first row connection
                        port map (X => and_results(i)(j+1), Y => '0', CarryIn => carrys(i-1)(j), Sum => sums(i)(j), CarryOut => carrys(i)(j));
                else generate
                    FullAdder_firstrow: entity work.FullAdder -- generic connection
                        port map (X => and_results(i)(j+1), Y => and_results(i+1)(j), CarryIn => carrys(i-1)(j), Sum => sums(i)(j), CarryOut => carrys(i)(j));
                end generate;
                
            elsif j = N/2-2 generate

                generation3 : if i = N/2-1 generate
                    FullAdder_0j: entity work.FullAdder -- rightmost connection
                        port map (X => and_results(i)(j+1), Y => carrys(i)(j-1), CarryIn => carrys(i-1)(j), Sum => result(j+i+1), CarryOut => result(j+i+2));
                elsif i = 0 generate
                    FullAdder_0j: entity work.FullAdder -- leftmost connection
                        port map (X => and_results(i)(j+1), Y => sums(i+1)(j-1), CarryIn => '0', Sum => result(j+i+1), CarryOut => carrys(i)(j));
                else generate
                    FullAdder_0j: entity work.FullAdder -- generic connection
                        port map (X => and_results(i)(j+1), Y => sums(i+1)(j-1), CarryIn => carrys(i-1)(j), Sum => result(j+i+1), CarryOut => carrys(i)(j));
                end generate;
                    
            else generate

                generation4 : if i = 0 generate
                    FullAdder_0j: entity work.FullAdder -- rightmost connection
                        port map (X => and_results(i)(j+1), Y => sums(i+1)(j-1), CarryIn => '0', Sum => result(j+1), CarryOut => carrys(i)(j));
                elsif i = N/2-1 generate
                    FullAdder_row: entity work.FullAdder -- leftmost connection
                        port map (X => and_results(i)(j+1), Y => carrys(i)(j-1), CarryIn => carrys(i-1)(j), Sum => sums(i)(j), CarryOut => carrys(i)(j));
                else generate
                    FullAdder_row: entity work.FullAdder -- generic connection
                        port map (X => and_results(i)(j+1), Y => sums(i+1)(j-1), CarryIn => carrys(i-1)(j), Sum => sums(i)(j), CarryOut => carrys(i)(j));
                end generate;

            end generate;

        end generate; 

    end generate;
    
    generation5 : if N/2-1 = 1 generate
        result(2) <= sums(1)(0);
        result(3) <= carrys(1)(0);
    end generate;
    
    result(0) <= and_results(0)(0);

    P <= result;
end architecture;