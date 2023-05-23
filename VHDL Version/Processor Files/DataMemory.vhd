library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.globals.all;

entity DataMemory is
    generic (
        width      : integer := 32;
        Addr_Space : integer := 10);
    port (
        clk, w_en   : in std_logic;
        addr        : in std_logic_vector(Addr_Space-1 downto 0);
        d_in        : in std_logic_vector(width-1 downto 0);
        --switches    : in std_logic_vector(15 downto 0);
        d_out       : out std_logic_vector(width-1 downto 0)
        --seven_Seg   : out std_logic_vector(15 downto 0)
        );
end entity;

architecture author of DataMemory is
type mem_array is array (0 to (2**addr_space)-1) of std_logic_vector(width-1 downto 0);

signal mips_mem : mem_array := (others => (others => '0'));

begin

    process (clk,w_en,addr)
    begin
        if rising_edge(clk) then
            if w_en = '1' then
                mips_mem(to_integer(unsigned(addr))) <= d_in;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if falling_edge(clk) then
            d_out <= mips_mem(to_integer(unsigned(addr)));
        end if;
    end process;

   -- process (clk)
   -- begin
     --   if rising_edge(clk) then
       --     if Addr = 10x"3FF" then
       --         if w_en = '1' then
      --              seven_Seg <= d_in(15 downto 0);
       --         end if;
       --     end if;
      --  end if;
   -- end process;

   -- process (clk)
   -- begin
       -- if rising_edge(clk) then
           -- if Addr = 10x"3fe" then
            --    d_out <= 16x"0000" & switches;
            --if else
           -- d_out <= mips_mem(to_integer(unsigned(addr)));
            --end if;
       -- end if;
   -- end process;
   --d_out <= mips_mem(to_integer(unsigned(addr)));
end architecture;