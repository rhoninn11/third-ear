library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_ear_logic_testbench is
end t_ear_logic_testbench;

architecture Behavioral of t_ear_logic_testbench is

    component t_ear_logic
        Port(
	        m_clk 			: in std_logic;
	        uartRdy 		: in std_logic;
	        btnDeBnc	   	: in std_logic_vector(1 downto 0);
	        uartSend 		: out std_logic;
	        uartData 		: out std_logic_vector (7 downto 0)
	        );
    end component;

    signal m_clk: std_logic := '0';
    signal uartRdy: std_logic := '0';
    signal btnDeBnc: std_logic_vector(1 downto 0) := (others => '0');
    signal uartSend: std_logic;
    signal uartData: std_logic_vector(7 downto 0);

begin
    uut: t_ear_logic
        port map(
	        m_clk => m_clk, 
	        uartRdy => uartRdy, 
	        btnDeBnc => btnDeBnc, 
	        uartSend => uartSend, 
	        uartData => uartData
	        );

    clk_process :process
    begin
        m_clk <= '0';
        wait for 5 ns;
        m_clk <= '1';
        wait for 5 ns;
    end process;

    stim_process: process
    begin
        wait for 500 ns;
        uartRdy <= '1';
        wait for 4000 ns;
        uartRdy <= '0';
        wait for 200 ns;
        btnDeBnc <= "01"; -- button press
        wait for 20 ns;
        btnDeBnc <= "00"; -- button release
        wait for 260 ns;
        uartRdy <= '1';
        wait for 70 ns;
        btnDeBnc <= "10"; -- another button press
        wait for 80 ns;
        uartRdy <= '0';
        wait for 90 ns;
        btnDeBnc <= "00"; -- button release
        wait for 100 ns;
        wait; -- End the simulation
    end process;

    monitor: process
    begin
        wait until rising_edge(m_clk);
        assert false
        report "At time " & integer'image(now/1 ns) & 
               " ns, uartSend = " & std_logic'image(uartSend) &
               ", uartData = " & std_logic_vector'image(uartData) severity note;
    end process;

end Behavioral;