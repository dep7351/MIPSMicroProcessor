-------------------------------------------------
--  File:          InstructionMemory.vhd
--  Entity:        InstructionMemory
--  Architecture:  IMemory
--  Engineer:      Daniel Pittman
--  Last Modified: 05/23/23
--  Description:   The instruction memory component of the instruction 
--                 fetch stage of the MIPS MicroProcessor
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
    generic (bytes : integer := 1023);
    port (
        addr : in std_logic_vector(27 downto 0);
        d_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture IMemory of InstructionMemory is

    type instructionMemory is array (0 to bytes) of std_logic_vector(7 downto 0); -- creates a type of memory with 1024 addressable bytes


    -- (others => (others => '0')); 
    signal instructMem : instructionMemory := (x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"20", x"01", x"00", x"01", -- addi $R1,$R0,0x0001  $R1 <= 1
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"20", x"02", x"00", x"01", -- addi $R2,$R0,0x0001  $R2 <= 1
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",             
x"AC", x"01", x"00", x"00", -- SW $R1,0x0($R0)      M[$R0 + 0] <= 1
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"02", x"00", x"01", -- SW $R2,0x1($R0)      M[$R0 + 1] <= 1
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"22", x"08", x"20", -- ADD $R1,$R1,$R2      $R1 <= 2
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"01", x"00", x"02", -- SW $R1,0x2($R0)      M[$R0 + 2] <= 2
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"41", x"10", x"20", -- ADD $R2,$R2,$R1      $R2 <= 3
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"02", x"00", x"03", -- SW $R2,0x3($R0)      M[$R0 + 3] <= 3
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"22", x"08", x"20", -- ADD $R1,$R1,$R2      $R1 <= 5
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"01", x"00", x"04", -- SW $R1,0x4($R0)      M[$R0 + 4] <= 5
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"41", x"10", x"20", -- ADD $R2,$R2,$R1      $R2 <= 8
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"02", x"00", x"05", -- SW $R2,0x5($R0)      M[$R0 + 5] <= 8
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"22", x"08", x"20", -- ADD $R1,$R1,$R2      $R1 <= 13
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"01", x"00", x"06", -- SW $R1,0x6($R0)      M[$R0 + 6] <= 13
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"41", x"10", x"20", -- ADD $R2,$R2,$R1      $R2 <= 21
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"02", x"00", x"07", -- SW $R2,0x7($R0)      M[$R0 + 7] <= 21
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"22", x"08", x"20", -- ADD $R1,$R1,$R2      $R1 <= 34
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"01", x"00", x"08", -- SW $R1,0x8($R0)      M[$R0 + 8] <= 34
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"41", x"10", x"20", -- ADD $R2,$R2,$R1      $R2 <= 55
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"02", x"00", x"09", -- SW $R2,0x9($R0)      M[$R0 + 9] <= 55
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"22", x"08", x"20", -- ADD $R1,$R1,$R2      $R1 <= 89
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"AC", x"01", x"00", x"0A", -- SW $R1,0xA($R0)      M[$R0 + 10] <= 89
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
x"00", x"00", x"00", x"00",
                                               others => (others => '0'));
                                                
begin

    memProc : process (addr)
    begin
        if (to_integer(unsigned(addr)) + 3 >= (bytes + 1) ) then
            d_out <= (others => '0');
        else
            d_out <= instructMem(to_integer(unsigned(addr))) & instructMem(to_integer(unsigned(addr))+1) 
            & instructMem(to_integer(unsigned(addr))+2) & instructMem(to_integer(unsigned(addr))+3);
        end if;
        
    end process;

    

end architecture;
