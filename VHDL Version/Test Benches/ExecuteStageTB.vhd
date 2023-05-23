-------------------------------------------------
--  File:          ExecuteStageTB.vhd
--
--  Entity:        ExecuteStageTB
--  Architecture:  testbench
--  Author:        Daniel Pittman
--  Created:       03/24/23
--  Modified:
--  VHDL 2008
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for Execute stage
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.globals.all;

entity ExecuteStageTB is
end ExecuteStageTB;

architecture testbench of ExecuteStageTB is

type test_vector is record
	RegWrite     : std_logic; -- determines whether the instruction being processed writes to a register
    MemToReg     : std_logic; -- determines whether the instruction being processed reads from memory
    MemWrite     : std_logic; -- determines whether the instruction being processed writes to memory
    ALUControl   : std_logic_vector(3 downto 0); -- The ALU Opcode
    ALUSrc       : std_logic; -- If set then the ALU uses the immediate, otherwise it uses two registers
    RegDst       : std_logic; -- Determines which register is the destination register of the instruction
    RegSrcA      : std_logic_vector(N-1 downto 0); -- Data stored in the first register being read
    RegSrcB      : std_logic_vector(N-1 downto 0); -- Data stored in the second register being read
    RtDest       : std_logic_vector(M-1 downto 0); -- Address of rt in the instruction
    RdDest       : std_logic_vector(M-1 downto 0); -- Address of rd in the instruction
    SignImm      : std_logic_vector(N-1 downto 0); -- The sign extended immediate of the instruction
    RegWriteOut  : std_logic; -- Control bit passthrough
    MemToRegOut  : std_logic; -- Control bit passthrough
    MemWriteOut  : std_logic; -- control bit passthrough
    ALUResult    : std_logic_vector(N-1 downto 0); -- The value output by the ALU
    WriteData    : std_logic_vector(M-1 downto 0); -- The data to be written into memory
    WriteReg     : std_logic_vector(M-1 downto 0); -- The address of the register being written to
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
-- ADD R2, R1, R1 - 000000 00001 00001 00010 00000 100000
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "0100",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"F926DEBA",
     RegSrcB     => x"6420BDCF",
     RtDest      => "00001",
     RdDest      => "00010",
     SignImm     => x"00001020",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"5D479C89",
     WriteData   => "00001",
     WriteReg    => "00010"),
-- ADDI R1, R1, 13 - 001000 00001 00001 0000000000001101
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "0100",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"000F69B2",
     RegSrcB     => x"000F69B2",
     RtDest      => "00001",
     RdDest      => "00000",
     SignImm     => x"0000000d",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"000F69BF",
     WriteData   => "00001",
     WriteReg    => "00001"),
-- SW R5, 24(R8) - 101011 01000 00101 0000000000011000
    (RegWrite    => '0',
	 MemToReg    => '0',
	 MemWrite    => '1',
	 ALUControl  => "0100",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"000F7694",
     RegSrcB     => x"00000000",
     RtDest      => "00101",
     RdDest      => "00000",
     SignImm     => x"00000018",
     RegWriteOut => '0',
     MemToRegOut => '0',
     MemWriteOut => '1',
	 ALUResult   => x"000F76AC",
     WriteData   => "00101",
     WriteReg    => "00101"),
-- LW R1, 13(R2) - 100011 00010 00001 0000000000001101
    (RegWrite    => '1',
	 MemToReg    => '1',
	 MemWrite    => '0',
	 ALUControl  => "0100",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"000F69B2",
     RegSrcB     => x"00000000",
     RtDest      => "00001",
     RdDest      => "00000",
     SignImm     => x"0000000d",
     RegWriteOut => '1',
     MemToRegOut => '1',
     MemWriteOut => '0',
	 ALUResult   => x"000F69BF",
     WriteData   => "00001",
     WriteReg    => "00001"),
-- AND R3, R1, R2 - 000000 00001 00010 00011 00000 100100
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1010",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"12345678",
     RegSrcB     => x"15CF9100",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001824",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"10041000",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- ANDI R10, R7, 100 - 001100 00111 01010 0000000001100100
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1010",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"13131313",
     RegSrcB     => x"00000000",
     RtDest      => "01010",
     RdDest      => "00000",
     SignImm     => x"00000064",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"00000000",
     WriteData   => "01010",
     WriteReg    => "01010"),
