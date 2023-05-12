----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2023 10:05:42
-- Design Name: 
-- Module Name: Test_ALU_unit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_ALU_unit is
--  Port ( );
end Test_ALU_unit;

architecture Behavioral of Test_ALU_unit is
    
    -- Component Declaration for the Unit to Test : ALU
    component ALU_unit is
        Port ( A : in STD_LOGIC_VECTOR (7 downto 0);        -- Input A ALU     
               B : in STD_LOGIC_VECTOR (7 downto 0);        -- Input B ALU
               Ctrl_ALU : in STD_LOGIC_VECTOR (2 downto 0); -- Operation to be done on A and B
               S : out STD_LOGIC_VECTOR (7 downto 0);       -- Output S ALU
               N : out STD_LOGIC; -- Negative Flag 
               O : out STD_LOGIC;  -- Overflow Flag 
               Z : out STD_LOGIC;   -- Zero Flag 
               C : out STD_LOGIC); -- Carry Flag 
    end component;
    
    
    -- Local Inputs
    
    signal local_A : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_B : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_Ctrl_ALU : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
       
    -- Local Outputs
    signal local_S : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal local_N : STD_LOGIC := '0';
    signal local_O : STD_LOGIC := '0';
    signal local_Z : STD_LOGIC := '0';
    signal local_C : STD_LOGIC := '0';

begin

    -- Instantiate the Unit to Test : ALU
    instance : ALU_unit port map (
        A => local_A ,       -- Input A ALU     
        B => local_B,        -- Input B ALU
        Ctrl_ALU => local_Ctrl_ALU,  -- Operation to be done on A and B
        S => local_S,   -- Output S ALU
        N => local_N,   -- Negative Flag 
        O => local_O,   -- Overflow Flag 
        Z => local_Z,   -- Zero Flag 
        C => local_C    -- Carry Flag
    );
    
    
    
    local_A <= 
        x"04" after 10 ns, -- TEST 1 : ADD
        x"ff" after 20 ns, -- TEST 2 : ADD
        
        x"06" after 30 ns, -- TEST 1 : SUB
        x"04" after 40 ns, -- TEST 2 : SUB
        x"06" after 50 ns, -- TEST 3 : SUB
        
        x"04" after 60 ns, -- TEST 1 : MUL
        x"ff" after 70 ns  -- TEST 2 : MUL
        ;
        
    local_B <= 
        x"08" after 10 ns, -- TEST 1 : ADD
        x"01" after 20 ns, -- TEST 2 : ADD
        
        x"04" after 30 ns, -- TEST 1 : SUB
        x"06" after 40 ns, -- TEST 2 : SUB
        x"06" after 50 ns, -- TEST 3 : SUB
        
        x"08" after 60 ns, -- TEST 1 : MUL
        x"02" after 70 ns  -- TEST 2 : MUL
        ;
        
    
    
    local_Ctrl_ALU <= 
        "001" after 10 ns, --TEST : ADD
        "010" after 30 ns, --TEST : SUB
        "100" after 60 ns  --TEST : MUL
        ;


  
end Behavioral;
