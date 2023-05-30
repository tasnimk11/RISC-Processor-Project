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

    type t_bank is array (0 to 255) of std_logic_vector(31 downto 0);

    signal memory_bank : t_bank := ( -- Memory Bank : 16 memory entries
                                        
                                        0  => x"06000800", -- AFC R0 x8       (R0 = 0x08)
                                        1  => x"06010400", -- AFC R1 x4       (R1 = 0x04)
                                        2  => x"01020001", -- ADD R2 R0 R1    (R2 = x0c)
                                        3  => x"05030000", -- COP R3 R0       (R3 = x08)
                                        4  => x"04030303", -- MUL R3 R3 R3    (R3 = x40) 
                                        5  => x"02030001", -- SUB R3 R0 R1    (R3 = x04)
                                        6  => x"05000300", -- COP R0 R3       (R0 = x04)
                                     
                                     
                                        others => (others => '0')
                                    ); 

begin

    process 
    begin
        wait until rising_edge(CLK); 
        Data_OUT <=  memory_bank (conv_integer(Addr)) ;
     end process;
    
end Behavioral;
