----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:09:48 12/04/2017 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port ( 	
       	CLK : in  STD_LOGIC;
			
			--TRANSMITTER PORTS
			TABORTP : in  STD_LOGIC;
			TAVAILP : in  STD_LOGIC;
			TFINISHP : in  STD_LOGIC;
			TLASTP : in  STD_LOGIC;
			TDATAI : in  STD_LOGIC_VECTOR (7 downto 0);
			NOADDRI : in  STD_LOGIC_VECTOR (47 downto 0);
			TDATAO : out  STD_LOGIC_VECTOR (7 downto 0);
			TDONEP : out  STD_LOGIC;
			TREADDP : out  STD_LOGIC;
			TRNSMTP : out  STD_LOGIC;
			TSTARTP : out  STD_LOGIC;
			TSOCOLP : out  STD_LOGIC;
				
   		--RECEIVER PORTS  
   		RBYTEP : out  STD_LOGIC;
         RCLEANP : out  STD_LOGIC;
         RCVNGP : out  STD_LOGIC;
         RDATAO : out  STD_LOGIC_VECTOR (7 downto 0);
         RDONEP : out  STD_LOGIC;
			RDATAI : in  STD_LOGIC_VECTOR (7 downto 0);
         RENABP : in  STD_LOGIC;
         RSMATIP : out  STD_LOGIC;
         RSTARTP : out  STD_LOGIC	 
   		   
			);
end top;

architecture Behavioral of top is

COMPONENT transmitter
	PORT(
		CLK : IN std_logic;
		TABORTP : IN std_logic;
		TAVAILP : IN std_logic;
		TFINISHP : IN std_logic;
		TLASTP : IN std_logic;
		TDATAI : IN std_logic_vector(7 downto 0);
		NOADDRI : IN std_logic_vector(47 downto 0);          
		TDATAO : OUT std_logic_vector(7 downto 0);
		TDONEP : OUT std_logic;
		TREADDP : OUT std_logic;
		TRNSMTP : OUT std_logic;
		TSTARTP : OUT std_logic;
		TSOCOLP : OUT std_logic
		);
	END COMPONENT;

COMPONENT receiver
	PORT(
		CLK : IN std_logic;
		NOADDRI : IN std_logic_vector(47 downto 0);
		RDATAI : IN std_logic_vector(7 downto 0);
		RENABP : IN std_logic;          
		RBYTEP : OUT std_logic;
		RCLEANP : OUT std_logic;
		RCVNGP : OUT std_logic;
		RDATAO : OUT std_logic_vector(7 downto 0);
		RDONEP : OUT std_logic;
		RSMATIP : OUT std_logic;
		RSTARTP : OUT std_logic
		);
	END COMPONENT;



begin

	tx: entity work.transmitter PORT MAP(
		CLK => CLK,
		TABORTP => TABORTP,
		TAVAILP => TAVAILP,
		TFINISHP => TFINISHP,
		TLASTP => TLASTP,
		TDATAI => TDATAI,
		NOADDRI => NOADDRI,
		TDATAO => TDATAO,
		TDONEP => TDONEP,
		TREADDP => TREADDP,
		TRNSMTP => TRNSMTP,
		TSTARTP => TSTARTP,
		TSOCOLP => TSOCOLP
	);
	
	rx: entity work.receiver PORT MAP(
		CLK => CLK,
		RBYTEP => RBYTEP,
		RCLEANP => RCLEANP,
		RCVNGP => RCVNGP,
		RDATAO => RDATAO,
		RDONEP => RDONEP,
		NOADDRI => NOADDRI,
		RDATAI => RDATAI,
		RENABP => RENABP,
		RSMATIP => RSMATIP,
		RSTARTP => RSTARTP
	);



end Behavioral;

