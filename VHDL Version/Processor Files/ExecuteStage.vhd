library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity ExecuteStage is
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
        WriteData    : out std_logic_vector(N-1 downto 0); -- The data to be written into memory
        WriteReg     : out std_logic_vector(M-1 downto 0)); -- The address of the register being written to
end entity;

architecture praisedbe of ExecuteStage is
    signal secondOperand : std_logic_vector(N-1 downto 0) := (others => '0');
    signal destination : std_logic_vector(M-1 downto 0) := (others => '0');

begin

    ALU: entity work.ALU
        port map (in1 => RegSrcA , in2 => secondOperand, control => ALUControl, out1 => ALUResult);
    

    secondOp_proc : process(ALUSrc,SignImm,RegSrcB) is begin
        if ALUSrc = '1' then
            secondOperand <= SignImm;
        else
            secondOperand <= RegSrcB;
        end if;
    end process;

    destination_Proc : process(RegDst,RdDest,RtDest) is begin
        if RegDst = '1' then
            destination <= RdDest;
        else
            destination <= RtDest;
        end if;
    end process;
    
    writeData_proc : process(RegSrcB) is begin
        WriteData   <= RegSrcB;
    end process;

    RegWriteOut <= RegWrite;
    MemToRegOut <= MemToReg;
    MemWriteOut <= MemWrite;
    writeReg    <= destination;

end architecture;