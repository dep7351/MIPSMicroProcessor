library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity MultiplierTB is
end entity;

architecture TB of MultiplierTB is

    type test_vector is record
        A : std_logic_vector(N/2-1 downto 0);
        B : std_logic_vector(N/2-1 downto 0);
        P : std_logic_vector(N-1 downto 0);
    end record;

    type test_array is array (natural range <>) of test_vector;
    constant test_vector_array : test_array := (
        --(x"0123",x"0234",x"0002811C"),
        --(x"2345",x"1345",x"02A7A099"),
        --(x"4567",x"2456",x"09D9CC9A"),
        --(x"6789",x"3567",x"1599051F"),
        --(x"89AB",x"4678",x"25E54A28"),
        --(x"ABCD",x"5789",x"3ABE9BB5"),
        --(x"CDEF",x"689A",x"5424F9C6"),
        --(x"CDEF",x"0000",x"00000000"),
        --(x"FFFF",x"FFFF",x"FFFE0001"),
        --(x"0FFF",x"0FFF",x"00FFE001"),
        (2ux"0",2ux"0",4ux"0"),
        (2ux"0",2ux"1",4ux"0"),
        (2ux"0",2ux"2",4ux"0"),
        (2ux"0",2ux"3",4ux"0"),
        (2ux"1",2ux"1",4ux"1"),
        (2ux"1",2ux"2",4ux"2"),
        (2ux"1",2ux"3",4ux"3"),
        (2ux"2",2ux"2",4ux"4"),
        (2ux"2",2ux"3",4ux"6"),
        (2ux"3",2ux"3",4ux"9")
        );

    signal A : std_logic_vector(N/2-1 downto 0);
    signal B : std_logic_vector(N/2-1 downto 0);
    signal P : std_logic_vector(N-1 downto 0);

begin

    uut : entity work.Multiplier
        generic map(N => N)
        port map (A => A, B => B, P => P);

    stim_proc : process is begin
        for i in test_vector_array'range loop
            A <= test_vector_array(i).A;
            B <= test_vector_array(i).B;
            wait for 50 ns;
            assert (P = test_vector_array(i).P) report "Error in the multiplication result. Value of P was " 
            & to_hstring(P) & " and should have been " & to_hstring(test_vector_array(i).P) & "." severity Error;
            wait for 50 ns;
        end loop;

    assert false report "Testbench Concluded" severity failure;
    end process;

    

end architecture;