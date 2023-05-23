library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity WriteBackStage is
    port (
        RegWrite    : in std_logic;
        MemToReg    : in std_logic;
        WriteReg    : in std_logic_vector(M-1 downto 0);
        ALUResult   : in std_logic_vector(N-1 downto 0);
        ReadData    : in std_logic_vector(N-1 downto 0);
        RegWriteOut : out std_logic;
        WriteRegOut : out std_logic_vector(M-1 downto 0);
        Result      : out std_logic_vector(N-1 downto 0));
end entity;

architecture back of WriteBackStage is

begin

    process (ReadData, MemToReg, ALUResult)
    begin
        if (MemToReg = '1') then
            Result <= ReadData;
        else
            Result <= ALUResult;
        end if;
    end process;

    WriteRegOut <= WriteReg;
    RegWriteOut <= RegWrite;
    

end architecture;