----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2020 01:21:25 PM
-- Design Name: 
-- Module Name: Counter_module_tb - Behavioral
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

entity Counter_module_tb is
--  Port ( );
end Counter_module_tb;

architecture Behavioral of Counter_module_tb is

    component Counter_module is
        Port (
            src_clk : in std_logic;
            src_ce : in std_logic;
            reset : in std_logic;
            en : in std_logic;
            value : out std_logic_vector(3 downto 0));
    end component;
    
    signal src_clk : std_logic;
    signal src_ce : std_logic;
    signal reset : std_logic;
    signal en : std_logic;
    signal value : std_logic_vector(3 downto 0);
    
    constant clk_period : time := 10 ns;

begin

    uud : Counter_module PORT MAP(
        src_clk => src_clk,
        src_ce => src_ce,
        reset => reset,
        en => en,
        value => value);
        
    clk_process : process
    begin
        src_clk <= '0';
        wait for clk_period/2;
        src_clk <= '1';
        wait for clk_period/2;
    end process clk_process;
    
    stim_process: process
    begin
        reset <= '1';
        en <= '0';
        wait for 100 ns;
        reset <= '0';
        en <= '1';
        wait for 100 ns;
        
        wait for 1000 ns;
    end process stim_process;

end Behavioral;
