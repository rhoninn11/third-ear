library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_t_ear_logic_v2 is
end tb_t_ear_logic_v2;

architecture Behavioral of tb_t_ear_logic_v2 is

    -- Component declaration
    component t_ear_logic_v2 is
        generic(
            rst_cycles: std_logic_vector(17 downto 0) := "110000110101000000"
        );
        port (
            m_clk           : in std_logic;
            uartRdy         : in std_logic;
            btnDeBnc        : in std_logic_vector(1 downto 0);
            cycles_num      : in std_logic_vector(15 downto 0);
            cycles_num_rdy  : in std_logic;
            uartSend        : out std_logic;
            uartData        : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Inputs
    signal m_clk           : std_logic := '0';
    signal uartRdy         : std_logic := '0';
    signal btnDeBnc        : std_logic_vector(1 downto 0) := (others => '0');
    signal cycles_num      : std_logic_vector(15 downto 0) := (others => '0');
    signal cycles_num_rdy  : std_logic := '0';

    -- Outputs
    signal uartSend        : std_logic;
    signal uartData        : std_logic_vector(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: t_ear_logic_v2 
    generic map (
        rst_cycles => "000000000000001000"
    )
    port map (
        m_clk           => m_clk,
        uartRdy         => uartRdy,
        btnDeBnc        => btnDeBnc,
        cycles_num      => cycles_num,
        cycles_num_rdy  => cycles_num_rdy,
        uartSend        => uartSend,
        uartData        => uartData
    );

    -- Clock process definitions
    clk_process :process
    begin
        m_clk <= '0';
        wait for 10 ns;
        m_clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Insert stimulus here
        wait for 10 ns;
        uartRdy <= '1';
        wait for 2500 ns;
        wait for 10 ns;
        cycles_num <= "0000000000101010";
        cycles_num_rdy <= '1';
        wait for 40 ns;
        cycles_num_rdy <= '0';
        wait for 1000 ns;
        -- Insert more stimulus here
        assert FALSE report "End of simulation" severity FAILURE;
    end process;

end Behavioral;