----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 15:16:26
-- Design Name: 
-- Module Name: Test_Pipeline_unit - Behavioral
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

entity Test_Pipeline_unit is
--  Port ( );
end Test_Pipeline_unit;

architecture Behavioral of Test_Pipeline_unit is

    component Pipeline_unit is
        Port ( CLK : in STD_LOGIC; --Clock
               RST : in STD_LOGIC; --Reset
               B_OUT : out STD_LOGIC_VECTOR (7 downto 0) --B_out : TODO : understand use
             );
    end component;    
    
    
    -- Local Inputs
    signal local_CLK : STD_LOGIC := '0';
    signal local_RST : STD_LOGIC := '0';
    
    -- Local Outputs
    signal local_B_OUT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    -- Clock
    constant clock_period : time := 10 ns; -- f = 10^8 HZ = 100 MHz, period = 10 ns

begin

    instance : Pipeline_unit port map (
        CLK => local_CLK,
        RST => local_RST,
        B_OUT => local_B_OUT
    );
    
    
    -- Clock Process : every half period, invert the clock signal (1->0, O->1)
    CLK_process :process
    begin
        local_CLK <= not(local_CLK );
        wait for clock_period /2;
    end process;
    
    
      -- Stimulus process
    stim_proc: process
    begin    
         local_RST <= '1' after 2*clock_period;
         wait for 10*clock_period;
       wait;
    end process;

    
    

end Behavioral;
