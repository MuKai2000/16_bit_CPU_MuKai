--SR结果发生器
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SREG is
	port (CLK : in std_logic;	--时钟信号
			DI : in std_logic_vector(15 downto 0);	--输入数据
			DO : out std_logic_vector(15 downto 0)	--输出数据
			);
end SREG;

architecture vhd_dreg of SREG is
signal t : std_logic_vector(15 downto 0);
begin
	process(CLK)
	begin
		if(rising_edge(CLK))then	--时钟上升沿
			t <= DI;
		end if;
	end process;
DO <= t;
end vhd_dreg;