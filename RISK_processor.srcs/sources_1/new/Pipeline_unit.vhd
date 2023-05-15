----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 14:15:46
-- Design Name: 
-- Module Name: Pipeline_unit - Behavioral
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



entity Pipeline_unit is
    Port ( CLK : in STD_LOGIC; --Clock
           RST : in STD_LOGIC; --Reset
           B_OUT : out STD_LOGIC_VECTOR (7 downto 0) --B_out : TODO : understand use
         );
end Pipeline_unit;

architecture Behavioral of Pipeline_unit is

    -------------------------------------------------------
    -------------------------------------------------------
    -- DECLARE COMPONENTS
    -------------------------------------------------------
    -------------------------------------------------------
    
    -- COMPONENT : ALU 
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
    
    -- COMPONENT : BR 
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
    
    -- COMPONENT : DM
    component DataMemory_unit 
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
           Data_IN : in STD_LOGIC_VECTOR (7 downto 0); --Data to write to Memory
           RW : in STD_LOGIC; -- 0 : Write to Memory, 1 : Read from Memory
           RST : in STD_LOGIC; --Reset (resets the memory bank)
           CLK : in STD_LOGIC; --Clock
           Data_OUT : out STD_LOGIC_VECTOR (7 downto 0)); --Data read at Addr
    end component;
    
    -- COMPONENT : IM
    component InstructionMemory_unit
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0); --Memory Address to write to or to read 
           CLK : in STD_LOGIC; --Clock
           Data_OUT : out STD_LOGIC_VECTOR (31 downto 0)); --Result of the instruction
    end component;
    
    
    -------------------------------------------------------
    -------------------------------------------------------
    -- DECLARE LOCAL SIGNALS
    -------------------------------------------------------
    -------------------------------------------------------
    
    -- COMPONENT : ALU 
    signal ALU_local_A : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ALU_local_B : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ALU_local_Ctrl_ALU : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal ALU_local_S : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ALU_local_N : STD_LOGIC := '0';
    signal ALU_local_O : STD_LOGIC := '0';
    signal ALU_local_Z : STD_LOGIC := '0';
    signal ALU_local_C : STD_LOGIC := '0';
             
    -- COMPONENT : BR 
    signal BR_local_Addr_A : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal BR_local_Addr_B : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal BR_local_Addr_W : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal BR_local_W : STD_LOGIC := '0';
    signal BR_local_Data : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal BR_local_RST : STD_LOGIC := '0';
    signal BR_local_CLK : STD_LOGIC := '0';
    signal BR_local_QA : STD_LOGIC_VECTOR (7 downto 0);
    signal BR_local_QB : STD_LOGIC_VECTOR (7 downto 0);
        
    -- COMPONENT : DM
    signal DM_local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal DM_local_Data_IN : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal DM_local_RW : STD_LOGIC := '0';
    signal DM_local_RST : STD_LOGIC := '0';
    signal DM_local_CLK : STD_LOGIC := '0';
    signal DM_local_Data_OUT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    -- COMPONENT : IM
    signal IM_local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IM_local_CLK : STD_LOGIC := '0';
    signal IM_local_Data_OUT : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    
    -- PIPELINE LEVEL 1 
    signal PIP_1_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    -- PIPELINE LEVEL 2 
    signal PIP_2_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    
    -- PIPELINE LEVEL 3 
    signal PIP_3_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');   
    
    -- PIPELINE LEVEL 4 
    signal PIP_4_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_4_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_4_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_4_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');  
    
    -- PIPELINE LEVEL 5 
    signal PIP_5_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_5_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_5_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_5_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');   

begin

    -------------------------------------------------------
    -------------------------------------------------------
    -- INSTANCIATE COMPONENTS
    -------------------------------------------------------
    -------------------------------------------------------
    
    -- COMPONENT : ALU 
    instance_ALU : ALU_unit port map (
        A => ALU_local_A ,       
        B => ALU_local_B,       
        Ctrl_ALU => ALU_local_Ctrl_ALU,  
        S => ALU_local_S,  
        N => ALU_local_N, 
        O => ALU_local_O,    
        Z => ALU_local_Z, 
        C => ALU_local_C 
    );

    -- COMPONENT : BR 
    insatnce_BR : RegBank_unit port map (
        Addr_A => BR_local_Addr_A,
        Addr_B => BR_local_Addr_B,
        Addr_W => BR_local_Addr_W,
        W => BR_local_W,
        Data => BR_local_Data,
        RST => BR_local_RST,
        CLK => BR_local_CLK,
        QA => BR_local_QA,
        QB => BR_local_QB
    );
    
    -- COMPONENT : DM TODO
    instance_DM : DataMemory_unit port map (
        Addr => DM_local_Addr ,
        Data_IN => DM_local_Data_IN ,
        RW => DM_local_RW,
        Data_OUT => DM_local_Data_OUT,
        RST => DM_local_RST,
        CLK => DM_local_CLK
    );
    
    -- COMPONENT : IM TODO
    instance_IM : InstructionMemory_unit port map (
        Addr => IM_local_Addr ,
        CLK => IM_local_CLK,
        Data_OUT => IM_local_Data_OUT
              
    );
    
    
    -------------------------------------------------------
    -------------------------------------------------------
    -- PIPELINE PROCESS
    -------------------------------------------------------
    -------------------------------------------------------

    process
    begin
        wait until rising_edge(CLK); 
        
        -------------------------------------------------------
        -- LEVEL 1
        -------------------------------------------------------
        
        PIP_2_OP <= PIP_1_OP;
        PIP_2_A <=  PIP_1_A;  
        PIP_2_B <=  PIP_1_B;  
        PIP_2_C <=  PIP_1_C;    
        
        -------------------------------------------------------
        -- LEVEL 2
        -------------------------------------------------------
        
        PIP_3_OP <= PIP_2_OP;
        PIP_3_A <=  PIP_2_A;
        PIP_3_B <=  PIP_2_B;
        
        -------------------------------------------------------
        -- LEVEL 3
        -------------------------------------------------------
        
        PIP_4_OP <= PIP_3_OP;
        PIP_4_A <=  PIP_3_A;
        PIP_4_B <=  PIP_3_B;
        
        -------------------------------------------------------
        -- LEVEL 4 
        -------------------------------------------------------
        
        PIP_5_OP <= PIP_4_OP;
        PIP_5_A <=  PIP_4_A;
        PIP_5_B <=  PIP_4_B;
        
        -------------------------------------------------------
        -- LEVEL 5
        -------------------------------------------------------
    
        -- OPCODE = MVL (AFC)
        if (PIP_5_OP = x"06") then 
            BR_local_Data <= PIP_5_B; 
            BR_local_W <= '1'; --Write 
            BR_local_Addr_W <= PIP_5_A (3 downto 0) ;
        end if;
    
    end process;

end Behavioral;
