----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:54:01 10/26/2017 
-- Design Name: 
-- Module Name:    transmitter - Behavioral 
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

entity transmitter is
    Port ( CLK : in  STD_LOGIC;
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
           TSOCOLP : out  STD_LOGIC);
end transmitter;

architecture Behavioral of transmitter is


	signal SFD : STD_LOGIC_VECTOR (7 downto 0) := "10101011";
	signal EFD : STD_LOGIC_VECTOR (7 downto 0) := "10101011";
	signal addr_dest_envoye : integer := 0;
	signal addr_src_envoye : integer := 0;
	signal sfd_envoye : integer := 0 ; 
	signal efd_envoye : integer := 0 ; 
	signal I : integer := 0;
	signal J : integer := 0;	
	signal K : integer := 0;	
	signal init : integer := 0;
	signal last_data_sent : integer := 0;
	signal transmit_fin : integer := 0;
	signal fin_trame : integer := 0;	
	signal temps_transmission : integer := 0;	
	signal pulse_TDONEP : integer := 0;
	signal pulse_TREADDP : integer := 0;
	signal attente : integer := 0;

begin

process

	begin	
	
	wait until CLK'event and CLK='1';
	TDONEP <= '0';
	TSTARTP <= '0';
	TREADDP <= '0';
	
	if TABORTP = '0' then
		if TAVAILP = '1' and init=0 then
			TSTARTP <= '1';   --Pulse pour TSTARTP			
			TRNSMTP <= '1';
			init <= 1;
			TSOCOLP<='0';
			
		elsif init = 1 then
		
			if sfd_envoye=0 then
					-- Envoie le SFD			
					TDATAO <= SFD;
					sfd_envoye <= 1;
					
			else		
				if (addr_dest_envoye=0 and addr_src_envoye = 0) then			
			
					-- Envoie l'address de destination	
					if I<6 then
						TDATAO <= TDATAI;
						I <= I+1;
						if I=5 then addr_dest_envoye<=1; end if;
					end if;
					
				elsif (addr_dest_envoye=1 and addr_src_envoye = 0) then
					-- Envoie l'address source	
					if J<6 then
						TDATAO <= NOADDRI(J*8+7 downto J*8);
						J <= J+1;	
						if	J=5 then addr_src_envoye <= 1; end if;				
					end if;
					
				else
				
					if transmit_fin=0 then						
						if TLASTP = '0' then
							if temps_transmission < 8 then
								if pulse_TREADDP < 1 then
									TREADDP <= '1';
									TDATAO <= TDATAI;
									pulse_TREADDP <= 1;
								end if;
								
								temps_transmission <= temps_transmission + 1;
							end if;
							if temps_transmission = 7 then							
								temps_transmission <= 0;
								pulse_TREADDP <= 0;
							end if;
							
						else
							-- Envoie la dernière donnée
							if temps_transmission < 8 then
								if pulse_TREADDP < 1 then
									TREADDP <= '1';
									TDATAO <= TDATAI;
									pulse_TREADDP <= 1;
								end if;
								
							temps_transmission <= temps_transmission + 1;
							end if;
							
							if temps_transmission = 7 then							
								temps_transmission <= 0;
								pulse_TREADDP <= 0;
								last_data_sent <= 1;							
								transmit_fin <=1;	
							end if;						

						end if;
						
					end if;
						
					if last_data_sent = 1 then
					
						if efd_envoye=0 then
							-- Envoie le EFD			
							TDATAO <= EFD;
							efd_envoye <= 1;					
						else
							-- Fin de la transmission des données
							TRNSMTP <= '0';
							fin_trame <= 1;
						end if;
					end if;					
					
					if fin_trame = 1 then			
					
								-- Envoie le pulse de TDONEP 
								if pulse_TDONEP<1 then
									TDONEP <= '1';
									pulse_TDONEP <= 1;	
								
								else	
									--on attend 800ns
									if attente < 8 then
										attente <= attente + 1;
									else
										init <= 0; 
										TDONEP <= '0';		
										sfd_envoye <= 0;
										addr_dest_envoye <= 0;
										addr_src_envoye <= 0;
										last_data_sent <= 0;
										transmit_fin <=0;
										fin_trame <= 0;
										I <= 0;
										J <= 0;	
										pulse_TDONEP <= 0;
										attente <= 0;	
									end if;
								end if;					
					end if;
					

				end if;
				
				
			end if;
			
			
		end if;
		
	else
		-- aborted
		TSOCOLP<='1';
	end if;
	
end process;


end Behavioral;

