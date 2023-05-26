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
    -- DECLARE OP CONSTANTS
    -------------------------------------------------------
    -------------------------------------------------------

    constant NOP  : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    constant ADD  : STD_LOGIC_VECTOR(7 downto 0) := x"01";
    constant SUB  : STD_LOGIC_VECTOR(7 downto 0) := x"02";
    constant DIV  : STD_LOGIC_VECTOR(7 downto 0) := x"03";
    constant MUL  : STD_LOGIC_VECTOR(7 downto 0) := x"04";
    constant COP  : STD_LOGIC_VECTOR(7 downto 0) := x"05";
    constant AFC  : STD_LOGIC_VECTOR(7 downto 0) := x"06";
    constant LOAD : STD_LOGIC_VECTOR(7 downto 0) := x"07";
    constant STORE: STD_LOGIC_VECTOR(7 downto 0) := x"08";

    

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
    signal BR_local_QA : STD_LOGIC_VECTOR (7 downto 0);
    signal BR_local_QB : STD_LOGIC_VECTOR (7 downto 0);
        
    -- COMPONENT : DM
    signal DM_local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal DM_local_Data_IN : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal DM_local_RW : STD_LOGIC := '0';
    signal DM_local_RST : STD_LOGIC := '0';
    signal DM_local_Data_OUT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    
    -- COMPONENT : IM
    signal IM_local_Addr : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IM_local_Data_OUT : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    
    -- PIPELINE LEVEL 1 
    signal PIP_1_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_1_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal IP      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); --instruction pointer
    
    -- PIPELINE LEVEL 2 
    signal PIP_2_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_2_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_2_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_2_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_2_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_2_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    
    -- PIPELINE LEVEL 3 
    signal PIP_3_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_3_C : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_3_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_3_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_3_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    -- PIPELINE LEVEL 4 
    signal PIP_4_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_4_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_4_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_4_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_4_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal WIRE_4_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0'); 
    
    -- PIPELINE LEVEL 5 
    signal PIP_5_OP : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_5_A : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    signal PIP_5_B : STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
    
    -- CONFLICT DETECTORS ON REGISTERS
    
     signal Reg_1_2_READ_B  : STD_LOGIC := '0'; -- LI/DI  : B
     signal Reg_1_2_READ_C  : STD_LOGIC := '0'; -- LI/DI  : C
     signal Reg_2_3_WRITE_B : STD_LOGIC := '0'; -- DI/EX  : B
     signal Reg_3_4_WRITE_B : STD_LOGIC := '0'; -- EX/Mem : B
     
     signal CONFLICT : STD_LOGIC := '0'; -- '1' : there is a conflict

     signal EN_IM : STD_LOGIC := '1'; -- '0' disable if conflict      


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
        CLK => CLK,
        QA => BR_local_QA,
        QB => BR_local_QB
    );
    
    -- COMPONENT : DM
    instance_DM : DataMemory_unit port map (
        Addr => DM_local_Addr ,
        Data_IN => DM_local_Data_IN ,
        RW => DM_local_RW,
        Data_OUT => DM_local_Data_OUT,
        RST => DM_local_RST,
        CLK => CLK
    );
    
    -- COMPONENT : IM
    instance_IM : InstructionMemory_unit port map (
        Addr => IM_local_Addr ,
        CLK => CLK,
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
        -- LEVEL 2-3 : DI/EX
        -------------------------------------------------------
           
        PIP_3_OP <= WIRE_2_OP;
        PIP_3_A <=  WIRE_2_A;
        PIP_3_B <=  WIRE_2_B;        
        
        -------------------------------------------------------
        -- LEVEL 3-4 : EX/Mem
        -------------------------------------------------------
        
        PIP_4_OP <= WIRE_3_OP;
        PIP_4_A <=  WIRE_3_A;
        PIP_4_B <=  WIRE_3_B;
        
        -------------------------------------------------------
        -- LEVEL 4-5 : Mem/RE
        -------------------------------------------------------
        
        PIP_5_OP <= WIRE_4_OP;
        PIP_5_A <=  WIRE_4_A;
        PIP_5_B <=  WIRE_4_B;
                
        -------------------------------------------------------
        -- LEVEL 1-2 : LI/DI
        -------------------------------------------------------
        
        if CONFLICT = '1' then -- there is a RW conflict
            --if PIP_2_OP = NOP then 
                -- Block LI/DI if there is a NOP
                PIP_2_OP <= NOP ; -- NOP
                PIP_2_A  <=  "00000000";  
                PIP_2_B  <=  "00000000";  
                PIP_2_C  <=  "00000000";
            --end if;
            EN_IM <= '0';
        -- Block IP if there is a NOP
        else
        
            PIP_2_OP <= PIP_1_OP;
            PIP_2_A <=  PIP_1_A;  
            PIP_2_B <=  PIP_1_B;  
            PIP_2_C <=  PIP_1_C;
            
            IP <= IP + 1; --increment ins pointer
            EN_IM <= '1';
        end if;

  
    end process;
    
    
   
    -------------------------------------------------------
    -- LEVEL 1 : LI
    -------------------------------------------------------
   
    IM_local_Addr <= IP ;
    
    PIP_1_OP <= IM_local_Data_OUT(31 downto 24) when EN_IM='1' ; -- get the OP
    PIP_1_A  <= IM_local_Data_OUT(23 downto 16) when EN_IM='1' ; -- get the return register
    PIP_1_B  <= IM_local_Data_OUT(15 downto 8)  when EN_IM='1' ; -- get the first parameter
    PIP_1_C  <= IM_local_Data_OUT(7 downto 0)   when EN_IM='1' ; -- get the second parameter
    
    -------------------------------------------------------
    -- LEVEL 2 : DI
    -------------------------------------------------------
    
    WIRE_2_OP <= PIP_2_OP;
    WIRE_2_A  <= PIP_2_A;
    WIRE_2_B  <= PIP_2_B when (PIP_2_OP = AFC) or (PIP_2_OP = LOAD) else BR_local_QA ;
    WIRE_2_C  <= BR_local_QB ;  

    
    BR_local_Addr_A <= PIP_2_B (3 downto 0);
    BR_local_Addr_B <= PIP_2_C (3 downto 0);
    
    -------------------------------------------------------
    -- LEVEL 3 : EX
    -------------------------------------------------------
    
    WIRE_3_OP <= PIP_3_OP;
    WIRE_3_A  <= PIP_3_A;
    WIRE_3_B  <= PIP_3_B when (PIP_3_OP = AFC)  or (PIP_3_OP = COP) or (PIP_3_OP = LOAD) or (PIP_3_OP = STORE) else ALU_local_S;
    
    ALU_local_A <= PIP_3_B;
    ALU_local_B <= PIP_3_C;
    ALU_local_Ctrl_ALU <= PIP_3_OP (2 downto 0) when (PIP_3_OP = ADD)  or (PIP_3_OP = SUB) or (PIP_3_OP = MUL);
    
    -------------------------------------------------------
    -- LEVEL 4 : Mem
    -------------------------------------------------------
    
    WIRE_4_OP <= PIP_4_OP;
    WIRE_4_A  <= PIP_4_A;
    WIRE_4_B  <= DM_local_Data_OUT when PIP_4_OP = LOAD else  PIP_4_B;
    
    
    DM_local_Addr <= PIP_4_B when PIP_4_OP = LOAD else PIP_4_A when PIP_4_OP = STORE ;
    DM_local_RW   <= '1' when PIP_4_OP = LOAD else '0' when PIP_4_OP = STORE; 
    DM_local_Data_IN <= PIP_4_B ; 
    
    -------------------------------------------------------
    -- LEVEL 5 : RE
    -------------------------------------------------------
    
    BR_local_Data <= PIP_5_B; 
    BR_local_W <= '0' when PIP_5_OP = STORE or  PIP_5_OP = NOP else '1'; --Write 
    BR_local_Addr_W <= PIP_5_A (3 downto 0) ;
    

    -------------------------------------------------------
    -- Conflicts : detect conflics
    -------------------------------------------------------
    Reg_1_2_READ_B  <= -- LI/DI  : B
            '1'  
        when 
            PIP_1_OP = COP or
            PIP_1_OP = ADD or
            PIP_1_OP = SUB or
            PIP_1_OP = MUL or
            PIP_1_OP = DIV or
            PIP_1_OP = STORE      
        else 
            '0' ;
            
    Reg_1_2_READ_C  <= -- LI/DI  : C
             '1'  
        when 
            PIP_1_OP = COP or
            PIP_1_OP = ADD or
            PIP_1_OP = SUB or
            PIP_1_OP = MUL or
            PIP_1_OP = DIV or
            PIP_1_OP = STORE     
        else 
            '0' ;
            
            
            
    Reg_2_3_WRITE_B <= -- DI/EX  : B
            '1'  
        when 
            WIRE_2_OP = AFC or
            WIRE_2_OP = COP or
            WIRE_2_OP = ADD or
            WIRE_2_OP = SUB or
            WIRE_2_OP = MUL or
            WIRE_2_OP = DIV or
            WIRE_2_OP = LOAD    
        else 
                '0' ;
                
    Reg_3_4_WRITE_B <= -- EX/Mem : B
            '1'  
        when 
            WIRE_3_OP = AFC or
            WIRE_3_OP = COP or
            WIRE_3_OP = ADD or
            WIRE_3_OP = SUB or
            WIRE_3_OP = MUL or
            WIRE_3_OP = DIV or
            WIRE_3_OP = LOAD         
        else 
            '0' ;
    
    CONFLICT <= 
            '1'
        when 
            (Reg_1_2_READ_B='1' and Reg_2_3_WRITE_B='1' and PIP_1_B = PIP_2_A ) or  -- RW - LI/DI & DI/EX  : B
            (Reg_1_2_READ_C='1' and Reg_2_3_WRITE_B='1' and PIP_1_C = PIP_2_A ) or  -- RW - LI/DI & DI/EX  : C
            (Reg_1_2_READ_B='1' and Reg_3_4_WRITE_B='1' and PIP_1_B = PIP_3_A ) or  -- RW - LI/DI & EX/Mem
            (Reg_1_2_READ_C='1' and Reg_3_4_WRITE_B='1' and PIP_1_C = PIP_3_A )     -- RW - LI/DI & EX/Mem
        else 
            '0' ;
            

end Behavioral;
