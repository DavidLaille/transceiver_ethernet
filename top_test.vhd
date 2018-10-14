--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:26:58 12/04/2017
-- Design Name:   
-- Module Name:   D:/Google Drive/INSA Toulouse/1er Semestre/VHDL/ethernet/top_test.vhd
-- Project Name:  ethernet
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_test IS
END top_test;
 
ARCHITECTURE behavior OF top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         CLK : IN  std_logic;
         TABORTP : IN  std_logic;
         TAVAILP : IN  std_logic;
         TFINISHP : IN  std_logic;
         TLASTP : IN  std_logic;
         TDATAI : IN  std_logic_vector(7 downto 0);
         NOADDRI : IN  std_logic_vector(47 downto 0);
         TDATAO : OUT  std_logic_vector(7 downto 0);
         TDONEP : OUT  std_logic;
         TREADDP : OUT  std_logic;
         TRNSMTP : OUT  std_logic;
         TSTARTP : OUT  std_logic;
         TSOCOLP : OUT  std_logic;
         RBYTEP : OUT  std_logic;
         RCLEANP : OUT  std_logic;
         RCVNGP : OUT  std_logic;
         RDATAO : OUT  std_logic_vector(7 downto 0);
         RDONEP : OUT  std_logic;
         RDATAI : IN  std_logic_vector(7 downto 0);
         RENABP : IN  std_logic;
         RSMATIP : OUT  std_logic;
         RSTARTP : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal TABORTP : std_logic := '0';
   signal TAVAILP : std_logic := '0';
   signal TFINISHP : std_logic := '0';
   signal TLASTP : std_logic := '0';
   signal TDATAI : std_logic_vector(7 downto 0) := (others => '0');
   signal NOADDRI : std_logic_vector(47 downto 0) := (others => '0');
   signal RDATAI : std_logic_vector(7 downto 0) := (others => '0');
   signal RENABP : std_logic := '0';

 	--Outputs
   signal TDATAO : std_logic_vector(7 downto 0);
   signal TDONEP : std_logic;
   signal TREADDP : std_logic;
   signal TRNSMTP : std_logic;
   signal TSTARTP : std_logic;
   signal TSOCOLP : std_logic;
   signal RBYTEP : std_logic;
   signal RCLEANP : std_logic;
   signal RCVNGP : std_logic;
   signal RDATAO : std_logic_vector(7 downto 0);
   signal RDONEP : std_logic;
   signal RSMATIP : std_logic;
   signal RSTARTP : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
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
          TSOCOLP => TSOCOLP,
          RBYTEP => RBYTEP,
          RCLEANP => RCLEANP,
          RCVNGP => RCVNGP,
          RDATAO => RDATAO,
          RDONEP => RDONEP,
          RDATAI => RDATAI,
          RENABP => RENABP,
          RSMATIP => RSMATIP,
          RSTARTP => RSTARTP
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	
	
		-- TRANSMITTER TEST
		-- hold reset state for 100 ns.
      wait for 100 ns;	
				
		--Le transmetteur peut commencer à transmettre
      TAVAILP <= '1'; wait for CLK_period*2;		
	
		--Envoi de l'adresse de destination (celle du recepteur)
		TDATAI <= X"FF"; wait for CLK_period;
		TDATAI <= X"00"; wait for CLK_period;
		TDATAI <= X"FF"; wait for CLK_period;
		TDATAI <= X"00"; wait for CLK_period;
		TDATAI <= X"FF"; wait for CLK_period;
		TDATAI <= X"03"; wait for CLK_period;
		
		--On attend que l'adresse source (celle du transmetteur) soit envoyé
		NOADDRI <= X"FF00FF00FF02";
		wait for CLK_period*6;
		
		--Envoi des données (temps de transmission d'une donnée : 800ns)
		TDATAI <= X"FE"; wait for CLK_period*8;
		TDATAI <= X"00"; wait for CLK_period*8;
		TDATAI <= X"05"; wait for CLK_period*8;

		--Envoi du dernier octet de données
		TLASTP <= '1';		
		TDATAI <= X"01"; wait for CLK_period*8; --dernière donnée	
		TLASTP <= '0'; wait for CLK_period;
				
		
		--On attend que le EFD soit envoyé
		wait for CLK_period;
		
		--Fin du test
		wait for CLK_period*10;
		
		
		
		
      
		-- RECEIVER TEST
		-- hold reset state for 100 ns.
      wait for 200 ns;	
		
		RENABP <= '1'; wait for CLK_period;
		--Reception SFD
		RDATAI <= "10101011"; wait for CLK_period;
		
		NOADDRI <= X"FF01FF01FF02";
		
		--Reception de l'adresse de destination (celle du recepteur)
		RDATAI <= X"02"; wait for CLK_period;
		RDATAI <= X"FF"; wait for CLK_period;
		RDATAI <= X"01"; wait for CLK_period;
		RDATAI <= X"FF"; wait for CLK_period;
		RDATAI <= X"01"; wait for CLK_period;
		RDATAI <= X"FF"; wait for CLK_period;
		
		--Reception de l'adresse source (celle du transmetteur)
		RDATAI <= X"2F"; wait for CLK_period;
		RDATAI <= X"00"; wait for CLK_period;
		RDATAI <= X"FF"; wait for CLK_period;
		RDATAI <= X"00"; wait for CLK_period;
		RDATAI <= X"FF"; wait for CLK_period;
		RDATAI <= X"03"; wait for CLK_period;
		
		--Reception des données
		RDATAI <= X"FE"; wait for CLK_period*8;
		RDATAI <= X"00"; wait for CLK_period*8;
		RDATAI <= X"05"; wait for CLK_period*8;
		RDATAI <= X"04"; wait for CLK_period*8;
		RDATAI <= X"03"; wait for CLK_period*8;
		RDATAI <= X"02"; wait for CLK_period*8;
		RDATAI <= X"01"; wait for CLK_period*8;
		
		--Reception EFD
		RDATAI <= "10101011"; wait for CLK_period;
		
		--Fin de la transmission
		RENABP <= '0';		
		
		

      wait;
   end process;

END;
