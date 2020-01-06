----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/30/2019 03:17:38 PM
-- Design Name: 
-- Module Name: ADC_module - Behavioral
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

entity ADC_module is
    Port (
        src_clk : in std_logic;
        src_ce : in std_logic;
        start : in std_logic;
        reset : in std_logic;
        sdata : in std_logic;
        cs_out : out std_logic;
        clk_out : out std_logic;
        data_rdy : out std_logic;
        data_out : out std_logic_vector(11 downto 0));
end ADC_module;

architecture Behavioral of ADC_module is

    type state_type is (RDY, INIT, WAIT_1, INIT_A, CLK_L, INIT_B, CLK_H, INIT_C, WAIT_2, END_S);
    
    signal actual_state, next_state : state_type;
    signal r_clk, r_clk_next : std_logic;
    signal r_i, r_i_next : std_logic_vector(5 downto 0);
    signal r_j, r_j_next : std_logic_vector(4 downto 0);
    signal r_data, r_data_next : std_logic_vector(11 downto 0) := (others => '0');
    signal r_data_rdy, r_data_rdy_next : std_logic;
    signal r_cs_out, r_cs_out_next : std_logic; 

begin

    ASL: process(src_clk, reset)
    begin
        if reset = '1' then
            actual_state <= RDY;
        elsif src_clk'event and src_clk = '1' then
            actual_state <= next_state;
        end if;
    end process ASL;
    
    NSL: process(actual_state, start, r_i, r_j)
    begin
        case actual_state is
        
            when RDY =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= RDY;
                end if;
            
            when INIT =>
                next_state <= WAIT_1;
                
            when WAIT_1 =>
                if r_i > 0 then
                    next_state <= WAIT_1;
                else
                    next_state <= INIT_A;
                end if;
                
            when INIT_A =>
                next_state <= CLK_L;
                
            when CLK_L =>
                if r_i > 0 then 
                    next_state <= CLK_L;
                else
                    next_state <= INIT_B;
                end if;
                
            when INIT_B =>
                next_state <= CLK_H;
                
            when CLK_H =>
                if r_i > 0 then
                    next_state <= CLK_H;
                else
                    next_state <= INIT_C;
                end if;
                
            when INIT_C =>
                if r_j > 0 then
                    next_state <= INIT_A;
                else
                    next_state <= WAIT_2;
                end if;
                
            when WAIT_2 =>
                if r_i > 0 then 
                    next_state <= WAIT_2;
                else
                    next_state <= END_S;
                end if;
                
            when END_s =>
                next_state <= RDY;
                
        end case;
    end process NSL;
    
    with actual_state select r_clk_next <=
        r_clk when RDY,
        '0' when INIT,
        r_clk when WAIT_1,
        '0' when INIT_A,
        r_clk when CLK_L,
        r_clk when INIT_B,
        '1' when CLK_H,
        r_clk when INIT_C,
        '0' when WAIT_2,
        r_clk when END_S;
        
    with actual_state select r_i_next <=
        r_i when RDY,
        conv_std_logic_vector(2, 6) when INIT,
        r_i - 1 when WAIT_1,
        conv_std_logic_vector(50, 6) when INIT_A,
        r_i - 1 when CLK_L,
        conv_std_logic_vector(50, 6) when INIT_B,
        r_i - 1 when CLK_H,
        conv_std_logic_vector(2, 6) when INIT_C,
        r_i - 1 when WAIT_2,
        r_i when END_S;
        
    with actual_state select r_j_next <=
        r_j when RDY,
        conv_std_logic_vector(14, 5) when INIT,
        r_j when WAIT_1,
        r_j when INIT_A,
        r_j when CLK_L,
        r_j when INIT_B,
        r_j when CLK_H,
        r_j - 1 when INIT_C,
        r_j when WAIT_2,
        r_j WHEN END_S;
        
    with actual_state select r_data_next <=
        r_data when RDY,
        (others => '0') when INIT,
        r_data when WAIT_1,
        r_data when INIT_A,
        r_data when CLK_L,
        --shl(r_data + sdata, "1") when INIT_B,
        (r_data(10 downto 0) & sdata) when INIT_B,
        r_data when CLK_H,
        r_data when INIT_C,
        r_data when WAIT_2,
        r_data WHEN END_S;
        
    with actual_state select r_data_rdy_next <=
        r_data_rdy when RDY,
        '0' when INIT,
        r_data_rdy when WAIT_1,
        r_data_rdy when INIT_A,
        r_data_rdy when CLK_L,
        r_data_rdy when INIT_B,
        r_data_rdy when CLK_H,
        r_data_rdy when INIT_C,
        r_data_rdy when WAIT_2,
        '1' WHEN END_S;
        
    with actual_state select r_cs_out_next <=
        r_cs_out when RDY,
        '1' when INIT,
        r_cs_out when WAIT_1,
        r_cs_out when INIT_A,
        r_cs_out when CLK_L,
        r_cs_out when INIT_B,
        r_cs_out when CLK_H,
        r_cs_out when INIT_C,
        '0' when WAIT_2,
        r_cs_out WHEN END_S;
        
    data_r_clk: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_clk <= r_clk_next;
        end if;
    end process data_r_clk;
    
    data_r_i: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_i <= r_i_next;
        end if;
    end process data_r_i;
    
    data_r_j: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_j <= r_j_next;
        end if;
    end process data_r_j;
    
    data_r_data: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_data <= r_data_next;
        end if;
    end process data_r_data;
    
    data_r_data_rdy: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_data_rdy <= r_data_rdy_next;
        end if;
    end process data_r_data_rdy;
    
    data_r_cs_out: process(src_clk, reset)
    begin
        if src_clk'event and src_clk = '1' then
            r_cs_out <= r_cs_out_next;
        end if;
    end process data_r_cs_out;
    
    clk_out <= r_clk;
    data_rdy <= r_data_rdy;
    data_out <= r_data;
    cs_out <= r_cs_out;

end Behavioral;
