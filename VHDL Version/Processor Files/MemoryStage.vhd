library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity MemoryStage is
    port (
        clk             : in std_logic;
        --rst             : in std_logic;
        RegWrite        : in std_logic;
        MemtoReg        : in std_logic;
        WriteReg        : in std_logic_vector(M-1 downto 0);
        MemWrite        : in std_logic;
        ALUResult       : in std_logic_vector(N-1 downto 0);
        WriteData       : in std_logic_vector(N-1 downto 0);
        --Switches        : in std_logic_vector(15 downto 0);
        RegWriteOut     : out std_logic;
        MemtoRegOut     : out std_logic;
        WriteRegOut     : out std_logic_vector(M-1 downto 0);
        MemOut          : out std_logic_vector(N-1 downto 0);
        ALUresultOut    : out std_logic_vector(N-1 downto 0)
        --Active_digit    : out std_logic_vector(3 downto 0);
        --Seven_Seg_Digit : out std_logic_vector(6 downto 0)
        );
end entity;

architecture WhoAreYou of MemoryStage is
--signal seven_Seg_immediate : std_logic_vector(15 downto 0);
begin

    DataMemory : entity work.DataMemory
        port map (
            clk => clk, w_en => MemWrite, addr => ALUResult(9 downto 0), d_in => WriteData, d_out => MemOut);
            
            --, seven_seg => seven_seg_immediate, switches => switches
    
    --seven_seg_controller : entity work.SevenSegController
        --port map (
            --clk => clk, rst => rst, display_number => seven_seg_immediate, 
            --Active_Segment => Active_digit, led_out => Seven_Seg_Digit);

    RegWriteOut <= RegWrite;
    MemToRegOut <= MemtoReg;
    WriteRegOut <= WriteReg;
    ALUResultOut <= ALUResult;

    

end architecture;