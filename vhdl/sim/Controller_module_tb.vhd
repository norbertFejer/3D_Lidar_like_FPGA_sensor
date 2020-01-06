----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2020 12:14:00 AM
-- Design Name: 
-- Module Name: Controller_module_tb - Behavioral
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

entity Controller_module_tb is
--  Port ( );
end Controller_module_tb;

architecture Behavioral of Controller_module_tb is

    component Controller_module is
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
    end component;
    
    signal src_clk : std_logic;
    signal start : std_logic;
    signal stop : std_logic;
    signal reset : std_logic;
    signal end_pwm : std_logic;
    signal end_sharp : std_logic;
    signal end_adc : std_logic;
    signal start_pwm : std_logic;
    signal start_sharp : std_logic;
    signal start_adc : std_logic;
    signal data_rdy : std_logic;
    signal src_ce : std_logic;
    signal change_h : std_logic;
    
    constant clk_period : time := 10 ns;

begin

    uud : Controller_module PORT MAP(
        src_clk => src_clk,
        src_ce => src_ce,
        start => start,
        stop => stop,
        reset => reset,
        end_pwm => end_pwm,
        end_sharp => end_sharp,
        end_adc => end_adc,
        start_pwm => start_pwm,
        start_sharp => start_sharp,
        start_adc => start_adc,
        change_h => change_h,
        data_rdy => data_rdy);

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
        stop <= '0';
        end_pwm <= '0';
        end_sharp <= '0';
        end_adc <= '0';
        wait for 100 ns;
        
        reset <= '0';
        start <= '1';
        wait for 100 ns;
        
        start <= '0';
        wait for 100 ns;
        
        end_pwm <= '1';
        wait for 100 ns;
        end_pwm <= '0';
        wait for 100 ns;
        
        end_sharp <= '1';
        wait for 100 ns;
        end_sharp <= '0';
        wait for 100 ns;
        
        end_adc <= '1';
        stop <= '1';
        wait for 100 ns;
        end_adc <= '0';
        wait for 100 ns;
        
        wait;
        
    end process stim_proc;

end Behavioral;
