--------------------------------------------------------------------------------------------------
-- 																								--
-- 				F A C H H O C H S C H U L E 	- 	T E C H N I K U M W I E N					--
-- 																								--
--------------------------------------------------------------------------------------------------
--																								--
-- Web: http://www.technikum-wien.at/															--
-- 																								--
-- Contact: christopher.krammer@technikum-wien.at												--
--																								--
--------------------------------------------------------------------------------------------------
--
-- Author: Christopher Krammer
--
-- Filename: vgaCtrl_.vhd
--
-- Date of Creation: 14:00 19/02/2019
--
-- Version: 1.0
--
-- Date of Latest Version: 14:00 19/02/2019
--
-- Design Unit: vgaCtrl (Entity)
--
-- Description: Entity to control a VGA interface with 640x480 visible pixels
--				Main target is to control the HSYNC_o and VSYNC_o Outputs
--				Color Data is just passed by
--
--				This Entity is meant to be more generic than the project specifications (640x480)
--
--------------------------------------------------------------------------------------------------
-- CVS Change Log:
-- 19/02/19		1.0		CKr		Initial
--------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

configuration tb_vgaCtrl_sim_cfg of tb_vgaCtrl is
  for sim
	for i_vgaCtrl : vgaCtrl
	  use configuration work.vgaCtrl_rtl_cfg;
	end for;
	for i_25Mclk  : clkPrescale
	  use configuration work.clkPrescale_rtl_cfg;
    end for;
  end for;
end tb_vgaCtrl_sim_cfg;
