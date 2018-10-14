--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:04:57 11/24/2017
-- Design Name:   
-- Module Name:   /home/buchmeie/Bureau/VHDL/ethernet/test_receiver.vhd
-- Project Name:  ethernet
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: receiver
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
 
ENTITY test_receiver IS
END test_receiver;
 
ARCHITECTURE behavior OF test_receiver IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT receiver
    PORT(
	      CLK : IN  std_logic;
         RBYTEP : OUT  std_logic;
         RCLEANP : OUT  std_logic;
         RCVNGP : OUT  std_logic;
         RDATAO : OUT  std_logic_vector(7 downto 0);
         RDONEP : OUT  std_logic;
         NOADDRI : IN  std_logic_vector(47 downto 0);
         RDATAI : IN  std_logic_vector(7 downto 0);
         RENABP : IN  std_logic;
         RSMATIP : OUT  std_logic;
         RSTARTP : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
	signal CLK : std_logic := '0';
   signal NOADDRI : std_logic_vector(47 downto 0) := (others => '0');
   signal RDATAI : std_logic_vector(7 downto 0) := (others => '0');
   signal RENABP : std_logic := '0';

 	--Outputs
   signal RBYTEP : std_logic;
   signal RCLEANP : std_logic;
   signal RCVNGP : std_logic;
   signal RDATAO : std_logic_vector(7 downto 0);
   signal RDONEP : std_logic;
   signal RSMATIP : std_logic;
   signal RSTARTP : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: receiver PORT MAP (
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
		
      wait for CLK_period*20;


      wait;
   end process;

END;
