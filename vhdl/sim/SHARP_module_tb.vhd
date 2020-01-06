----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/02/2020 10:11:48 PM
-- Design Name: 
-- Module Name: SHARP_module_tb - Behavioral
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

entity SHARP_module_tb is
--  Port ( );
end SHARP_module_tb;

architecture Behavioral of SHARP_module_tb is

    component SHARP_module is
        Port (
            src_clk : in std_logic;
            src_ce : in std_logic;
            start : in std_logic;
            reset : in std_logic;
            en_out : out std_logic;
            data_rdy : out std_logic);
    end component;
    
    signal src_clk : std_logic;
    signal start : std_logic;
    signal reset : std_logic;
    signal en_out : std_logic;
    signal data_rdy : std_logic;
    signal src_ce : std_logic;
    
    constant clk_period : time := 10 ns;

begin

    uud : SHARP_module PORT MAP(
        src_clk => src_clk,
        src_ce => src_ce,
        start => start,
        reset => reset,
        en_out => en_out,
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
        wait for 2 ms;
        
        start <= '1';
        reset <= '0';
        wait for 2 ms;
        
        start <= '0';
        wait for 10 ns;
        
        wait;
    end process stim_proc;

end Behavioral;
