----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 16:52:56
-- Design Name: 
-- Module Name: DataMemory_unit - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DataMemory_unit is
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
           Data_IN : in STD_LOGIC_VECTOR (7 downto 0); --Data to write to Memory
           RW : in STD_LOGIC; -- 0 : Write to Memory, 1 : Read from Memory
           RST : in STD_LOGIC; --Reset (resets the memory bank)
           CLK : in STD_LOGIC; --Clock
           Data_OUT : out STD_LOGIC_VECTOR (7 downto 0)); --Data read at Addr
end DataMemory_unit;


architecture Behavioral of DataMemory_unit is
    type t_bank is array (0 to 15) of std_logic_vector(7 downto 0);

    signal memory_bank : t_bank := (others => (others => '0')); -- Memory Bank : 16 memory entries
begin	


    -- Synchronous Tasks : Write

    process 
    begin
        
        wait until rising_edge(CLK); 
        
        if (RST = '0') then -- RESET Register Memory
            memory_bank <= (others => (others => '0')); 
        else 
           
            if (RW = '0') then -- Write to Memory
                memory_bank (conv_integer(Addr)) <= Data_IN;
            end if;
            
        end if;
    
    end process;


    -- Asynchronous Tasks : Read -> otherwise desync reading
    
    Data_OUT <= memory_bank (conv_integer(Addr)); -- Read from Memory
    
end Behavioral;