-- OR R3, R1, R2 - 000000 00001 00010 00011 00000 100101
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1000",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"12345678",
     RegSrcB     => x"15CF9100",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001825",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"17FFD778",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- ORI R10, R7, 100 - 001101 00111 01010 0000000001100100
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1000",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"13131313",
     RegSrcB     => x"00000000",
     RtDest      => "01010",
     RdDest      => "00000",
     SignImm     => x"00000064",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"13131377",
     WriteData   => "01010",
     WriteReg    => "01010"),
-- XOR R3, R1, R2 - 000000 00001 00010 00011 00000 100110
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1011",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"12345678",
     RegSrcB     => x"15CF9100",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001826",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"07FBC778",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- XORI R10, R7, 100 - 001110 00111 01010 0000000001100100
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1011",
	 ALUSrc      => '1',
	 RegDst      => '0',
     RegSrcA     => x"13131313",
     RegSrcB     => x"00000000",
     RtDest      => "01010",
     RdDest      => "00000",
     SignImm     => x"00000064",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"13131377",
     WriteData   => "01010",
     WriteReg    => "01010"),
-- SLL R3, R1, R2 - 000000 00001 00010 00011 00000 000000
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1100",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"AF9300D8",
     RegSrcB     => 32ux"1",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001800",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"5F2601B0",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- SRA R3, R1, R2 - 000000 00001 00010 00011 00000 000011
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1110",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"AF9300D8",
     RegSrcB     => 32ux"1",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001803",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"D7C9806C",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- SRL R3, R1, R2 - 000000 00001 00010 00011 00000 000010
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "1101",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"AF9300D8",
     RegSrcB     => 32ux"1",
     RtDest      => "00010",
     RdDest      => "00011",
     SignImm     => x"00001802",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"57C9806C",
     WriteData   => "00010",
     WriteReg    => "00011"),
-- SUB R2, R1, R1 - 000000 00001 00001 00010 00000 100010
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "0101",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"F926DEBA",
     RegSrcB     => x"6420BDCF",
     RtDest      => "00001",
     RdDest      => "00010",
     SignImm     => x"00001022",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"950620EB",
     WriteData   => "00001",
     WriteReg    => "00010"),
-- Multu R2, R1, R1 - 000000 00001 00001 00010 00000 011001
    (RegWrite    => '1',
	 MemToReg    => '0',
	 MemWrite    => '0',
	 ALUControl  => "0110",
	 ALUSrc      => '0',
	 RegDst      => '1',
     RegSrcA     => x"000089AB",
     RegSrcB     => x"00004678",
     RtDest      => "00001",
     RdDest      => "00010",
     SignImm     => x"00001019",
     RegWriteOut => '1',
     MemToRegOut => '0',
     MemWriteOut => '0',
	 ALUResult   => x"25E54A28",
     WriteData   => "00001",
     WriteReg    => "00010")
);

component ExecuteStage is
    port (
        RegWrite     : in std_logic; -- determines whether the instruction being processed writes to a register
        MemToReg     : in std_logic; -- determines whether the instruction being processed reads from memory
        MemWrite     : in std_logic; -- determines whether the instruction being processed writes to memory
        ALUControl   : in std_logic_vector(3 downto 0); -- The ALU Opcode
        ALUSrc       : in std_logic; -- If set then the ALU uses the immediate, otherwise it uses two registers
        RegDst       : in std_logic; -- Determines which register is the destination register of the instruction
        RegSrcA      : in std_logic_vector(N-1 downto 0); -- Data stored in the first register being read
        RegSrcB      : in std_logic_vector(N-1 downto 0); -- Data stored in the second register being read
        RtDest       : in std_logic_vector(M-1 downto 0); -- Address of rt in the instruction
        RdDest       : in std_logic_vector(M-1 downto 0); -- Address of rd in the instruction
        SignImm      : in std_logic_vector(N-1 downto 0); -- The sign extended immediate of the instruction
        RegWriteOut  : out std_logic; -- Control bit passthrough
        MemToRegOut  : out std_logic; -- Control bit passthrough
        MemWriteOut  : out std_logic; -- control bit passthrough
        ALUResult    : out std_logic_vector(N-1 downto 0); -- The value output by the ALU
        WriteData    : out std_logic_vector(M-1 downto 0); -- The data to be written into memory
        WriteReg     : out std_logic_vector(M-1 downto 0) -- The address of the register being written to
    );
