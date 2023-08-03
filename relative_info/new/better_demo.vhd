
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The IEEE.std_logic_unsigned contains definitions that allow 
--std_logic_vector types to be used with the + operator to instantiate a 
--counter.
use IEEE.std_logic_unsigned.all;

entity better_demo is
Port ( 
	BTN 			: in  std_logic_vector (1 downto 0);
	CLK 			: in  std_logic;
	LED 			: out  std_logic_vector (1 downto 0);
	UART_TXD 		: out  std_logic;
	RGB0_Red		: out  std_logic;
	RGB0_Green    	: out  std_logic;
	RGB0_Blue    	: out  std_logic
);
end better_demo;

architecture Behavioral of better_demo is

component UART_TX_CTRL is
port(
	SEND : in std_logic;
	DATA : in std_logic_vector(7 downto 0);
	CLK : in std_logic;          
	READY : out std_logic;
	UART_TX : out std_logic
);
end component;

component debounce is
generic (
	DEBNC_CLOCKS : integer := 16;
	PORT_WIDTH : integer := 4
);
port (
	SIGNAL_I : in std_logic_vector(PORT_WIDTH - 1 downto 0);
	CLK_I : in std_logic;
	SIGNAL_O : out std_logic_vector(PORT_WIDTH - 1 downto 0)
);
end component;

component RGB_control is
port (
	GCLK : in std_logic;
	RGB_LED_1_O : out std_logic_vector(2 downto 0);
	RGB_LED_2_O : out std_logic_vector(2 downto 0)
);
end component;

component clk_wiz_0
port(
    clk_in1         : in std_logic;
    clk_out1        : out std_logic;
    reset           : in std_logic
);
end component;

component t_ear_logic is
Port(
    m_clk 			: in std_logic;
    uartRdy 		: in std_logic;
    btnDeBnc	   	: in std_logic_vector(1 downto 0);
    uartSend 		: out std_logic;
    uartData 		: out std_logic_vector (7 downto 0)
    );
end component;

-- smieci
constant TMR_CNTR_MAX : std_logic_vector(26 downto 0) := "101111101011110000100000000"; --100,000,000 = clk cycles per second
constant TMR_VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9
--This is used to determine when the 7-segment display should be
--incremented
signal tmrCntr : std_logic_vector(26 downto 0) := (others => '0');
--This counter keeps track of which number is currently being displayed
--on the 7-segment.
signal tmrVal : std_logic_vector(3 downto 0) := (others => '0');
signal uartTX : std_logic;
signal clk_cntr_reg : std_logic_vector (4 downto 0) := (others=>'0'); 
-- smieci
															  
--sygnały uart teraz jako sygnały dla logiki - kabelki:D
signal uartRdy : std_logic; -- pójdzie jako sygnał do logiki
signal uartSend : std_logic := '0'; -- pójdzie jako sygnał do logiki
signal uartData : std_logic_vector (7 downto 0):= "00000000"; -- pójdzie jako sygnał do logiki
signal btnDeBnc : std_logic_vector(1 downto 0); -- pójdzie jako sygnał do logiki

-- A te się ostały:D
-- -- clock signal
signal clk_100 : std_logic;
signal clkRst : std_logic := '0';


begin

----------------------------------------------------------
-- łączenie kabelków
LED <= BTN;
UART_TXD <= uartTX;
----------------------------------------------------------

-- 12 Mhz to 100 Mhz
inst_clk: clk_wiz_0
port map(
	clk_in1 => CLK,
	clk_out1 => clk_100,
	reset => clkRst
);

-- filtrowanie zgrzytów dla przycisków 
Inst_btn_debounce: debounce 
generic map(
	DEBNC_CLOCKS => (2**16),
	PORT_WIDTH => 2)
port map(
	SIGNAL_I => BTN,
	CLK_I => clk_100,
	SIGNAL_O => btnDeBnc
);

-- wysyła dane po uarcie 
Inst_UART_TX_CTRL: UART_TX_CTRL 
port map(
	SEND => uartSend,
	DATA => uartData,
	CLK => clk_100,
	READY => uartRdy,
	UART_TX => uartTX 
);

-- wysyła napisy jak są klikane klawisze
some_logic_inst : t_ear_logic
port map (
    m_clk => clk_100,
    uartRdy => uartRdy,
    btnDeBnc => btnDeBnc,
    uartSend => uartSend,
    uartData => uartData
);

-- to se tylko animuje diodę rgb
RGB_Core_verilog: RGB_control port map(
	GCLK => clk_100, 			
	RGB_LED_1_O(0) => RGB0_Green, 
	RGB_LED_1_O(1) => RGB0_Blue,
	RGB_LED_1_O(2) => RGB0_Red
	);

end Behavioral;

