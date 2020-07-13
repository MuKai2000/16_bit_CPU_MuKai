--SR仿真文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ms_sr is
end ms_sr;

architecture modelsim of ms_sr is
component SREG	--程序计数器
	port (DI : in std_logic_vector(15 downto 0);	--输入数据
			DO : out std_logic_vector(15 downto 0)	--输出数据
			);
	end component;	
	
	signal DI : std_logic_vector(15 downto 0);
	signal DO : std_logic_vector(15 downto 0);
begin
SR : SREG port map(DI, DO);

process
	begin
		DI<="0100010011111001";
		wait for 20 ns;
		DI<="1000111000011110";
		wait for 20 ns;
		DI<="0000000011111110";
		wait for 20 ns;
		DI<="1111100111110001";
		wait for 20 ns;
		DI<="0000001111110000";
		wait for 20 ns;
	end process;
end modelsim;