--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:09:56 11/10/2017
-- Design Name:   
-- Module Name:   /home/buchmeie/Bureau/VHDL/ethernet/transmitter_test.vhd
-- Project Name:  ethernet
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transmitter
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
 
ENTITY transmitter_test IS
END transmitter_test;
 
ARCHITECTURE behavior OF transmitter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT transmitter
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
         TSOCOLP : OUT  std_logic
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

 	--Outputs
   signal TDATAO : std_logic_vector(7 downto 0);
   signal TDONEP : std_logic;
   signal TREADDP : std_logic;
   signal TRNSMTP : std_logic;
   signal TSTARTP : std_logic;
   signal TSOCOLP : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: transmitter PORT MAP (
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
		wait for CLK_period*20;
		
		

      wait;
   end process;

END;
