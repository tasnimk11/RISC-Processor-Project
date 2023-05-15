----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 12:59:01
-- Design Name: 
-- Module Name: Test_InstructionMemory_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Test_InstructionMemory_unit is
--  Port ( );
end Test_InstructionMemory_unit;

architecture Behavioral of Test_InstructionMemory_unit  is
    component InstructionMemory_unit
        Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
               CLK : in STD_LOGIC; --Clock
               Data_OUT : out STD_LOGIC_VECTOR (31 downto 0)); --Result of the instruction
    end component;
    
    -- Local Inputs
    signal local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_CLK : STD_LOGIC := '0';

    -- Local Outputs
    signal local_Data_OUT : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
		-- Clock
    constant clock_period : time := 10 ns; -- f = 10^8 HZ = 100 MHz, period = 10 ns
begin

    instance : InstructionMemory_unit port map (
        Addr => local_Addr ,
        CLK => local_CLK,
        Data_OUT => local_Data_OUT
          
    );
			
		-- Clock Process : every half period, invert the clock signal (1->0, O->1)
    CLK_process :process
    begin
        local_CLK <= not(local_CLK );
        wait for clock_period /2;
    end process;
    
    process 
    begin
        local_Addr <= 
          x"00" after 10 ns,    -- TEST 1 : Read
          x"01" after 20 ns,    -- TEST 2 : Read
          x"02" after 30 ns,    -- TEST 3 : Read
          x"03" after 40 ns,    -- TEST 4 : Read
          x"04" after 50 ns;    -- TEST 5 : Read
				
        wait;
    end process;


end Behavioral;
