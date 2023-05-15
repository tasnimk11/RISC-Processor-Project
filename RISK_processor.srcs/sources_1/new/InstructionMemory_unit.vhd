----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 12:37:47
-- Design Name: 
-- Module Name: InstructionMemory_unit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity InstructionMemory_unit is
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
           CLK : in STD_LOGIC; --Clock
           Data_OUT : out STD_LOGIC_VECTOR (31 downto 0)); --Result of the instruction
end InstructionMemory_unit;



architecture Behavioral of InstructionMemory_unit is

    type t_bank is array (0 to 15) of std_logic_vector(31 downto 0);

    signal memory_bank : t_bank := ( -- Memory Bank : 16 memory entries
                                        0 => x"06000000",
                                        1 => x"06010101",
                                        2 => x"06101010",
                                        3 => x"06111000",
                                        4 => x"06111111",
                                        others => (others => '0')
                                    ); 

begin

    process 
    begin
        wait until rising_edge(CLK); 
        Data_OUT <=  memory_bank (conv_integer(Addr)) ;
     end process;
    
end Behavioral;
