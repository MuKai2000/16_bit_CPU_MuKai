--CTRL控制电路
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CTRL is
	port (CLK : in std_logic;	--时钟信号
			Code : in std_logic_vector(3 downto 0);	--指令信号	from IREG
			T : in std_logic_vector(7 downto 0);	--节拍信号	from COUNTER
			IPC : out std_logic;	--PC控制信号
			IMAR : out std_logic;	--MAREG寄存信号
			IDR, EDR : out std_logic;	--DREG寄存、输出信号
			W, R : out std_logic;	--ALU中DREG输入输出信号
			Code_A : out std_logic_vector(3 downto 0);
			ISUM, ESUM : out std_logic;	--ALU控制、输出信号
			IIR : out std_logic	--IREG寄存信号
			);
end CTRL;

architecture vhd_ctrl of CTRL is
signal IPC_temp : std_logic:='0';	--PC控制信号
signal IMAR_temp : std_logic:='0';	--MAREG寄存信号
signal IDR_temp, EDR_temp : std_logic:='0';	--DREG寄存、输出信号
signal W_temp, R_temp : std_logic:='0';	--ALU中DREG输入输出信号
signal ISUM_temp, ESUM_temp : std_logic:='0';	--ALU控制、输出信号
signal IIR_temp : std_logic:='0';	--IREG寄存信号
begin
IPC <= IPC_temp;
IMAR <= IMAR_temp;
IDR <= IDR_temp;
EDR <= EDR_temp;
W <= W_temp;
R <= R_temp;
ISUM <= ISUM_temp;
ESUM <= ESUM_temp;
IIR <= IIR_temp;
Code_A <= Code;	--ALU操作指令
	process(T, Code)
	begin
		if(Code="1111") then	--停机
			IPC_temp <= '0';
			IIR_temp <= '0';
			EDR_temp <= '0';
		else
			--0
			if T="00000001" then
				IMAR_temp <= '1';	--将PC内容送入MAR地址寄存器
			--1
			elsif T="00000010" then
				IMAR_temp <= '0';	--地址寄存器关闭
				IDR_temp <= '1';	EDR_temp <= '1';	--将指令码送入DR送入dbus
			--2
			elsif T="00000100" then
				IDR_temp <= '0';	--DR关闭
				IPC_temp <= '1';	IIR_temp <= '1';	--PC=PC+1	dbus->IR(Code-->CTRLM)
			--Code分类处理
			elsif Code="0001" then	--移数	LD
				case T is
					--3
					when "00001000" =>	IPC_temp<='0';	IIR_temp <= '0';
												IMAR_temp<='1';	--将PC内容送入MAR地址寄存器
					--4
					when "00010000" =>	IMAR_temp<='0';
												IDR_temp<='1';	EDR_temp<='1';	--将操作数送至dbus
					--5
					when "00100000" =>	IDR_temp <= '0';	--DR关闭
												IPC_temp<='1';	--PC=PC+1
					--6
					when "01000000" =>	IPC_temp<='0';	
												W_temp<='1';	--将操作数从dbus存入ALU的DR中
					--7
					when "10000000" =>	W_temp<='0';	IPC_temp<='0';	
					when others => NULL;
				end case;
			elsif Code="0010" or Code="0011" or Code="0110" or Code="0111" or Code="1001" then	--操作数为A和存储器数	ADD/SUB/AND/OR/XOR
				case T is
					--3
					when "00001000" =>	IPC_temp<='0';	IIR_temp <= '0';
												IMAR_temp<='1';	--将PC内容送入MAR地址寄存器
					--4
					when "00010000" =>	IMAR_temp<='0';
												IDR_temp<='1';	EDR_temp<='1';	--将操作数送至dbus
					--5
					when "00100000" =>	IDR_temp <= '0';	--DR关闭
												IPC_temp<='1';	ISUM_temp<='1';	R_temp<='1';	--PC=PC+1	计算ACC+dbus
					--6
					when "01000000" =>	IPC_temp<='0';	ISUM_temp<='0';	R_temp<='0';	
												W_temp<='1';	ESUM_temp<='1';	EDR_temp <= '0';	--ALU结果-->SR-->dbus-->ACC
					--7
					when "10000000" =>	W_temp<='0';	ESUM_temp<='0';
					when others => NULL;
				end case;
			elsif Code="0100" or Code="0101" or Code="1000" then	--操作数只有A	INC/DEC/NOT
				case T is
					--3
					when "00001000" =>	IPC_temp<='0';	IIR_temp <= '0';
												ISUM_temp<='1';	R_temp<='1';	--计算
					--4
					when "00010000" =>	ISUM_temp<='0';	R_temp<='0';
												W_temp<='1';	ESUM_temp<='1';	EDR_temp <= '0';--ALU结果-->SR-->dbus-->ACC
					--5
					when "00100000" => 	W_temp<='0';	ESUM_temp<='0';
					--6
					when "01000000" => NULL;
					--7
					when "10000000" => NULL;
					when others => NULL;
				end case;
			end if;
		end if;
	end process;
end vhd_ctrl;