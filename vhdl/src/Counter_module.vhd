----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/04/2020 01:13:32 PM
-- Design Name: 
-- Module Name: Counter_module - Behavioral
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

entity Counter_module is
    Port (
        src_clk : in std_logic;
        src_ce : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        value : out std_logic_vector(3 downto 0));
end Counter_module;

architecture Behavioral of Counter_module is

    signal cnt : std_logic_vector(3 downto 0) := "0000";

begin

    main: process(src_clk, reset)
    begin
        if reset = '1' then
            cnt <= "0000";
        elsif src_clk'event and src_clk = '1' and en = '1' then
            if cnt = "1111" then
                cnt <= "0000";
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    
    value <= cnt;

end Behavioral;
