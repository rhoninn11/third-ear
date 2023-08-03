

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity t_ear_logic is
Port(
	m_clk 			: in std_logic;
	uartRdy 		: in std_logic;
	btnDeBnc	   	: in std_logic_vector(1 downto 0);
	uartSend 		: out std_logic;
	uartData 		: out std_logic_vector (7 downto 0)
	);
end t_ear_logic;

architecture Behavioral of t_ear_logic is

-- customowe typy
type UART_STATE_TYPE is (RST_REG, LD_INIT_STR, SEND_CHAR, RDY_LOW, WAIT_RDY, WAIT_BTN, LD_BTN_STR);
type CHAR_ARRAY is array (integer range<>) of std_logic_vector(7 downto 0);

-- to do jakiegoś restarrtu
constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms
constant MAX_STR_LEN : integer := 31;

-- zakodowane stringi
-- ~ "\n\r CMOD A7 GP IO/UART DEMO! \n\r"
constant WELCOME_STR_LEN : natural := 31; 
constant WELCOME_STR : CHAR_ARRAY(0 to 30) := (X"0A", X"0D", X"43", X"4D", X"4F", X"44", X"20",
 X"41", X"37", X"20", X"47", X"50", X"49", X"4F", X"2F", X"55", X"41", X"52", X"54", X"20", X"44",
 X"45", X"4D", X"4F", X"21", X"20", X"20", X"20", X"0A", X"0A", X"0D"); 
 -- ~ "Button pressdetected!\n\r"
constant BTN_STR_LEN : natural := 24;
constant BTN_STR : CHAR_ARRAY(0 to 23) :=     (X"42", X"75", X"74", X"74", X"6F", X"6E", X"20", X"70",
 X"72", X"65", X"73", X"73", X"20", X"64", X"65", X"74", X"65", X"63", X"74", X"65", X"64", X"21", X"0A",
 X"0D"); 

-- do wysyłania stringów
signal sendStr : CHAR_ARRAY(0 to (MAX_STR_LEN - 1));
signal strEnd : natural;
signal strIndex : natural;

-- do wykrywania krawędzi
signal btnReg : std_logic_vector (1 downto 0) := "00";
signal btnDetect : std_logic;

-- stan maszyny stanów, stan xD
signal uartState : UART_STATE_TYPE := RST_REG;

-- szczerze nie wiem jeszcze po co to jest

signal reset_cntr : std_logic_vector (17 downto 0) := (others=>'0');

begin

----------------------------------------------------------------------------------
-- rejestrowanie stau sygnału
btn_reg_process : process (m_clk)
begin
	if (rising_edge(m_clk)) then
		btnReg <= btnDeBnc(1 downto 0);
	end if;
end process;
-- detakcja krawendzi
btnDetect <= '1' when ((btnReg(0)='0' and btnDeBnc(0)='1') 
						or (btnReg(1)='0' and btnDeBnc(1)='1')) else '0';
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- niby coś związanego z kończeniem przesyłania wiadomości
-- dobra czaję jak jest w resecie to czeka w nim 2 ms bo uart, który będzie wysyłał to na zewnątrz, mógł jeszcze nie skończyć 
process(m_clk)
begin
  if (rising_edge(m_clk)) then
    if ((reset_cntr = RESET_CNTR_MAX) or (uartState /= RST_REG)) then
      reset_cntr <= (others=>'0');
    else
      reset_cntr <= reset_cntr + 1;
    end if;
  end if;
end process;

next_uartState_process : process (m_clk)
begin
	if (rising_edge(m_clk)) then
		case uartState is 
			when RST_REG =>
				if (reset_cntr = RESET_CNTR_MAX) then
					uartState <= LD_INIT_STR;
				end if;
			when LD_INIT_STR =>
				uartState <= SEND_CHAR;
			when SEND_CHAR =>
				uartState <= RDY_LOW;
			when RDY_LOW =>
				uartState <= WAIT_RDY;
			when WAIT_RDY =>
				if (uartRdy = '1') then
					if (strEnd = strIndex) then
						uartState <= WAIT_BTN;
					else
						uartState <= SEND_CHAR;
					end if;
				end if;
			when WAIT_BTN =>
				if (btnDetect = '1') then
					uartState <= LD_BTN_STR;
				end if;
			when LD_BTN_STR =>
				uartState <= SEND_CHAR;
			when others=> --should never be reached
				uartState <= RST_REG;
			end case;
		
	end if;
end process;
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- wysyłanie string z tego urządzenia
-- ładowanie stringa do bufora
string_load_process : process (m_clk)
begin
	if (rising_edge(m_clk)) then
		if (uartState = LD_INIT_STR) then
			sendStr <= WELCOME_STR;
			strEnd <= WELCOME_STR_LEN;
		elsif (uartState = LD_BTN_STR) then
			sendStr(0 to 23) <= BTN_STR;
			strEnd <= BTN_STR_LEN;
		end if;
	end if;
end process;
-- sterowanie indeksem bufora
char_count_process : process (m_clk)
begin
	if (rising_edge(m_clk)) then
		if (uartState = LD_INIT_STR or uartState = LD_BTN_STR) then
			strIndex <= 0;
		elsif (uartState = SEND_CHAR) then
			strIndex <= strIndex + 1;
		end if;
	end if;
end process;
-- wypychanie danych z bufora
char_load_process : process (m_clk)
begin
	if (rising_edge(m_clk)) then
		if (uartState = SEND_CHAR) then
			uartSend <= '1';
			uartData <= sendStr(strIndex);
		else
			uartSend <= '0';
		end if;
	end if;
end process;
-- conversion
		


end Behavioral;