end component;

signal RegWrite     : std_logic;
signal MemToReg     : std_logic;
signal MemWrite     : std_logic;
signal ALUControl   : std_logic_vector(3 downto 0);
signal ALUSrc       : std_logic;
signal RegDst       : std_logic;
signal RegSrcA      : std_logic_vector(N-1 downto 0);
signal RegSrcB      : std_logic_vector(N-1 downto 0);
signal RtDest       : std_logic_vector(M-1 downto 0);
signal RdDest       : std_logic_vector(M-1 downto 0);
signal SignImm      : std_logic_vector(N-1 downto 0);
signal RegWriteOut  : std_logic;
signal MemToRegOut  : std_logic;
signal MemWriteOut  : std_logic;
signal ALUResult    : std_logic_vector(N-1 downto 0);
signal WriteData    : std_logic_vector(M-1 downto 0);
signal WriteReg     : std_logic_vector(M-1 downto 0);

begin


UUT : ExecuteStage
	port map (
        RegWrite    => RegWrite,
        MemToReg    => MemToReg,
        MemWrite    => MemWrite,
        ALUControl  => ALUControl,
        ALUSrc      => ALUSrc,
        RegDst      => RegDst,
        RegSrcA     => RegSrcA,
        RegSrcB     => RegSrcB,
        RtDest      => RtDest,
        RdDest      => RdDest,
        SignImm     => SignImm,
        RegWriteOut => RegWriteOut,
        MemToRegOut => MemToRegOut,
        MemWriteOut => MemWriteOut,
        ALUResult   => ALUResult,
        WriteData   => WriteData,
        WriteReg    => WriteReg);

stim_proc:process
begin
	for i in test_vector_array'range loop
		RegWrite   <= test_vector_array(i).RegWrite;
		MemToReg   <= test_vector_array(i).MemToReg;
		MemWrite   <= test_vector_array(i).MemWrite;
		ALUControl <= test_vector_array(i).ALUControl;
        ALUSrc     <= test_vector_array(i).ALUSrc;
        RegDst     <= test_vector_array(i).RegDst;
        RegSrcA    <= test_vector_array(i).RegSrcA;
        RegSrcB    <= test_vector_array(i).RegSrcB;
        RtDest     <= test_vector_array(i).RtDest;
        RdDest     <= test_vector_array(i).RdDest;
        SignImm    <= test_vector_array(i).SignImm;
    	wait for 100 ns;
		assert (RegWriteOut = test_vector_array(i).RegWriteOut) report "Incorrect RegWriteOut Value. RegWriteOut was " & to_string(RegWriteOut) 
        & " and should have been " & to_string(test_vector_array(i).RegWriteOut) severity error;
		assert (MemtoRegOut = test_vector_array(i).MemtoRegOut) report "Incorrect MemtoRegOut Value" severity error;
		assert (MemWriteOut = test_vector_array(i).MemWriteOut) report "Incorrect MemWriteOut Value" severity error;
		assert (ALUResult = test_vector_array(i).ALUResult) report "Incorrect ALUResult Value. ALUResult was " & to_hstring(ALUResult) 
		& " and should have been " & to_hstring(test_vector_array(i).ALUResult) severity error;
		assert (WriteData = test_vector_array(i).WriteData) report "Incorrect WriteData Value" severity error;
		assert (WriteReg = test_vector_array(i).WriteReg) report "Incorrect WriteReg Value. WriteReg was " & to_hstring(WriteReg)
		& " and should have been " & to_hstring(test_vector_array(i).WriteReg) severity error;
        wait for 50 ns;
	end loop;

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end testbench;
