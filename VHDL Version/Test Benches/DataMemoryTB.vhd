library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity DataMemoryTB is
end entity;

architecture TB of DataMemoryTB is

constant width : integer := 32;
constant addr_Space : integer := 10;
signal clk : std_logic := '0';
signal w_en : std_logic;
signal Addr : std_logic_vector(Addr_Space-1 downto 0);
signal D_in : std_logic_vector(width-1 downto 0);
signal Switches : std_logic_vector(15 downto 0);
signal d_out : std_logic_vector(width-1 downto 0);
signal seven_Seg : std_logic_vector(15 downto 0);

begin

    DataMem : entity work.DataMemory
        port map (
            clk => clk, w_en => w_en, Addr => Addr, D_in => D_in, 
            switches => switches, d_out => d_out, seven_Seg => seven_Seg
        );

    
    clkproc : process
    begin
        clk <= '1';
        wait for 20 ns;
        clk <= '0';
        wait for 20 ns;
    end process;

    stimuli : process
    begin
        wait until clk = '0'; -- write AAAA5555 to 1B
        w_en <= '1';
        Addr <= 10x"1B";
        D_in <= 32x"AAAA5555";

        wait until clk = '0'; -- Write 5555AAAA to 1C
        Addr <= 10x"1C";
        D_in <= 32x"5555AAAA";

        wait until clk = '0'; -- read from 1B
        w_en <= '0';
        Addr <= 10x"1B";

        wait until clk = '1';
        wait for 10 ns;
        assert d_out = 32x"AAAA5555"
            report "addr was " & to_hstring(addr) & " and data read was " 
            & to_hstring(d_out) & ", but addr should have been 1B and data read should have been 0xAAAA5555."
            severity error;
        
        wait until clk = '0'; -- read from 1C
        addr <= 10x"1C";

        wait until clk = '1';
        wait for 10 ns;
        assert d_out = 32x"5555AAAA"
            report "addr was " & to_hstring(addr) & " and data read was " 
            & to_hstring(d_out) & ", but addr should have been 1C and data read should have been 0x5555AAAA."
            severity error;
        
        wait until clk = '0'; -- test switches that are read from memory when Addr = 1022
        w_en <= '0';
        Switches <= 16x"1111";
        addr <= 10x"3FE";
        
        wait until clk = '1';
        wait for 10 ns;
        assert d_out = 32x"00001111"
            report "addr was " & to_hstring(addr) & " and data read was " 
            & to_hstring(d_out) & ", but addr should have been 0x1022 and data read should have been 0x00001111."
            severity error;
        
        wait until clk = '0'; -- test seven segment that recieve the contents of address 1023
        w_en <= '1';
        addr <= 10ux"3FF";
        d_in <= 32ux"3333";

        wait until clk = '1';
        wait for 10 ns;
        assert seven_Seg = 16ux"3333"
            report "addr was " & to_hstring(addr) & " and seven segment was " 
            & to_hstring(seven_Seg) & ", but addr should have been 0x1023 and seven_segment should have been 0x3333."
            severity error;
            
        wait until clk = '0';

        assert false
        report "Testbench Concluded"
        severity failure;

    end process;
    

end architecture;