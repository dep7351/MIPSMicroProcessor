-------------------------------------------------
--  File:          InstructionFetchTB.vhd
--
--  Entity:        InstructionFetchTB
--  Architecture:  BEHAVIORAL
--  Author:        Jason Blocklove
--  Created:       07/26/19
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 Testbench for Instruction Fetch
--                 Stage
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionFetchTB is
end InstructionFetchTB;

architecture Behavioral of InstructionFetchTB is

type test_vector is record
	rst : std_logic;
	Instruction	 : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
	(rst => '1', Instruction => x"00000000"), -- reset value
	(rst => '0', Instruction => x"11111111"), 
	(rst => '0', Instruction => x"22222222"), 
	(rst => '0', Instruction => x"1f2e3d4c"),

	-- random test cases from pre-lab
	(rst => '0', Instruction => x"1f233333"),
	(rst => '0', Instruction => x"00000000"),
	(rst => '0', Instruction => x"21111111"),
	(rst => '0', Instruction => x"12222222"),
	(rst => '0', Instruction => x"12f3e4da"),

	-- more random test cases for part 1 
	(rst => '0', Instruction => x"ffffffff"),
	(rst => '0', Instruction => x"eeeeeeee"),
	(rst => '0', Instruction => x"dddddddd"),
	
	-- more specific test cases for part 1 to test bounds
	(rst => '0', Instruction => x"00000000"),
	(rst => '0', Instruction => x"00000000") -- this is out of bounds

);

component InstructionFetch
  port (
    clk : in std_logic;
    rst : in std_logic;
    Instruction : out std_logic_vector(31 DOWNTO 0)
  );
end component;

	signal rst : std_logic;
	signal clk : std_logic;
	signal instruction : std_logic_vector(31 downto 0);

	constant smallbytes : integer := 51;
	

begin

uut : InstructionFetch
	port map (
    	clk => clk,
    	rst => rst,
    	Instruction => Instruction
	);

clk_proc:process
begin
	clk <= '0';
	wait for 50 ns;
	clk <= '1';
	wait for 50 ns;
end process;

stim_proc:process
begin
  rst <= '1'; -- this happens asynchronously
  wait until clk='1'; -- pc should be reset by this point
  wait until clk='0';

	for i in test_vector_array'range loop
		rst <= test_vector_array(i).rst;
		wait until clk='0';
		assert (Instruction = test_vector_array(i).instruction) report "Error in the Instruction Fetch Stage. The instruction should have been " 
		       & to_hstring(unsigned(test_vector_array(i).instruction)) & " instead the instruction retrieved was " & to_hstring(instruction) & "!" severity Error;
		
	end loop;
	wait until clk='0';

	assert false
		report "Testbench Concluded"
		severity failure;


end process;

end Behavioral;
