----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 16:02:28
-- Design Name: 
-- Module Name: TestRegBank_unit - Behavioral
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



entity Test_RegBank_unit is
--  Port ( );
end Test_RegBank_unit;

architecture Behavioral of Test_RegBank_unit is


    component RegBank_unit 
        Port ( Addr_A : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register A to Read 
               Addr_B : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register B to Read
               Addr_W : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register W to write
               W : in STD_LOGIC; --'1' if Write , '0' if Read 
               Data : in STD_LOGIC_VECTOR (7 downto 0); --if Write : Data will be copied to Addr_W 
               RST : in STD_LOGIC; --Reset
               CLK : in STD_LOGIC; --Clock
               QA : out STD_LOGIC_VECTOR (7 downto 0); --Value of Register A
               QB : out STD_LOGIC_VECTOR (7 downto 0)); --Value of Register B
    end component;

    -- Local Inputs
    signal local_Addr_A : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal local_Addr_B : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal local_Addr_W : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal local_W : STD_LOGIC := '0';
    signal local_Data : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_RST : STD_LOGIC := '0';
    signal local_CLK : STD_LOGIC := '0';

    -- Local Outputs
    signal local_QA : STD_LOGIC_VECTOR (7 downto 0);
    signal local_QB : STD_LOGIC_VECTOR (7 downto 0);
    
		-- Clock
    constant clock_period : time := 10 ns; -- f = 10^8 HZ = 100 MHz, period = 10 ns
    
begin

    instance : RegBank_unit port map (
        Addr_A => local_Addr_A,
        Addr_B => local_Addr_B,
        Addr_W => local_Addr_W,
        W => local_W,
        Data => local_Data,
        RST => local_RST,
        CLK => local_CLK,
        QA => local_QA,
        QB => local_QB
    );
			
		-- Clock Process : every half period, invert the clock signal (1->0, O->1)
    CLK_process :process
    begin
        local_CLK <= not(local_CLK );
        wait for clock_period /2;
    end process;
    
    process 
    begin
				
        -- Reset registers
        local_RST <= 
            '1' after 0 ns,      
            '0' after 100 ns;    -- TEST : RESET


        -- Write Control to registers
        local_W <= 
            '1' after 10 ns,     -- TEST : WRTIE * 4
            '0' after 50 ns;     -- TEST : Read  * 4

        local_Addr_W <= 
            x"1" after 10 ns,    -- TEST 1 : Write
            x"3" after 20 ns,    -- TEST 2 : Write  
            x"4" after 30 ns,    -- TEST 3 : Write
            x"F" after 40 ns;    -- TEST 4 : Write

		

        local_Data <= 
            x"01" after 10 ns,    -- TEST 1 : Write
            x"03" after 20 ns,    -- TEST 2 : Write  
            x"04" after 30 ns,    -- TEST 3 : Write
            x"0F" after 40 ns;    -- TEST 4 : Write
				
				
        -- Read Conrol from registers
        local_Addr_A <= 
            x"1" after 60 ns,    -- TEST 1 : Read
            x"3" after 70 ns,    -- TEST 2 : Read  
            x"4" after 80 ns,    -- TEST 3 : Read
            x"F" after 90 ns;    -- TEST 4 : Read



        local_Addr_B <= 
            x"1" after 60 ns,    -- TEST 1 : Read
            x"3" after 70 ns,    -- TEST 2 : Read  
            x"4" after 80 ns,    -- TEST 3 : Read
            x"F" after 90 ns;    -- TEST 4 : Read
        
        wait;
    end process;
    
end Behavioral;
