-------------------------------------------------
--  File:          RegisterFile.vhd
--  Entity:        RegisterFile
--  Architecture:  Registers
--  Engineer:      Daniel Pittman
--  Last Modified: 05/23/23
--  Description:   The register file component
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity RegisterFile is
	GENERIC(
		BIT_DEPTH : integer := 32;
		LOG_PORT_DEPTH : integer := 5
	);
	PORT (
		clk_n	: in std_logic; -- clock signal. Falling edge triggered.
		we		: in std_logic; -- write enable
		Addr1	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --address to read from 1
		Addr2	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --address to read from 2
		Addr3	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); -- address to write to
		wd		: in std_logic_vector(BIT_DEPTH-1 downto 0); --Data to be written to the appropriate register
		RD1		: out std_logic_vector(BIT_DEPTH-1 downto 0); --Read from Addr1
		RD2		: out std_logic_vector(BIT_DEPTH-1 downto 0) --Read from Addr2
	);
end RegisterFile;

architecture registers of RegisterFile is

    type RegisterFile is array (0 to 2**LOG_PORT_DEPTH) of std_logic_vector(BIT_DEPTH - 1 downto 0);

    signal RegFile : RegisterFile := (others => (others => '0'));

begin
    
    writeProc: process (clk_n)
    begin
        if falling_edge(clk_n) then
            if we = '1' then
                if Addr3 /= "00000" then
                    RegFile(to_integer(unsigned(Addr3)))<= wd;
                end if;
            end if;
        end if;
    end process;

    RD1 <= RegFile(to_integer(unsigned(Addr1)));
    RD2 <= RegFile(to_integer(unsigned(Addr2)));
    

end architecture;