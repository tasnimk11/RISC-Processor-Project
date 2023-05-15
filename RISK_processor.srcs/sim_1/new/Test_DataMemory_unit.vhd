----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 17:55:12
-- Design Name: 
-- Module Name: Test_DataMemory_unit  - Behavioral
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


entity Test_DataMemory_unit is
--  Port ( );
end Test_DataMemory_unit ;

architecture Behavioral of Test_DataMemory_unit  is
    component DataMemory_unit 
         Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
               Data_IN : in STD_LOGIC_VECTOR (7 downto 0); --Data to write to Memory
               RW : in STD_LOGIC; -- 0 : Write to Memory, 1 : Read from Memory
               RST : in STD_LOGIC; --Reset (resets the memory bank)
               CLK : in STD_LOGIC; --Clock
               Data_OUT : out STD_LOGIC_VECTOR (7 downto 0)); --Data read at Addr
    end component;
    
    -- Local Inputs
    signal local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_Data_IN : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_RW : STD_LOGIC := '0';
    signal local_RST : STD_LOGIC := '0';
    signal local_CLK : STD_LOGIC := '0';

    -- Local Outputs
    signal local_Data_OUT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
		-- Clock
    constant clock_period : time := 10 ns; -- f = 10^8 HZ = 100 MHz, period = 10 ns
begin

    instance : DataMemory_unit port map (
        Addr => local_Addr ,
        Data_IN => local_Data_IN ,
        RW => local_RW,
        Data_OUT => local_Data_OUT,
        RST => local_RST,
        CLK => local_CLK
    );
			
		-- Clock Process : every half period, invert the clock signal (1->0, O->1)
    CLK_process :process
    begin
        local_CLK <= not(local_CLK );
        wait for clock_period /2;
    end process;
    
    process 
    begin
				
        -- Reset data memory
        local_RST <= 
            '1' after 0 ns,      
            '0' after 100 ns;    -- TEST : RESET


        -- Write Control to data memory
        local_RW <= 
            '0' after 10 ns,     -- TEST : WRTIE * 4
            '1' after 50 ns;     -- TEST : Read  * 4


        local_Addr <= 
            x"01" after 10 ns,    -- TEST 1 : Write
            x"03" after 20 ns,    -- TEST 2 : Write  
            x"04" after 30 ns,    -- TEST 3 : Write
            x"0F" after 40 ns,    -- TEST 4 : Write
        
            x"01" after 50 ns,    -- TEST 1 : Read
            x"03" after 60 ns,    -- TEST 2 : Read
            x"04" after 70 ns,    -- TEST 3 : Read
            x"0F" after 80 ns;    -- TEST 4 : Read

        local_Data_IN <= 
            x"01" after 10 ns,    -- TEST 1 : Write
            x"03" after 20 ns,    -- TEST 2 : Write  
            x"04" after 30 ns,    -- TEST 3 : Write
            x"0F" after 40 ns;    -- TEST 4 : Write

	
        wait;
    end process;


end Behavioral;
