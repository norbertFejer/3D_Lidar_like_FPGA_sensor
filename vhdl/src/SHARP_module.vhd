----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2020 09:08:22 PM
-- Design Name: 
-- Module Name: SHARP_module - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SHARP_module is
    Port ( 
        src_clk : in std_logic;
        src_ce : in std_logic;
        start : in std_logic;
        reset : in std_logic;
        en_out : out std_logic;
        data_rdy : out std_logic);
end SHARP_module;

architecture Behavioral of SHARP_module is

    type state_type is (RDY, INIT_A, WAIT_1, INIT_B, WAIT_2, END_S);
    
    signal actual_state, next_state : state_type;
    signal r_i, r_i_next : std_logic_vector(8 downto 0);
    signal r_en_out, r_en_out_next : std_logic;
    signal r_data_rdy, r_data_rdy_next : std_logic;
    signal q_clk : std_logic;

begin

     --0.1ms periodusu orajel generalasa
     --10kHz
    modulo: process(src_clk, reset)
    
        variable cnt : integer range 5005 downto 0 := 0;
        variable q : std_logic := '0';
    
    begin
        
        if reset = '1' then
            q := '0';
            cnt := 0;
        elsif src_clk'event and src_clk = '1' then
        
            if cnt < 5000 then
                cnt := cnt + 1;
                q := q;
            else
                cnt := 0;
                q := not(q);
            end if;
            
            q_clk <= q;
        end if;
        
    end process modulo;
    
    ASL: process(q_clk, reset)
        begin
            if reset = '1' then
                actual_state <= RDY;
            elsif q_clk'event and q_clk = '1' then
                actual_state <= next_state;
            end if;
        end process ASL;
    
    NSL: process(actual_state, start, r_i)
    begin
        case actual_state is
            
            when RDY =>
                if start = '1' then
                    next_state <= INIT_A;
                else
                    next_state <= RDY;
                end if;
                
            when INIT_A =>
                next_state <= WAIT_1;
                
            when WAIT_1 =>
                if r_i > 1 then
                    next_state <= WAIT_1;
                else
                    next_state <= INIT_B;
                end if;
                
            when INIT_B =>
                next_state <= WAIT_2;
                
            when WAIT_2 =>
                if r_i > 1 then
                    next_state <= WAIT_2;
                else
                    next_state <= END_S;
                end if;
                
            when END_S =>
                next_state <= RDY;
                
        end case;
    end process NSL;
    
    with actual_state select r_i_next <=
        r_i when RDY,
        conv_std_logic_vector(227, 9) when INIT_A,
        r_i - 1 when WAIT_1,
        conv_std_logic_vector(1, 9) when INIT_B,
        r_i - 1 when WAIT_2,
        r_i when END_S;
        
    with actual_state select r_en_out_next <=
        r_en_out when RDY,
        '1' when INIT_A,
        r_en_out when WAIT_1,
        r_en_out when INIT_B,
        r_en_out when WAIT_2,
        '0' when END_S;
        
    with actual_state select r_data_rdy_next <=
        r_data_rdy when RDY,
        '0' when INIT_A,
        r_data_rdy when WAIT_1,
        r_data_rdy when INIT_B,
        r_data_rdy when WAIT_2,
        '1' when END_S;
        
    data_r_i: process(q_clk, reset)
    begin
        if q_clk'event and q_clk = '1' then
            r_i <= r_i_next;
        end if;
    end process data_r_i;
    
    data_r_en_out: process(q_clk, reset)
    begin
        if q_clk'event and q_clk = '1' then
            r_en_out <= r_en_out_next;
        end if;
    end process data_r_en_out;
    
    data_r_data_rdy: process(q_clk, reset)
    begin
        if q_clk'event and q_clk = '1' then
            r_data_rdy <= r_data_rdy_next;
        end if;
    end process data_r_data_rdy;

    en_out <= r_en_out;
    data_rdy <= r_data_rdy;
    
end Behavioral;
