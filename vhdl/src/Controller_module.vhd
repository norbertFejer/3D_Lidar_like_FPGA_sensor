----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2020 11:36:51 PM
-- Design Name: 
-- Module Name: Controller_module - Behavioral
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

entity Controller_module is
    Port (
        src_clk : in std_logic;
        src_ce : in std_logic;
        start : in std_logic;
        stop : in std_logic;
        reset : in std_logic;
        end_pwm : in std_logic;
        end_sharp : in std_logic;
        end_adc : in std_logic;
        start_pwm : out std_logic;
        start_sharp : out std_logic;
        start_adc : out std_logic;
        change_h : out std_logic;
        data_rdy : out std_logic);
end Controller_module;

architecture Behavioral of Controller_module is

    type state_type is (RDY, START_PWM_S, INIT_A, START_SHARP_S, INIT_B, START_ADC_S, INIT_C, END_S);
    
    signal actual_state, next_state : state_type;
    signal r_clk, r_clk_next : std_logic;
    signal r_s_pwm, r_s_pwm_next : std_logic;
    signal r_s_sharp, r_s_sharp_next : std_logic;
    signal r_s_adc, r_s_adc_next : std_logic;
    signal r_ch_h, r_ch_h_next : std_logic;
    signal r_data_rdy, r_data_rdy_next : std_logic;

begin

    ASL: process(src_clk, reset)
    begin
        if reset = '1' then
            actual_state <= RDY;
        elsif src_clk'event and src_clk = '1' then
            actual_state <= next_state;
        end if;
    end process ASL;
    
    NSL: process(actual_state, start, end_pwm, end_sharp, end_adc, stop)
    begin
        case actual_state is
            
            when RDY =>
                if start = '1' then
                    next_state <= START_PWM_S;
                else
                    next_state <= RDY;
                end if;
                
            when START_PWM_S =>
                if end_pwm = '1' then
                    next_state <= INIT_A;
                else 
                    next_state <= START_PWM_S;
                end if;
                
            when INIT_A =>
                next_state <= START_SHARP_S;
                
             when START_SHARP_S =>
                if end_sharp = '1' then
                    next_state <= INIT_B;
                else
                    next_state <= START_SHARP_S;
                end if;
                
            when INIT_B =>
                next_state <= START_ADC_S;
                
            when START_ADC_S =>
                if end_adc = '1' then
                    next_state <= INIT_C;
                else
                    next_state <= START_ADC_S;
                end if;
                
            when INIT_C =>
                next_state <= END_S;
                    
            when END_S =>
                if stop = '1' then
                    next_state <= RDY;
                else
                    next_state <= START_PWM_S;
                end if;
            
        end case;
    end process NSL;
    
    with actual_state select r_s_pwm_next <=
        '0' when RDY,
        '1' when START_PWM_S,
        r_s_pwm when INIT_A,
        r_s_pwm when START_SHARP_S,
        r_s_pwm when INIT_B,
        r_s_pwm when START_ADC_S,
        r_s_pwm when INIT_C,
        r_s_pwm when END_S;
        
    with actual_state select r_s_sharp_next <=
        '0' when RDY,
        r_s_sharp when START_PWM_S,
        r_s_sharp when INIT_A,
        '1' when START_SHARP_S,
        '0' when INIT_B,
        r_s_sharp when START_ADC_S,
        r_s_sharp when INIT_C,
        r_s_sharp when END_S;
        
    with actual_state select r_s_adc_next <=
        '0' when RDY,
        r_s_adc when START_PWM_S,
        r_s_adc when INIT_A,
        r_s_adc when START_SHARP_S,
        r_s_adc when INIT_B,
        '1' when START_ADC_S,
        '0' when INIT_C,
        r_s_adc when END_S;
        
    with actual_state select r_ch_h_next <=
        '0' when RDY,
        r_ch_h when START_PWM_S,
        r_ch_h when INIT_A,
        r_ch_h when START_SHARP_S,
        r_ch_h when INIT_B,
        r_ch_h when START_ADC_S,
        '1' when INIT_C,
        r_ch_h when END_S;
        
    with actual_state select r_data_rdy_next <=
        r_data_rdy when RDY,
        '0' when START_PWM_S,
        r_data_rdy when INIT_A,
        r_data_rdy when START_SHARP_S,
        r_data_rdy when INIT_B,
        r_data_rdy when START_ADC_S,
        r_data_rdy when INIT_C,
        '1' when END_S;
        
    data_r_s_pwm: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_s_pwm <= r_s_pwm_next;
        end if;
    end process data_r_s_pwm;
    
    data_r_s_sharp: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_s_sharp <= r_s_sharp_next;
        end if;
    end process data_r_s_sharp;
    
    data_r_s_adc: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_s_adc <= r_s_adc_next;
        end if;
    end process data_r_s_adc;
    
    data_r_ch_h: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_ch_h <= r_ch_h_next;
        end if;
    end process data_r_ch_h;
    
    data_r_data_rdy: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_data_rdy <= r_data_rdy_next;
        end if;
    end process data_r_data_rdy;
    
    start_pwm <= r_s_pwm;
    start_sharp <= r_s_sharp;
    start_adc <= r_s_adc;
    change_h <= r_ch_h;
    data_rdy <= r_data_rdy;

end Behavioral;
