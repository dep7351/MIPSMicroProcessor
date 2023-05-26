-------------------------------------------------
--  File:          ControlUnit.vhd
--  Entity:        ControlUnit
--  Architecture:  control
--  Engineer:      Daniel Pittman
--  Last Modified: 05/23/23
--  Description:   The control unit of the MIPS MicroProcessor
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    port (
        Opcode     : in std_logic_vector(5 downto 0);  -- the opcode of the instruction
        Funct      : in std_logic_vector(5 downto 0);  -- the function of the instruction
        RegWrite   : out std_logic;                    -- Set if the instruction requires register writing
        MemtoReg   : out std_logic;                    -- Set if the instruction requires reading from memory
        MemWrite   : out std_logic;                    -- Set if the instruction requires writing to memory
        ALUControl : out std_logic_vector(3 downto 0); -- Op-code specific to the ALU
        ALUSrc     : out std_logic;                    -- Set if the ALU will use an immediate
        RegDst     : out std_logic);                   -- Determines which register will be the destination register
end entity;

architecture control of ControlUnit is

begin

    RegWriteProc : process (all)
    begin
        if (Opcode = "101011") then -- sw
            RegWrite <= '0';
        else
            RegWrite <= '1';
        end if;
    end process;

    MemtoRegProc : process (all)
    begin
        if (Opcode = "100011") then -- lw
            MemtoReg <= '1';
        else
            MemtoReg <= '0';
        end if;
    end process;

    MemWriteProc : process (all)
    begin
        if (Opcode = "101011") then -- sw
            MemWrite <= '1';
        else
            memWrite <= '0';
        end if;
        
    end process;

    ALUControlProc : process (all)
    begin
        if (Opcode = "000000") then -- R-type section
            case Funct is
                when "100000" => ALUControl <= "0100"; -- ADD
                when "100100" => ALUControl <= "1010"; -- AND
                when "011001" => ALUControl <= "0110"; -- MULTU
                when "100101" => ALUControl <= "1000"; -- OR
                when "000000" => ALUControl <= "1100"; -- SLL
                when "000011" => ALUControl <= "1110"; -- SRA
                when "000010" => ALUControl <= "1101"; -- SRL
                when "100010" => ALUControl <= "0101"; -- SUB
                when  others  => ALUControl <= "1011"; -- XOR
            end case;
        else
            case Opcode is
                when "001000" => ALUControl <= "0100"; -- ADDI
                when "001100" => ALUControl <= "1010"; -- ANDI
                when "001101" => ALUControl <= "1000"; -- ORI
                when "001110" => ALUControl <= "1011"; -- XORI
                when "101011" => ALUControl <= "0100"; -- SW
                when  others  => ALUControl <= "0100"; -- LW
            end case;
        end if;
    end process;

    ALUSrcProc : process (all)
    begin
        if (opcode = "000000") then
            ALUSrc <= '0';
        else
            ALUSrc <= '1';
        end if;
    end process;

    RegDstProc : process (all)
    begin
        if (opcode = "000000") then
            RegDst <= '1';
        else
            RegDst <= '0';
        end if;
    end process;



end architecture;
