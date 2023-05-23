library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity ProcessorTB is
end entity;

architecture Pandemonium of ProcessorTB is
    signal clk, reset : std_logic := '0';
    signal ALUResult, WriteData : std_logic_vector(N-1 downto 0) := (others => '0');
    constant clk_period : time := 100 ns;

    type test_vector is record
        writeData : std_logic_vector(N-1 downto 0);
        ALUResult : std_logic_vector(N-1 downto 0);
    end record;

    type test_array is array (natural range <>) of test_vector;

    constant test_vector_array : test_array := (
        (WriteData => 0x"00000000", ALUResult => 0x"00000064"),
        (WriteData => 0x"00000064", ALUResult => 0x"000000C8"),
        (WriteData => 0x"000000C8", ALUResult => 0x"00000040"),
        (WriteData => 0x"00000000", ALUResult => 0x"00000080"),
        (WriteData => 0x"00000040", ALUResult => 0x"0000005C"),
        (WriteData => 0x"0000005C", ALUResult => 0x"000000DC"),
        (WriteData => 0x"000000C8", ALUResult => 0x"00000014"),
        (WriteData => 0x"00000000", ALUResult => 0x"00000080"),
        (WriteData => 0x"00000000", ALUResult => 0x"00000001"),
        (WriteData => 0x"00000001", ALUResult => 0x"00000100"),
        (WriteData => 0x"00000001", ALUResult => 0x"00000080"),
        (WriteData => 0x"00000001", ALUResult => 0x"0000006E"),
        (WriteData => 0x"00000014", ALUResult => 0x"00000190"),
        (WriteData => 0x"0000006E", ALUResult => 0x"00000122"),
        (WriteData => 0x"00000122", ALUResult => 0x"00000064"),
        (WriteData => 0x"00000000", ALUResult => 0x"00000122"));
        
        component Processor is 
        port (
            clk   : in std_logic;
            reset : in std_logic;
            WriteData : out std_logic_vector(N-1 downto 0);
            ALUResult : out std_logic_vector(N-1 downto 0));
        end component;
begin

    clk <= not clk after (clk_period/2);

    uut : Processor
        port map (clk => clk, reset => reset, WriteData => WriteData, ALUResult => ALUResult);

    stimulus : process
    begin
        --reset <= '1';
        --wait for clk_period;
        --reset <= '0';
        --wait until clk = '0';
        wait for 3*clk_period;
        for i in 0 to 21 loop --test_vector_array'range
            wait for 3*clk_period; -- wait till the instruction is in the Memory stage before checking the WriteData
            
            --assert (not falling_edge(clk)) or (WriteData'delayed(clk_period/4) = test_vector_array(i).WriteData) report "Error in WriteData Value. WriteData was " & 
            --to_hstring(WriteData) & " and should have been " & to_hstring(test_vector_array(i).WriteData) & "." severity error;
            --assert false report "Assert for WriteData Checked at time " & time'image(now);
            
            wait for clk_period; -- wait till the instruction is in the WB stage before checking the ALUResult

            --assert (not falling_edge(clk)) or (ALUResult'delayed(clk_period/4) = test_vector_array(i).ALUResult) report "Error in ALUResult Value. ALUResult was " & 
            --to_hstring(ALUResult) & " and should have been " & to_hstring(test_vector_array(i).ALUResult) & "." severity error;
            --assert false report "Assert for ALUResult Checked at time " & time'image(now);
            
        end loop;
        wait until clk = '0';
        assert false report "Testbench Concluded" severity Failure;
    end process;
end architecture;