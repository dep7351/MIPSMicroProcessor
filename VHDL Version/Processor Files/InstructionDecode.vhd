library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionDecode is
    generic (
        BIT_DEPTH : integer := 32;
		LOG_PORT_DEPTH : integer := 5
    );
    port (
        clk          : in std_logic;                       -- the system clock
        instruction  : in std_logic_vector(31 downto 0);   -- the instruction being decoded
        RegWriteAddr : in std_logic_vector(4 downto 0);    -- the address of the register being written to
        RegWriteData : in std_logic_vector(31 downto 0);   -- the data to be written to the register file
        RegWriteEn   : in std_logic;                       -- Register File Write Enable
        RegWrite     : out std_logic;                      -- Set if the instruction requires register writing
        MemtoReg     : out std_logic;                      -- Set if the instruction requires reading from memory
        MemWrite     : out std_logic;                      -- Set if the instruction requires writing to memory
        ALUControl   : out std_logic_vector(3 downto 0);   -- Op-code specific to the ALU
        ALUSrc       : out std_logic;                      -- Set if the ALU will use an immediate
        RegDst       : out std_logic;                      -- Determines which register will be the destination register
        RD1          : out std_logic_vector(31 downto 0);  -- Register File Output 1
        RD2          : out std_logic_vector(31 downto 0);  -- Register File Output 2
        RtDest       : out std_logic_vector(4 downto 0);   -- Address of Rt from instruction
        RdDest       : out std_logic_vector(4 downto 0);   -- Address of Rd from instruction
        ImmOut       : out std_logic_vector(31 downto 0)); -- sign-extended immediate for I-type instructions
end entity;

architecture Decode of InstructionDecode is

begin
    ControlUnit : entity work.ControlUnit
    port map (
        Opcode => instruction(31 downto 26), Funct => instruction(5 downto 0), RegWrite => RegWrite, MemtoReg => MemtoReg, 
        MemWrite => MemWrite, ALUControl => ALUControl, ALUSrc => ALUSrc, RegDst => RegDst);
    
    RegisterFile : entity work.RegisterFile
    port map (clk_n => clk, we => RegWriteEn, Addr1 => instruction(25 downto 21), Addr2 => instruction(20 downto 16), 
        Addr3 => RegWriteAddr, wd => RegWriteData, RD1 => RD1, RD2 => RD2);

    ImmExtProc : process (instruction)
    begin
        if instruction(15) = '1' then
            ImmOut <= x"FFFF" & instruction(15 downto 0);
        else
            ImmOut <= x"0000" & instruction(15 downto 0);
        end if;
    end process;

    RtDest <= instruction(20 downto 16);
    RdDest <= instruction(15 downto 11);

    

end architecture;