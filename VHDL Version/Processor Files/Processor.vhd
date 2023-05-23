library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity Processor is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        WriteData : out std_logic_vector(N-1 downto 0);
        ALUResult : out std_logic_vector(N-1 downto 0));
end entity;

architecture HolySpirit of Processor is
    --InstructionFetch
    signal InstructionIF : std_logic_vector(31 downto 0); -- instruction fetched from memory

    --InstructionDecode
    signal InstructionID  : std_logic_vector(31 downto 0) := (others => '0');  -- instruction fetched from memory
    signal RegWriteAddrID : std_logic_vector(4 downto 0) := (others => '0');   -- the address of the register being written to
    signal RegWriteDataID : std_logic_vector(31 downto 0) := (others => '0');  -- the data to be written to the register file
    signal RegWriteEnID   : std_logic := '0';                      -- Register File Write Enable
    signal RegWriteID     : std_logic := '0';                      -- Set if the instruction requires register writing
    signal MemtoRegID     : std_logic := '0';                      -- Set if the instruction requires reading from memory
    signal MemWriteID     : std_logic := '0';                      -- Set if the instruction requires writing to memory
    signal ALUControlID   : std_logic_vector(3 downto 0) := (others => '0');   -- Op-code specific to the ALU
    signal ALUSrcID       : std_logic := '0';                      -- Set if the ALU will use an immediate
    signal RegDstID       : std_logic := '0';                      -- Determines which register will be the destination register
    signal RD1ID          : std_logic_vector(31 downto 0) := (others => '0');  -- Register File Output 1
    signal RD2ID          : std_logic_vector(31 downto 0) := (others => '0');  -- Register File Output 2
    signal RtDestID       : std_logic_vector(4 downto 0) := (others => '0');   -- Address of Rt from instruction
    signal RdDestID       : std_logic_vector(4 downto 0) := (others => '0');   -- Address of Rd from instruction
    signal ImmOutID       : std_logic_vector(31 downto 0) := (others => '0');  -- sign-extended immediate for I-type instructions

    --ExecuteStage
    signal RegWriteEX     : std_logic := '0';                      -- determines whether the instruction being processed writes to a register
    signal MemToRegEX     : std_logic := '0';                      -- determines whether the instruction being processed reads from memory
    signal MemWriteEX     : std_logic := '0';                      -- determines whether the instruction being processed writes to memory
    signal ALUControlEX   : std_logic_vector(3 downto 0) := (others => '0');   -- The ALU Opcode
    signal ALUSrcEX       : std_logic := '0';                      -- If set then the ALU uses the immediate, otherwise it uses two registers
    signal RegDstEX       : std_logic := '0';                      -- Determines which register is the destination register of the instruction
    signal RegSrcAEX      : std_logic_vector(N-1 downto 0) := (others => '0'); -- Data stored in the first register being read
    signal RegSrcBEX      : std_logic_vector(N-1 downto 0) := (others => '0'); -- Data stored in the second register being read
    signal RtDestEX       : std_logic_vector(M-1 downto 0) := (others => '0'); -- Address of rt in the instruction
    signal RdDestEX       : std_logic_vector(M-1 downto 0) := (others => '0'); -- Address of rd in the instruction
    signal SignImmEX      : std_logic_vector(N-1 downto 0) := (others => '0'); -- The sign extended immediate of the instruction
    signal RegWriteOutEX  : std_logic := '0';                      -- Control bit passthrough
    signal MemToRegOutEX  : std_logic := '0';                      -- Control bit passthrough
    signal MemWriteOutEX  : std_logic := '0';                      -- control bit passthrough
    signal ALUResultEX    : std_logic_vector(N-1 downto 0) := (others => '0'); -- The value output by the ALU
    signal WriteDataEX    : std_logic_vector(N-1 downto 0) := (others => '0'); -- The data to be written into memory
    signal WriteRegEX     : std_logic_vector(M-1 downto 0) := (others => '0'); -- The address of the register being written to

    --MemoryStage
    signal RegWriteME        : std_logic := '0';
    signal MemtoRegME        : std_logic := '0';
    signal WriteRegME        : std_logic_vector(M-1 downto 0) := (others => '0');
    signal MemWriteME        : std_logic := '0';
    signal ALUResultME       : std_logic_vector(N-1 downto 0) := (others => '0');
    signal WriteDataME       : std_logic_vector(N-1 downto 0) := (others => '0');
    --signal SwitchesME        : std_logic_vector(15 downto 0); -- not connected
    signal RegWriteOutME     : std_logic := '0';
    signal MemtoRegOutME     : std_logic := '0';
    signal WriteRegOutME     : std_logic_vector(M-1 downto 0) := (others => '0');
    signal MemOutME          : std_logic_vector(N-1 downto 0) := (others => '0');
    signal ALUresultOutME    : std_logic_vector(N-1 downto 0) := (others => '0');
    --signal Active_digitME    : std_logic_vector(3 downto 0); -- not connected
    --signal Seven_Seg_DigitME : std_logic_vector(6 downto 0); -- not connected

    --WriteBackStage
    signal RegWriteWB    : std_logic := '0';
    signal MemToRegWB    : std_logic := '0';
    signal WriteRegWB    : std_logic_vector(M-1 downto 0) := (others => '0');
    signal ALUResultWB   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal ReadDataWB    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal RegWriteOutWB : std_logic := '0';
    signal WriteRegOutWB : std_logic_vector(M-1 downto 0) := (others => '0');
    signal ResultWB      : std_logic_vector(N-1 downto 0) := (others => '0');

