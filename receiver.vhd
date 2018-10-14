----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:47:53 11/15/2017 
-- Design Name: 
-- Module Name:    receiver - Behavioral 
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

entity receiver is
    Port ( CLK : in  STD_LOGIC;
			  RBYTEP : out  STD_LOGIC;
           RCLEANP : out  STD_LOGIC;
           RCVNGP : out  STD_LOGIC;
           RDATAO : out  STD_LOGIC_VECTOR (7 downto 0);
           RDONEP : out  STD_LOGIC;
			  NOADDRI : in  STD_LOGIC_VECTOR (47 downto 0);
			  RDATAI : in  STD_LOGIC_VECTOR (7 downto 0);
           RENABP : in  STD_LOGIC;
           RSMATIP : out  STD_LOGIC;
           RSTARTP : out  STD_LOGIC);
end receiver;

architecture Behavioral of receiver is

signal SFD : STD_LOGIC_VECTOR (7 downto 0) := "10101011";
signal EFD : STD_LOGIC_VECTOR (7 downto 0) := "10101011";

signal ADDR_SRC : STD_LOGIC_VECTOR (47 downto 0) := (others => '0');

signal I : integer := 0;
signal J : integer := 0;
signal addr_valide : integer := 0;
signal pulse_RSTART : integer := 0;
signal pulse_RBYTEP : integer := 0;
signal pulse_RDONEP : integer := 0;
signal pulse_RCLEANP : integer := 0;
signal temps_transmission : integer := 0;
signal sfd_recu : integer := 0;

begin


process

	begin
	
	if addr_valide /= 6 then
		RSMATIP <= '0';
	end if;
	
	wait until CLK'event and CLK='1';
	RSTARTP <= '0';
	RDONEP <= '0';
	RCLEANP <= '0';
	RBYTEP <= '0';
	RCVNGP <= '0';

	
	if RENABP = '1' then
		if RDATAI = SFD or sfd_recu = 1 then
			sfd_recu <= 1;
			RCVNGP <= '1';
			
			--Pulse de 100ns 
			if pulse_RSTART < 1 then
				RSTARTP <= '1';
				pulse_RSTART <= 1;
		
			else				
				if I<6 then
					if RDATAI = NOADDRI(I*8+7 downto I*8) then					
						addr_valide <= addr_valide + 1; 	
						I <= I+1;	
					else
						RCLEANP <= '1';
						sfd_recu <= 0;
						RCVNGP <= '0';
						pulse_RSTART <= 0;
						I <= 0;
					end if;				
											
				else
				
					if addr_valide = 6 then
						RSMATIP <= '1';

						if J<6 then
							ADDR_SRC(J*8+7 downto J*8) <= RDATAI;
							J <= J+1;					
						else
								
							if RDATAI /= EFD then
								
								if pulse_RBYTEP < 1 then
									RBYTEP <= '1';
									pulse_RBYTEP <= 1;
								end if;
									
								if temps_transmission < 8 then
									RDATAO <= RDATAI;
									temps_transmission <= temps_transmission + 1;																
								end if;
								
								if temps_transmission = 7 then								
									pulse_RBYTEP <= 0;
									temps_transmission <= 0;
								end if;	
								
							else
								RCVNGP <= '0';
								if pulse_RDONEP < 1 then
									RDONEP <= '1';
									pulse_RDONEP <= 1;
										
									RSMATIP <= '0';
									I <= 0;
									J <= 0;
									sfd_recu <= 0;
									pulse_RSTART <= 0;
										
								end if;							
							end if;			
						end if;					
						
					end if;
				end if;
			end if;
		end if;
	end if ;
		
	
	
	
	
end process;


end Behavioral;

