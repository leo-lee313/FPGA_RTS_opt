// megafunction wizard: %ALTFP_COMPARE%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altfp_compare 

// ============================================================
// File Name: Double_compare.v
// Megafunction Name(s):
// 			altfp_compare
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.0.1 Build 232 06/12/2013 SP 1 SJ Full Version
// ************************************************************

//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module Double_compare (
	clock,
	dataa,
	datab,
	agb,
	alb)/* synthesis synthesis_clearbox = 1 */;

	input	  clock;
	input	[63:0]  dataa;
	input	[63:0]  datab;
	output	  agb;
	output	  alb;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: FPM_FORMAT NUMERIC "1"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix V"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix V"
// Retrieval info: CONSTANT: PIPELINE NUMERIC "1"
// Retrieval info: CONSTANT: WIDTH_EXP NUMERIC "11"
// Retrieval info: CONSTANT: WIDTH_MAN NUMERIC "52"
// Retrieval info: USED_PORT: agb 0 0 0 0 OUTPUT NODEFVAL "agb"
// Retrieval info: USED_PORT: alb 0 0 0 0 OUTPUT NODEFVAL "alb"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: USED_PORT: dataa 0 0 64 0 INPUT NODEFVAL "dataa[63..0]"
// Retrieval info: USED_PORT: datab 0 0 64 0 INPUT NODEFVAL "datab[63..0]"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: CONNECT: @dataa 0 0 64 0 dataa 0 0 64 0
// Retrieval info: CONNECT: @datab 0 0 64 0 datab 0 0 64 0
// Retrieval info: CONNECT: agb 0 0 0 0 @agb 0 0 0 0
// Retrieval info: CONNECT: alb 0 0 0 0 @alb 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL Double_compare_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
