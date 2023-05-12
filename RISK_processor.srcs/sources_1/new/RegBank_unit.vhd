----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 15:37:38
-- Design Name: 
-- Module Name: RegBank_unit - Behavioral
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


entity RegBank_unit is
    Port ( Addr_A : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register A to Read 
           Addr_B : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register B to Read
           Addr_W : in STD_LOGIC_VECTOR (3 downto 0); --Address of the Register W to write
           W : in STD_LOGIC; --'1' if Write , '0' if Read 
           Data : in STD_LOGIC_VECTOR (7 downto 0); --if Write : Data will be copied to Addr_W 
           RST : in STD_LOGIC; --Reset
           CLK : in STD_LOGIC; --Clock
           QA : out STD_LOGIC_VECTOR (7 downto 0); --Value of Register A
           QB : out STD_LOGIC_VECTOR (7 downto 0)); --Value of Register B
end RegBank_unit;

architecture Behavioral of RegBank_unit is
    type t_bank is array (0 to 15) of std_logic_vector(7 downto 0);
    
    signal register_bank : t_bank := (others => (others => '0')); -- Register Bank : 16 reg 
begin
     -- Synchronous Tasks : Write or RST

   process 
   begin
       
       wait until rising_edge(CLK); 
       
       if (RST = '0') then -- RESET Register Bench
           register_bank  <= (others => (others => '0')); 
       else 
           -- Write
           if (W = '1') then
               register_bank (conv_integer(Addr_W)) <= Data ;
           end if;
           
       end if;
       
   end process;
   
  
   -- Asynchronous Task : Simultaneous Register Read
   
   QA <= register_bank  (conv_integer(Addr_A)); -- Read Register A 
   QB <= register_bank  (conv_integer(Addr_B)); -- Read Register B 

    
end Behavioral;
