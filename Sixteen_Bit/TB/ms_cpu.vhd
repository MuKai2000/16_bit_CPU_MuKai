--程序计数器仿真文件
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ms_cpu is
end ms_cpu;

architecture modelsim of ms_cpu is
component Sixteen_Bit_CPU
	port (CLK : in std_logic;	--时钟信号
			CLR : in std_logic;	--复位信号
			CS, WR : in std_logic;	--RAM的控制信号
			Add_IN : in std_logic_vector(3 downto 0); --RAM输入数据存放地址
			Input : in std_logic_vector(15 downto 0);	--RAM输入数据
			ALU_OUT : out std_logic_vector(15 downto 0);	--ALU输出数据
			Zero, Over, Nege : out std_logic; --标志位信号
			ERROR,STOP : out std_logic;

			Tap : out std_logic_vector(7 downto 0);
			Code_IR : out std_logic_vector(3 downto 0);
			IPC_O : out std_logic;	--PC信号	CTRLM控制电路 --> PC程序计数器
			IMAR_O : out std_logic;	--MAR寄存信号	CTRLM控制电路 --> MAR地址寄存器
			IDR_O, EDR_O : out std_logic;	--DR寄存、输出信号	CTRLM控制电路 --> DR数据寄存器
			W_O, R_O : out std_logic;	--ALU中DR输入输出信号	CTRLM控制电路 --> ALU数据寄存器
			ISUM_O : out std_logic;	--ALU指令信号	CTRLM控制电路 --> ALU算数逻辑单元
			ESUM_O : out std_logic;	--ALU输出信号	CTRLM控制电路 --> ALU算数逻辑单元
			DA_O : out std_logic_vector(15 downto 0);	--ALU输入数据
			IIR_O : out std_logic;	--IREG寄存信号	CTRLM控制电路 --> IR指令寄存器
			ABUS_O : out std_logic_vector(3 downto 0)	--地址线
			);
	end component;	
	
	signal CLK : std_logic;	--时钟信号
	signal CLR : std_logic;	--复位信号
	signal CS, WR : std_logic;	--RAM的控制信号
	signal Add_IN : std_logic_vector(3 downto 0); --RAM输入数据存放地址
	signal Input : std_logic_vector(15 downto 0);	--RAM输入数据
	signal ALU_OUT : std_logic_vector(15 downto 0);	--ALU输出数据
	signal Zero, Over, Nege : std_logic; --标志位信号
	signal ERROR,STOP : std_logic;
			
	signal Tap : std_logic_vector(7 downto 0);
	signal Code_IR : std_logic_vector(3 downto 0);
	signal IPC_O : std_logic;	--PC信号	CTRLM控制电路 --> PC程序计数器
	signal IMAR_O : std_logic;	--MAR寄存信号	CTRLM控制电路 --> MAR地址寄存器
	signal IDR_O, EDR_O : std_logic;	--DR寄存、输出信号	CTRLM控制电路 --> DR数据寄存器
	signal W_O, R_O : std_logic;	--ALU中DR输入输出信号	CTRLM控制电路 --> ALU数据寄存器
	signal ISUM_O : std_logic;	--ALU指令信号	CTRLM控制电路 --> ALU算数逻辑单元
	signal ESUM_O : std_logic;	--ALU输出信号	CTRLM控制电路 --> ALU算数逻辑单元
	signal DA_O : std_logic_vector(15 downto 0);	--ALU输入数据
	signal IIR_O : std_logic;	--IREG寄存信号	CTRLM控制电路 --> IR指令寄存器
	signal ABUS_O : std_logic_vector(3 downto 0);	--地址线
begin
CPU : Sixteen_Bit_CPU port map  (CLK, CLR, CS, WR, Add_IN, Input, ALU_OUT, Zero, Over, Nege, ERROR, STOP,
											Tap, Code_IR, IPC_O, IMAR_O, IDR_O, EDR_O, W_O, R_O, ISUM_O, ESUM_O, DA_O, IIR_O, ABUS_O);
process
	begin
		CLK<= '0';
		wait for 5 ns;
		CLK<='1';
		wait for 5 ns;
	end process;
	
process
	begin
		CS<='1';
		wait;
	end process;
	
process
	begin
		CLR <= '1';
		wait for 200 ns;
		CLR <= '0';
		wait;
	end process;
	
process
	begin
		WR<='0';	Add_IN<="0000";	Input<="0000000000111110";
		wait for 30 ns;
		WR<='0';	Add_IN<="0001";	Input<="0000000000000110";
		wait for 30 ns;
		WR<='0';	Add_IN<="0010";	Input<="0000000011000110";
		wait for 30 ns;
		WR<='0';	Add_IN<="0011";	Input<="0000000000000111";
		wait for 30 ns;
		WR<='0';	Add_IN<="0100";	Input<="0101010101011110";
		wait for 30 ns;
		WR<='0';	Add_IN<="0101";	Input<="0000000001110110";
		wait for 30 ns;
		WR<='1';
		wait;
	end process;

end modelsim;