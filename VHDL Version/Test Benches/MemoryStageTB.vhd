-------------------------------------------------
--  File:          MemoryStageTB.vhd
--
--  Entity:        MemoryStageTB
--  Architecture:  testbench
--  Author:        Daniel Pittman
--  Created:       04/04/23
--  Modified:
--  VHDL 2008
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for Memory stage
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity MemoryStageTB is
end MemoryStageTB;

architecture testbench of MemoryStageTB is

type test_vector is record
    rst             : std_logic;
	RegWrite        : std_logic; -- determines whether the instruction being processed writes to a register
    MemToReg        : std_logic; -- determines whether the instruction being processed reads from memory
    WriteReg        : std_logic_vector(M-1 downto 0); -- The address of the register being written to
    MemWrite        : std_logic; -- determines whether the instruction being processed writes to memory
    ALUResult       : std_logic_vector(N-1 downto 0); -- The ALU Result
    WriteData       : std_logic_vector(N-1 downto 0); -- The data to be written into memory
    Switches        : std_logic_vector(15 downto 0); -- the switches on the board
    RegWriteOut     : std_logic; -- Control bit passthrough
    MemToRegOut     : std_logic; -- Control bit passthrough
    WriteRegOut     : std_logic_vector(M-1 downto 0); -- The address of the regiter being written to
    MemOut          : std_logic_vector(N-1 downto 0); -- the output from memory
    ALUResultOut    : std_logic_vector(N-1 downto 0); -- result passthrough
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
-- ADD R2, R1, R1 - 000000 00001 00001 00010 00000 100000
    (rst             => '0',
     RegWrite        => '1',
	 MemToReg        => '0',
     WriteReg        => "00010",
	 MemWrite        => '0',
     ALUResult       => x"5D479C89",
     WriteData       => x"6420BDCF",
     Switches        => x"0000",
     RegWriteOut     => '1',
     MemToRegOut     => '0',
     WriteRegOut     => "00010",
     MemOut          => x"00000000",--x"xxxxxxxx",
     ALUResultOut    => x"5D479C89"),
-- ADDI R1, R1, 13 - 001000 00001 00001 0000000000001101
    (rst             => '0',
     RegWrite        => '1',
	 MemToReg        => '0',
     WriteReg        => "00001",
	 MemWrite        => '0',
     ALUResult       => x"000F69BF",
     WriteData       => x"000F69B2",
     Switches        => x"0000",
     RegWriteOut     => '1',
     MemToRegOut     => '0',
     WriteRegOut     => "00001",
     MemOut          => x"00000000",--x"xxxxxxxx",
     ALUResultOut    => x"000F69BF"),
-- SW R5, 24(R8) - 101011 01000 00101 0000000000011000
    (rst             => '0',
     RegWrite        => '0',
	 MemToReg        => '0',
     WriteReg        => "00101",
	 MemWrite        => '1',
     ALUResult       => x"000F76AC",
     WriteData       => x"00000042",
     Switches        => x"0000",
     RegWriteOut     => '0',
     MemToRegOut     => '0',
     WriteRegOut     => "00101",
     MemOut          => x"00000042",
     ALUResultOut    => x"000F76AC"),
-- LW R1, 13(R2) - 100011 00010 00001 0000000000001101
    (rst             => '0',
     RegWrite        => '1',
	 MemToReg        => '1',
     WriteReg        => "00001",
	 MemWrite        => '0',
     ALUResult       => x"000F76AC",
     WriteData       => x"00000000",
     Switches        => x"0000",
     RegWriteOut     => '1',
     MemToRegOut     => '1',
     WriteRegOut     => "00001",
     MemOut          => x"00000042",--x"xxxxxxxx",
     ALUResultOut    => x"000F76AC"),
-- AND R3, R1, R2 - 000000 00001 00010 00011 00000 100100
    (rst             => '0',
     RegWrite        => '1',
	 MemToReg        => '0',
     WriteReg        => "00011",
	 MemWrite        => '0',
     ALUResult       => x"10041000",
     WriteData       => x"15CF9100",
     Switches        => x"0000",--x"xxxx",
     RegWriteOut     => '1',
     MemToRegOut     => '0',
     WriteRegOut     => "00011",
     MemOut          => x"00000000",--x"xxxxxxxx",
     ALUResultOut    => x"10041000"),
-- SW R5, 24(R8) - 101011 01000 00101 0000000000011000 this is the same as before but different data to mess with switches and stuff
     (rst             => '0',
     RegWrite        => '0',
	 MemToReg        => '0',
     WriteReg        => "00101",
	 MemWrite        => '1',
     ALUResult       => x"000003FF",
     WriteData       => x"0000027A",
     Switches        => x"0000",
     RegWriteOut     => '0',
     MemToRegOut     => '0',
     WriteRegOut     => "00101",
     MemOut          => x"0000027A",
     ALUResultOut    => x"000003FF"),
-- LW R1, 13(R2) - 100011 00010 00001 0000000000001101 this is the same as before but different data to mess with switches and stuff
    (rst             => '0',
    RegWrite        => '1',
    MemToReg        => '1',
    WriteReg        => "00001",
    MemWrite        => '0',
    ALUResult       => x"000003FE",
    WriteData       => x"00000000",
    Switches        => x"1234",
    RegWriteOut     => '1',
    MemToRegOut     => '1',
    WriteRegOut     => "00001",
    MemOut          => x"00001234",--x"xxxxxxxx",
    ALUResultOut    => x"000003FE"));

