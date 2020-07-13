--算术逻辑单元仿真文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ms_alu is
end ms_alu;

architecture modelsim of ms_alu is
component ALU	--算术逻辑单元
	port (DA,DB : in std_logic_vector(15 downto 0);	--输入数据
			I : in std_logic_vector(3 downto 0);	--输入命令
			E : in std_logic;	--输出控制
			ALU_OUT : out std_logic_vector(15 downto 0);	--ALU输出数据
			Zero, Over, Nege : out std_logic --标志位
			);
	end component;	
	
signal DA,DB : std_logic_vector(15 downto 0);	--输入数据
signal I : std_logic_vector(3 downto 0):="0000";	--输入命令
signal E : std_logic;	--输出控制
signal ALU_OUT : std_logic_vector(15 downto 0);	--ALU输出数据
signal Zero, Over, Nege : std_logic:='0'; --标志位
begin
A : ALU port map(DA, DB, I, E, ALU_OUT, Zero, Over, Nege);
process
begin
	DA <= "1001110110011111";
	wait for 40 ns;
	DA <= "1000100011110000";
	wait for 40 ns;
	DA <= "0000011100000001";
	wait for 40 ns;
	DA <= "1000000000110000";
	wait for 40 ns;
end process;
process
begin
	DB <= "0000000001111111";
	wait for 60 ns;
	DB <= "1111110000011111";
	wait for 60 ns;
	DB <= "0100011100011111";
	wait for 60 ns;
	DB <= "1010101010101010";
	wait for 60 ns;
end process;
process
begin
	I <= I + 1;
	wait for 20 ns;
end process;

process
begin
	E <= '0';
	wait for 50 ns;
	E <= '1';
	wait for 50 ns;
end process;

end modelsim;