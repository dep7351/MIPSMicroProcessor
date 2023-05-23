library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity WriteBackStageTB is
end entity;

architecture TB of WriteBackStageTB is
    signal WriteReg, WriteRegOut : std_logic_vector(M-1 downto 0);
    signal RegWrite, MemToReg, RegWriteOut : std_logic;
    signal ALUResult, ReadData, Result : std_logic_vector(N-1 downto 0);
begin

    uut : entity work.WriteBackStage
        port map (writeReg => writeReg, RegWrite => RegWrite, MemToReg => MemToReg, 
            ALUResult => ALUResult, ReadData => ReadData, Result => Result, 
            WriteRegOut => WriteRegOut, RegWriteOut => RegWriteOut);

    stimulus : process
    begin
        writeReg <= "00000";
        wait for 20 ns;
        assert (writeRegOut = "00000") report "<WriteRegOut Failed at 20 ns" severity error;
        writeReg <= "11111";
        wait for 20 ns;
        assert (WriteRegOut = "11111") report "WriteRegOut Failed at 40 ns" severity error;
        
        RegWrite <= '0';
        wait for 20 ns;
        assert (RegWriteOut = '0') report "RegWriteOut failed at 60 ns" severity error;
        RegWrite <= '1';
        wait for 20 ns;
        assert (RegWriteOut = '1') report "RegWriteOut failed at 80 ns" severity error;

        MemToReg  <= '0';
        ALUResult <= 32ux"0";
        ReadData  <= 32sx"F";

        wait for 20 ns;
        assert (Result = 32ux"0") report "Result failed with reg = 0 at 100 ns" severity error;

        MemToReg <= '1';

        wait for 20 ns;
        assert (Result = 32sx"F") report "Result failed with mem = FFFFFFFF at 120 ns" severity error;
        
        MemToReg <= '0';
        ALUResult <= 32x"55555555";
        ReadData <= 32x"AAAAAAAA";

        wait for 20 ns;
        assert (Result = 32x"55555555") report "Result failed with reg = 55555555 at 140 ns" severity error;

        MemToReg <= '1';
        wait for 20 ns;
        assert (Result = 32x"AAAAAAAA") report "Result failed with mem = AAAAAAAA at 160 ns" severity error;
        
        assert false report "testbench complete" severity failure;
        
    end process;
end architecture;