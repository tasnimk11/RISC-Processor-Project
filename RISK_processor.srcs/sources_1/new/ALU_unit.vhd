----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2023 09:31:41
-- Design Name: 
-- Module Name: ALU_unit - Behavioral
-- Project Name: RISK_processor
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


entity ALU_unit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);        -- Input A ALU     
           B : in STD_LOGIC_VECTOR (7 downto 0);        -- Input B ALU
           Ctrl_ALU : in STD_LOGIC_VECTOR (2 downto 0); -- Operation to be done on A and B
           S : out STD_LOGIC_VECTOR (7 downto 0);       -- Output S ALU
           N : out STD_LOGIC; -- Negative Flag 
           O : out STD_LOGIC;  -- Overflow Flag 
           Z : out STD_LOGIC;   -- Zero Flag 
           C : out STD_LOGIC); -- Carry Flag 
end ALU_unit;

architecture Behavioral of ALU_unit is

    signal A9 :  STD_LOGIC_VECTOR (8 downto 0); -- Add bit to A for carry
    signal B9 :  STD_LOGIC_VECTOR (8 downto 0); -- Add bit to B for carry
    signal Res_ADD :  STD_LOGIC_VECTOR (8 downto 0); -- A+B
    signal Res_SUB :  STD_LOGIC_VECTOR (8 downto 0); -- A-B
    signal Res_MUL :  STD_LOGIC_VECTOR ((2*8)-1 downto 0); -- A*B
    
    
    -- Constantes
    constant ZERO_V: STD_LOGIC_VECTOR (8 downto 0) := (others => '0');

begin

    
    A9 <= '0' & A; -- Ajout d'un bit de poids fort supplémentaire (à 0)
    B9 <= '0' & B; -- Ajout d'un bit de poids fort supplémentaire (à 0)

    Res_ADD <= A9 + B9; -- A+B
	-- Carry Flag
    C <= Res_ADD (8) when Ctrl_ALU = "001" else '0';


    Res_SUB <= A9 - B9; -- A-B
    -- Negative Flag
    N <= Res_SUB (7) when Ctrl_ALU = "010" else '0';
    -- Zero Flag
    Z <= '1' when (Res_SUB = ZERO_V) else '0' when Ctrl_ALU = "010" else '0';


    Res_MUL <= A * B;   -- A*B 
	-- Overflow Flag
    O <= '0' when (Res_MUL ((2*8)-1 downto 8) = ZERO_V) else
         '1';
    

    -- Select Output according to Ctrl_ALU
    S <= Res_ADD (7 downto 0) when Ctrl_ALU = "001" else -- 001 : ADD
         Res_SUB (7 downto 0) when Ctrl_ALU = "010" else -- 010 : SUB
         Res_MUL (7 downto 0) when Ctrl_ALU = "100" else -- 100 : MUL
         (others => '0');


end Behavioral;