begin

    InstructionFetchStage : entity work.InstructionFetch
        port map (clk => clk, rst => reset, Instruction => InstructionIF);

    InstructionDecodeStage : entity work.InstructionDecode
        port map (clk => clk, instruction => InstructionID, RegWriteAddr => RegWriteAddrID, 
        RegWriteData => RegWriteDataID, RegWriteEn => RegWriteEnID, RegWrite => RegWriteID,
        MemToReg => MemToRegID, MemWrite => MemWriteID, ALUControl => ALUControlID, 
        ALUSrc => ALUSrcID, RegDst => RegDstID, RD1 => RD1ID, RD2 => RD2ID, RtDest => RtDestID,
        RdDest => RdDestID, ImmOut => ImmOutID);
    
    ExecuteStage : entity work.ExecuteStage
        port map (RegWrite => RegWriteEX, MemToReg => MemToRegEX, MemWrite => MemWriteEX, 
        ALUControl => ALUControlEX, ALUSrc => ALUSrcEX, RegDst => RegDstEX, RegSrcA => RegSrcAEX,
        RegSrcB => RegSrcBEX, RtDest => RtDestEX, RdDest => RdDestEX, SignImm => SignImmEX,
        RegWriteOut => RegWriteOutEX, MemToRegOut => MemToRegOutEX, MemWriteOut => MemWriteOutEX,
        ALUResult => ALUResultEX, WriteData => WriteDataEX, WriteReg => WriteRegEX);

    MemoryStage : entity work.MemoryStage
        port map (clk => clk, RegWrite => RegWriteME, MemToReg => MemToRegME,
        WriteReg => WriteRegME, MemWrite => MemWriteMe, ALUResult => ALUResultME, 
        WriteData => WriteDataME, RegWriteOut => RegWriteOutME,
        MemToRegOut => MemToRegOutME, WriteRegOut => WriteRegOutME, MemOut => MemOutME,
        ALUResultOut => ALUResultOutME);

    WriteBackStage : entity work.WriteBackStage
        port map (RegWrite => RegWriteWB, MemToReg => MemToRegWB, WriteReg => WriteRegWB,
        ALUResult => ALUResultWB, ReadData => ReadDataWB, RegWriteOut => RegWriteOutWB,
        WriteRegOut => WriteRegOutWB, Result => ResultWB);


    InstructDecodeProc : process(clk)
    begin
        if rising_edge(clk) then
            -- InstructionDecode
            InstructionID  <= InstructionIF;
        end if;
    end process;
    
    ExecuteStageProc : process(clk)
    begin
        if rising_edge(clk) then
            -- Execute Stage
            RegWriteEX   <= RegWriteID;
            MemToRegEX   <= MemToRegID;
            MemWriteEX   <= MemWriteID;
            ALUControlEX <= ALUControlID;
            ALUSrcEX     <= ALUSrcID;
            RegDstEX     <= RegDstID;
            RegSrcAEX    <= RD1ID;
            RegSrcBEX    <= RD2ID;
            RtDestEX     <= RtDestID;
            RdDestEX     <= RdDestID;
            SignImmEx    <= ImmOutID;
        end if;
    end process;
    
    MemoryStageProcess : process(clk)
    begin
        if rising_edge(clk) then
            -- MemoryStage
            RegWriteME  <= RegWriteOutEX;
            MemToRegME  <= MemToRegOutEX;
            WriteRegME  <= WriteRegEX;
            MemWriteME  <= MemWriteOutEx;
            ALUResultME <= ALUResultEX;
            WriteDataME <= WriteDataEx;
            --SwitchesME, Active_Digit, Seven_Seg_Digit left unconnected in upper level
        end if;
    end process;
    
    MEMToWBProces : process(clk)
    begin
        if rising_edge(clk) then
            -- WriteBack
            RegWriteWB  <= RegWriteOutME;
            MemToRegWB  <= MemToRegOutME;
            WriteRegWB  <= WriteRegOutME;
            ALUResultWB <= ALUResultOUtME;
            ReadDataWB  <= MemOutME;
        end if;
    end process;
    
    writeData <= writeDataME; -- upper level signal for writeData from the Memory Stage
    ALUResult <= ResultWB; -- Upper level signal for ALUResult from the Write Back stage
    RegWriteAddrID <= WriteRegOutWB;
    RegWriteDataID <= ResultWB;
    RegWriteEnID   <= RegWriteOutWB;

end architecture;
