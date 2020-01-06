----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2020 01:17:52 PM
-- Design Name: 
-- Module Name: PWM_module_tb - Behavioral
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
use IEEE.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_module_tb is
--  Port ( );
end PWM_module_tb;

architecture Behavioral of PWM_module_tb is

    component PWM_module is
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
    end component;
    
    signal src_clk : std_logic;
    signal src_ce : std_logic;
    signal start: std_logic;
    signal reset : std_logic;
    signal min_val : std_logic_vector(10 downto 0);
    signal max_val : std_logic_vector(10 downto 0);
    signal change_h : std_logic;
    signal pwm_out : std_logic;
    signal data_rdy : std_logic;
    
    constant clk_period : time := 10 ns;

begin

    uud : PWM_module PORT MAP(
        src_clk => src_clk,
        src_ce => src_ce,
        start => start,
        reset => reset,
        min_val => min_val,
        max_val => max_val,
        change_h => change_h,
        data_rdy => data_rdy,
        pwm_out => pwm_out);
        
    clk_process : process
    begin
        src_clk <= '0';
        wait for clk_period/2;
        src_clk <= '1';
        wait for clk_period/2;
    end process clk_process;
    
    stim_proc: process
    begin
        reset <= '1';
        start <= '0';
        change_h <= '0';
        wait for 100 ns;
        
        min_val <= conv_std_logic_vector(90, 11);
        max_val <= conv_std_logic_vector(2000, 11);
        wait for 100 ns;
        
        src_ce <= '1';
        start <= '1';
        reset <= '0';
        wait for 100 ns;
        
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
                        
        change_h <= '1';
        wait for 10 ns;
        change_h <= '0';
        wait for 40 ms;
    end process stim_proc;

end Behavioral;
