----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/30/2019 08:05:56 PM
-- Design Name: 
-- Module Name: ADC_module_tb - Behavioral
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

entity ADC_module_tb is
--  Port ( );
end ADC_module_tb;

architecture Behavioral of ADC_module_tb is

    component ADC_module is
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
    end component;
    
    signal src_clk : std_logic;
    signal start : std_logic;
    signal reset :  std_logic;
    signal sdata : std_logic;
    signal clk_out : std_logic;
    signal data_rdy : std_logic;
    signal data_out : std_logic_vector (11 downto 0);
    signal cs_out : std_logic;
    signal src_ce : std_logic;
    
    signal count : std_logic_vector(4 downto 0) := "00000";
    
    constant clk_period : time := 10 ns;

begin

    uud : ADC_module PORT MAP(
        src_clk => src_clk,
        src_ce => src_ce,
        start => start,
        reset => reset,
        sdata => sdata,
        cs_out => cs_out,
        clk_out => clk_out,
        data_rdy => data_rdy,
        data_out => data_out);
        
    clk_process : process
    begin
        src_clk <= '0';
        wait for clk_period/2;
        src_clk <= '1';
        wait for clk_period/2;
    end process clk_process;
    
    startup_process: process
    begin
        reset <= '1';
        start <= '0';
        wait for 100 ns;
        
        reset <= '0';
        start <= '1';
        wait for 100 ns;
        
        start <= '0';
        wait;
    end process startup_process;
    
    stim_process: process(clk_out)
    begin
        if clk_out'event and clk_out = '0' then
        
            case count is
                when "00000" => 
                    sdata <= '0';
                when "00001" => 
                    sdata <= '0';
                when "00010" => 
                    sdata <= '0';
                when "00011" => 
                    sdata <= '1';
                when "00100" => 
                    sdata <= '1';
                when "00101" => 
                    sdata <= '0';
                when "00110" => 
                    sdata <= '0';
                when "00111" => 
                    sdata <= '0';
                when "01000" => 
                    sdata <= '0';
                when "01001" => 
                    sdata <= '0';
                when "01010" => 
                    sdata <= '0';
                when "01011" => 
                    sdata <= '0';
                when "01100" => 
                    sdata <= '1';
                when "01101" => 
                    sdata <= '0';
                when "01110" => 
                    sdata <= '1';
                when others => 
                    sdata <= '0'; 
                    count <= "00000";
            end case;
            
            count <= count + 1;
            
        end if;
    end process stim_process;

end Behavioral;
