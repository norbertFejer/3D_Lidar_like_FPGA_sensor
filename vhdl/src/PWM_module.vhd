----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2020 11:58:44 AM
-- Design Name: 
-- Module Name: PWM_module - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_module is
    Port (
        src_clk : in std_logic;
        src_ce : in std_logic;
        start: in std_logic;
        reset : in std_logic;
        min_val : in std_logic_vector(10 downto 0);
        max_val : in std_logic_vector(10 downto 0);
        change_h : in std_logic;
        data_rdy : out std_logic;
        pwm_out : out std_logic);
end PWM_module;

architecture Behavioral of PWM_module is

    type state_type is (RDY, INIT_A, INIT_B, HIGH, LOW, END_S);
    
    signal actual_state, next_state : state_type;
    signal q_clk : std_logic;
    signal r_counter, r_counter_next : std_logic_vector(10 downto 0);
    signal r_pwm_out, r_pwm_out_next : std_logic;
    signal r_data_rdy, r_data_rdy_next : std_logic;
    signal h : std_logic_vector (7 downto 0) := (others => '0');

begin

    --0.01ms periodusu orajel generalasa
    --100kHz
    modulo: process(src_clk, reset)
    
        variable cnt : integer range 1005 downto 0 := 0;
        variable q : std_logic := '0';
    
    begin
        
        if reset = '1' then
            q := '0';
            cnt := 0;
        elsif src_clk'event and src_clk = '1' then
        
            if cnt < 500 then
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
    
    NSL: process(actual_state, start, r_counter)
    begin
        case actual_state is
        
            when RDY =>
                if start = '1' then
                    next_state <= INIT_A;
                else
                    next_state <= RDY;
                end if;
                
            when INIT_A =>
                next_state <= INIT_B;
                
            when INIT_B =>
                if r_counter < min_val then
                    next_state <= INIT_B;
                else
                    next_state <= HIGH;
                end if;
                
            when HIGH =>
                if r_counter < (min_val + h) then
                    next_state <= HIGH;
                else 
                    next_state <= LOW;
                end if;
                
            when LOW =>
                if r_counter < max_val then
                    next_state <= LOW;
                else
                    next_state <= END_S;
                end if;
            
            when END_S =>
                next_state <= RDY;
                
        end case;
    end process NSL;
    
    with actual_state select r_counter_next <=
        (others => '0') when RDY,
        r_counter + 1 WHEN others;
        
    with actual_state select r_pwm_out_next <=
        r_pwm_out when RDY,
        '1' when INIT_A,
        r_pwm_out when INIT_B,
        r_pwm_out when HIGH,
        '0' when LOW,
        r_pwm_out when END_S;
        
    with actual_state select r_data_rdy_next <=
        r_data_rdy when RDY,
        '0' when INIT_A,
        r_data_rdy when INIT_B,
        r_data_rdy when HIGH,
        r_data_rdy when LOW,
        '1' when END_S;
    
    data_r_counter: process(q_clk, reset)
    begin
        if reset = '1' then
            r_counter <= (others => '0');
        elsif q_clk'event and q_clk = '1' then
            r_counter <= r_counter_next;
        end if;
    end process data_r_counter;
    
    data_r_pwm_out: process(q_clk, reset)
    begin
        if q_clk'event and q_clk = '1' then
            r_pwm_out <= r_pwm_out_next;
        end if;
    end process data_r_pwm_out;
    
    data_r_data_rdy: process(q_clk, reset)
    begin
        if q_clk'event and q_clk = '1' then
            r_data_rdy <= r_data_rdy_next;
        end if;
    end process data_r_data_rdy;
    
    pwm_out <= r_pwm_out;
    data_rdy <= r_data_rdy;
    
    data_r_change_h: process(change_h, reset)
    
        variable dir : std_logic := '0';
    
    begin
        if reset = '1' then
            h <= (others => '0');
        elsif change_h'event and change_h = '1' then
            if h > 119 then
                dir := '1';
            elsif h < 1 then
                dir := '0';
            end if;
            
            if dir = '0' then
                h <= h + 1;
            elsif dir = '1' then
                h <= h - 1;
            end if;
        end if;
    end process data_r_change_h;

end Behavioral;