component MemoryStage is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        RegWrite        : in std_logic; -- determines whether the instruction being processed writes to a register
        MemToReg        : in std_logic; -- determines whether the instruction being processed reads from memory
        WriteReg        : in std_logic_vector(M-1 downto 0); -- The address of the register being written to
        MemWrite        : in std_logic; -- determines whether the instruction being processed writes to memory
        ALUResult       : in std_logic_vector(N-1 downto 0); -- The ALU Result
        WriteData       : in std_logic_vector(N-1 downto 0); -- The data to be written into memory
        Switches        : in std_logic_vector(15 downto 0); -- the switches on the board
        RegWriteOut     : out std_logic; -- Control bit passthrough
        MemToRegOut     : out std_logic; -- Control bit passthrough
        WriteRegOut     : out std_logic_vector(M-1 downto 0); -- Control bit passthrough
        MemOut          : out std_logic_vector(N-1 downto 0); -- the output from memory
        ALUResultOut    : out std_logic_vector(N-1 downto 0); -- result passthrough
        Active_digit    : out std_logic_vector(3 downto 0);
        Seven_Seg_Digit : out std_logic_vector(6 downto 0));
end component;

    Signal clk             : std_logic := '0';
    Signal rst             : std_logic := '0';
    Signal RegWrite        : std_logic; -- determines whether the instruction being processed writes to a register
    Signal MemToReg        : std_logic; -- determines whether the instruction being processed reads from memory
    Signal WriteReg        : std_logic_vector(M-1 downto 0); -- The address of the register being written to
    Signal MemWrite        : std_logic; -- determines whether the instruction being processed writes to memory
    Signal ALUResult       : std_logic_vector(N-1 downto 0); -- The ALU Result
    Signal WriteData       : std_logic_vector(N-1 downto 0); -- The data to be written into memory
    Signal Switches        : std_logic_vector(15 downto 0); -- the switches on the board
    Signal RegWriteOut     : std_logic; -- Control bit passthrough
    Signal MemToRegOut     : std_logic; -- Control bit passthrough
    Signal WriteRegOut     : std_logic_vector(M-1 downto 0); -- Control bit passthrough
    Signal MemOut          : std_logic_vector(N-1 downto 0); -- the output from memory
    Signal ALUResultOut    : std_logic_vector(N-1 downto 0); -- result passthrough
    Signal Active_digit    : std_logic_vector(3 downto 0);
    Signal Seven_Seg_Digit : std_logic_vector(6 downto 0);
    constant clk_period    : time := 40 ns;

begin

    clk <= not clk after clk_period/2;

UUT : MemoryStage
	port map (
        clk             => clk,
        rst             => rst,
        RegWrite        => RegWrite,
        MemToReg        => MemToReg,
        WriteReg        => WriteReg,
        MemWrite        => MemWrite,
        ALUResult       => ALUResult,
        WriteData       => WriteData,
        Switches        => Switches,
        RegWriteOut     => RegWriteOut,
        MemToRegOut     => MemToRegOut,
        WriteRegOut     => WriteRegOut,
        MemOut          => MemOut,
        ALUResultOut    => ALUResultOut,
        Active_digit    => Active_digit,
        Seven_Seg_Digit => Seven_Seg_Digit);

stim_proc:process
begin
	for i in test_vector_array'range loop

        wait until clk = '0';

		rst         <= test_vector_array(i).rst;
        RegWrite    <= test_vector_array(i).RegWrite;
        MemToReg    <= test_vector_array(i).MemToReg;
        WriteReg    <= test_vector_array(i).WriteReg;
        MemWrite    <= test_vector_array(i).MemWrite;
        ALUResult   <= test_vector_array(i).ALUResult;
        WriteData   <= test_vector_array(i).WriteData;
        Switches    <= test_vector_array(i).Switches;

    	wait until clk='1';
    	wait for clk_period;
    	wait until clk='1';

		assert (RegWriteOut = test_vector_array(i).RegWriteOut) report "Incorrect RegWriteOut Value. RegWriteOut was " & to_string(RegWriteOut) 
        & " and should have been " & to_string(test_vector_array(i).RegWriteOut) severity error;

		assert (MemtoRegOut = test_vector_array(i).MemtoRegOut) report "Incorrect MemtoRegOut Value. MemToRegOut was " & to_string(MemToRegOut) 
        & " and should have been " & to_string(test_vector_array(i).MemToRegOut) severity error;

        assert (WriteRegOut = test_vector_array(i).WriteRegOut) report "Incorrect WriteRegOut Value. WriteRegOut was " & to_hstring(WriteRegOut)
		& " and should have been " & to_hstring(test_vector_array(i).WriteRegOut) severity error;

		assert (ALUResultOut = test_vector_array(i).ALUResultOut) report "Incorrect ALUResultOut Value. ALUResultOut was " & to_hstring(ALUResultOut) 
		& " and should have been " & to_hstring(test_vector_array(i).ALUResultOut) severity error;
		
		--wait for (2*clk_period);
		
		assert (MemOut = test_vector_array(i).MemOut) report "Incorrect MemOut Value. MemOut was " & to_hstring(MemOut)
		& " and should have been " & to_hstring(test_vector_array(i).MemOut) severity error;
        
        wait until clk = '1';
	end loop;

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end testbench;
