// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.13.0.56.2
// Netlist written on Sat Oct 05 21:18:12 2024
//
// Verilog Description of module TOP_ENTITY
//

module TOP_ENTITY (fpga_gpio_i, fpga_gpio_o, fpga_gpio_rst, fpga_gpio_clock);   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(4[8:18])
    input [3:0]fpga_gpio_i;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(6[5:16])
    output [3:0]fpga_gpio_o;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(7[5:16])
    input fpga_gpio_rst;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(8[5:18])
    input fpga_gpio_clock;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(9[5:20])
    
    wire fpga_gpio_clock_c /* synthesis SET_AS_NETWORK=fpga_gpio_clock_c, is_clock=1 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(9[5:20])
    
    wire fpga_gpio_i_c_3, fpga_gpio_i_c_2, fpga_gpio_i_c_1, fpga_gpio_i_c_0, 
        fpga_gpio_o_c_3, fpga_gpio_o_c_2, fpga_gpio_o_c_1, fpga_gpio_o_c_0, 
        fpga_gpio_rst_c;
    wire [3:0]print_state;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(17[10:21])
    
    wire visit_complete, VCC_net, n10, n9, GND_net, n8, n7, n8_adj_143, 
        n7_adj_144, n2257, n379, n2643, n495;
    
    VHI i2210 (.Z(VCC_net));
    OB fpga_gpio_o_pad_3 (.I(fpga_gpio_o_c_3), .O(fpga_gpio_o[3]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(7[5:16])
    VLO i1 (.Z(GND_net));
    LUT4 print_state_3__I_0_i1_4_lut (.A(print_state[0]), .B(n7_adj_144), 
         .C(visit_complete), .D(n8_adj_143), .Z(fpga_gpio_o_c_0)) /* synthesis lut_function=(A (B+(C+(D)))+!A !(B (C)+!B (C+!(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(23[18] 24[16])
    defparam print_state_3__I_0_i1_4_lut.init = 16'hafac;
    GSR GSR_INST (.GSR(n495));
    LUT4 print_state_3__I_0_i2_4_lut (.A(print_state[1]), .B(n9), .C(visit_complete), 
         .D(n10), .Z(fpga_gpio_o_c_1)) /* synthesis lut_function=(A (B+(C+(D)))+!A !(B (C)+!B (C+!(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(23[18] 24[16])
    defparam print_state_3__I_0_i2_4_lut.init = 16'hafac;
    LUT4 print_state_3__I_0_i3_4_lut (.A(print_state[2]), .B(n7), .C(visit_complete), 
         .D(n8), .Z(fpga_gpio_o_c_2)) /* synthesis lut_function=(A (B+(C+(D)))+!A !(B (C)+!B (C+!(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(23[18] 24[16])
    defparam print_state_3__I_0_i3_4_lut.init = 16'hafac;
    TSALL TSALL_INST (.TSALL(GND_net));
    IB fpga_gpio_clock_pad (.I(fpga_gpio_clock), .O(fpga_gpio_clock_c));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(9[5:20])
    IB fpga_gpio_rst_pad (.I(fpga_gpio_rst), .O(fpga_gpio_rst_c));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(8[5:18])
    IB fpga_gpio_i_pad_0 (.I(fpga_gpio_i[0]), .O(fpga_gpio_i_c_0));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(6[5:16])
    IB fpga_gpio_i_pad_1 (.I(fpga_gpio_i[1]), .O(fpga_gpio_i_c_1));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(6[5:16])
    IB fpga_gpio_i_pad_2 (.I(fpga_gpio_i[2]), .O(fpga_gpio_i_c_2));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(6[5:16])
    IB fpga_gpio_i_pad_3 (.I(fpga_gpio_i[3]), .O(fpga_gpio_i_c_3));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(6[5:16])
    OB fpga_gpio_o_pad_0 (.I(fpga_gpio_o_c_0), .O(fpga_gpio_o[0]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(7[5:16])
    OB fpga_gpio_o_pad_1 (.I(fpga_gpio_o_c_1), .O(fpga_gpio_o[1]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(7[5:16])
    OB fpga_gpio_o_pad_2 (.I(fpga_gpio_o_c_2), .O(fpga_gpio_o[2]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(7[5:16])
    LUT4 print_state_3__I_0_i4_4_lut (.A(print_state[3]), .B(n379), .C(visit_complete), 
         .D(n2257), .Z(fpga_gpio_o_c_3)) /* synthesis lut_function=(A (B+(C+(D)))+!A !(B (C)+!B (C+!(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(23[18] 24[16])
    defparam print_state_3__I_0_i4_4_lut.init = 16'hafac;
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    LUT4 m1_lut (.Z(n2643)) /* synthesis lut_function=1, syn_instantiated=1 */ ;
    defparam m1_lut.init = 16'hffff;
    PRINT_FLAG print_flag (.GND_net(GND_net), .fpga_gpio_clock_c(fpga_gpio_clock_c), 
            .visit_complete(visit_complete), .print_state({print_state}), 
            .fpga_gpio_rst_c(fpga_gpio_rst_c), .n495(n495));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(36[16:38])
    FSM_CHALL chall (.fpga_gpio_clock_c(fpga_gpio_clock_c), .n2643(n2643), 
            .fpga_gpio_i_c_2(fpga_gpio_i_c_2), .visit_complete(visit_complete), 
            .fpga_gpio_i_c_3(fpga_gpio_i_c_3), .fpga_gpio_i_c_0(fpga_gpio_i_c_0), 
            .fpga_gpio_i_c_1(fpga_gpio_i_c_1), .n7(n7_adj_144), .n379(n379), 
            .n9(n9), .n10(n10), .n7_adj_1(n7), .n2257(n2257), .n8(n8), 
            .n8_adj_2(n8_adj_143));   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(26[11:32])
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PRINT_FLAG
//

module PRINT_FLAG (GND_net, fpga_gpio_clock_c, visit_complete, print_state, 
            fpga_gpio_rst_c, n495);
    input GND_net;
    input fpga_gpio_clock_c;
    input visit_complete;
    output [3:0]print_state;
    input fpga_gpio_rst_c;
    output n495;
    
    wire fpga_gpio_clock_c /* synthesis SET_AS_NETWORK=fpga_gpio_clock_c, is_clock=1 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(9[5:20])
    
    wire n1996;
    wire [31:0]char_idx;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(18[10:18])
    
    wire n1997, n2003, n2004, n2021;
    wire [31:0]char_idx_31__N_52;
    
    wire n2022;
    wire [7:0]current_char;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(20[10:22])
    
    wire fpga_gpio_clock_c_enable_8, n2367, n2406, n2517;
    wire [6:0]n6;
    
    wire n2457, n2447, n2410, nibble_select_N_138, fpga_gpio_clock_c_enable_43, 
        n2020, n2019, n2018, n2017, n2002, n2001, n2016, n2015, 
        n2000, n15, n30, n2455, nibble_select;
    wire [3:0]n50;
    
    wire n2456, n2409, n2516, n2515, n2014, n2013, n1999, n2012, 
        n1403, n2011, n2010, n2009, n2008, n2408, n1998, n2007, 
        n2365, n2366, n2027, n2246, nibble_select_N_137, n2026, 
        n2006, n2404, n2445, n2025, n2005, n2024, n2405, n2023, 
        n2446;
    
    CCU2D add_1756_3 (.A0(char_idx[1]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[2]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1996), .COUT(n1997));
    defparam add_1756_3.INIT0 = 16'hf555;
    defparam add_1756_3.INIT1 = 16'hf555;
    defparam add_1756_3.INJECT1_0 = "NO";
    defparam add_1756_3.INJECT1_1 = "NO";
    CCU2D add_1756_17 (.A0(char_idx[15]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[16]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2003), .COUT(n2004));
    defparam add_1756_17.INIT0 = 16'hf555;
    defparam add_1756_17.INIT1 = 16'hf555;
    defparam add_1756_17.INJECT1_0 = "NO";
    defparam add_1756_17.INJECT1_1 = "NO";
    CCU2D add_530_21 (.A0(char_idx[19]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[20]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2021), .COUT(n2022), .S0(char_idx_31__N_52[19]), .S1(char_idx_31__N_52[20]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_21.INIT0 = 16'h5aaa;
    defparam add_530_21.INIT1 = 16'h5aaa;
    defparam add_530_21.INJECT1_0 = "NO";
    defparam add_530_21.INJECT1_1 = "NO";
    FD1P3AX current_char_i0 (.D(n2367), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i0.GSR = "DISABLED";
    FD1S3AY char_idx_i0 (.D(char_idx_31__N_52[0]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[0])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i0.GSR = "ENABLED";
    FD1S3AX char_idx_i1 (.D(char_idx_31__N_52[1]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i1.GSR = "ENABLED";
    FD1S3AX char_idx_i2 (.D(char_idx_31__N_52[2]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i2.GSR = "ENABLED";
    FD1S3AX char_idx_i3 (.D(char_idx_31__N_52[3]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i3.GSR = "ENABLED";
    FD1S3AX char_idx_i4 (.D(char_idx_31__N_52[4]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i4.GSR = "ENABLED";
    FD1S3AX char_idx_i5 (.D(char_idx_31__N_52[5]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i5.GSR = "ENABLED";
    FD1S3AX char_idx_i6 (.D(char_idx_31__N_52[6]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i6.GSR = "ENABLED";
    FD1S3AX char_idx_i7 (.D(char_idx_31__N_52[7]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i7.GSR = "ENABLED";
    FD1S3AX char_idx_i8 (.D(char_idx_31__N_52[8]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[8])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i8.GSR = "ENABLED";
    FD1S3AX char_idx_i9 (.D(char_idx_31__N_52[9]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[9])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i9.GSR = "ENABLED";
    FD1S3AX char_idx_i10 (.D(char_idx_31__N_52[10]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[10])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i10.GSR = "ENABLED";
    FD1S3AX char_idx_i11 (.D(char_idx_31__N_52[11]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[11])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i11.GSR = "ENABLED";
    FD1S3AX char_idx_i12 (.D(char_idx_31__N_52[12]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[12])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i12.GSR = "ENABLED";
    FD1S3AX char_idx_i13 (.D(char_idx_31__N_52[13]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[13])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i13.GSR = "ENABLED";
    FD1S3AX char_idx_i14 (.D(char_idx_31__N_52[14]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[14])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i14.GSR = "ENABLED";
    FD1S3AX char_idx_i15 (.D(char_idx_31__N_52[15]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[15])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i15.GSR = "ENABLED";
    FD1S3AX char_idx_i16 (.D(char_idx_31__N_52[16]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[16])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i16.GSR = "ENABLED";
    FD1S3AX char_idx_i17 (.D(char_idx_31__N_52[17]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[17])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i17.GSR = "ENABLED";
    FD1S3AX char_idx_i18 (.D(char_idx_31__N_52[18]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[18])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i18.GSR = "ENABLED";
    FD1S3AX char_idx_i19 (.D(char_idx_31__N_52[19]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[19])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i19.GSR = "ENABLED";
    FD1S3AX char_idx_i20 (.D(char_idx_31__N_52[20]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[20])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i20.GSR = "ENABLED";
    FD1S3AX char_idx_i21 (.D(char_idx_31__N_52[21]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[21])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i21.GSR = "ENABLED";
    FD1S3AX char_idx_i22 (.D(char_idx_31__N_52[22]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[22])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i22.GSR = "ENABLED";
    FD1S3AX char_idx_i23 (.D(char_idx_31__N_52[23]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[23])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i23.GSR = "ENABLED";
    FD1S3AX char_idx_i24 (.D(char_idx_31__N_52[24]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[24])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i24.GSR = "ENABLED";
    FD1S3AX char_idx_i25 (.D(char_idx_31__N_52[25]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[25])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i25.GSR = "ENABLED";
    FD1S3AX char_idx_i26 (.D(char_idx_31__N_52[26]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[26])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i26.GSR = "ENABLED";
    FD1S3AX char_idx_i27 (.D(char_idx_31__N_52[27]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[27])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i27.GSR = "ENABLED";
    FD1S3AX char_idx_i28 (.D(char_idx_31__N_52[28]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[28])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i28.GSR = "ENABLED";
    FD1S3AX char_idx_i29 (.D(char_idx_31__N_52[29]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[29])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i29.GSR = "ENABLED";
    FD1S3AX char_idx_i30 (.D(char_idx_31__N_52[30]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[30])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i30.GSR = "ENABLED";
    FD1S3AX char_idx_i31 (.D(char_idx_31__N_52[31]), .CK(fpga_gpio_clock_c), 
            .Q(char_idx[31])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam char_idx_i31.GSR = "ENABLED";
    FD1P3AX current_char_i1 (.D(n2406), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i1.GSR = "DISABLED";
    FD1P3AX current_char_i2 (.D(n2517), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i2.GSR = "DISABLED";
    FD1P3AX current_char_i3 (.D(n6[3]), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i3.GSR = "DISABLED";
    FD1P3AX current_char_i4 (.D(n2457), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i4.GSR = "DISABLED";
    FD1P3AY current_char_i5 (.D(n2447), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[5])) /* synthesis lse_init_val=1, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i5.GSR = "DISABLED";
    FD1P3AX current_char_i6 (.D(n2410), .SP(fpga_gpio_clock_c_enable_8), 
            .CK(fpga_gpio_clock_c), .Q(current_char[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam current_char_i6.GSR = "DISABLED";
    LUT4 i437_2_lut_rep_36 (.A(nibble_select_N_138), .B(visit_complete), 
         .Z(fpga_gpio_clock_c_enable_43)) /* synthesis lut_function=(A (B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(32[7] 51[14])
    defparam i437_2_lut_rep_36.init = 16'h8888;
    CCU2D add_530_19 (.A0(char_idx[17]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[18]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2020), .COUT(n2021), .S0(char_idx_31__N_52[17]), .S1(char_idx_31__N_52[18]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_19.INIT0 = 16'h5aaa;
    defparam add_530_19.INIT1 = 16'h5aaa;
    defparam add_530_19.INJECT1_0 = "NO";
    defparam add_530_19.INJECT1_1 = "NO";
    CCU2D add_530_17 (.A0(char_idx[15]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[16]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2019), .COUT(n2020), .S0(char_idx_31__N_52[15]), .S1(char_idx_31__N_52[16]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_17.INIT0 = 16'h5aaa;
    defparam add_530_17.INIT1 = 16'h5aaa;
    defparam add_530_17.INJECT1_0 = "NO";
    defparam add_530_17.INJECT1_1 = "NO";
    CCU2D add_530_15 (.A0(char_idx[13]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[14]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2018), .COUT(n2019), .S0(char_idx_31__N_52[13]), .S1(char_idx_31__N_52[14]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_15.INIT0 = 16'h5aaa;
    defparam add_530_15.INIT1 = 16'h5aaa;
    defparam add_530_15.INJECT1_0 = "NO";
    defparam add_530_15.INJECT1_1 = "NO";
    CCU2D add_530_13 (.A0(char_idx[11]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[12]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2017), .COUT(n2018), .S0(char_idx_31__N_52[11]), .S1(char_idx_31__N_52[12]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_13.INIT0 = 16'h5aaa;
    defparam add_530_13.INIT1 = 16'h5aaa;
    defparam add_530_13.INJECT1_0 = "NO";
    defparam add_530_13.INJECT1_1 = "NO";
    CCU2D add_1756_15 (.A0(char_idx[13]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[14]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2002), .COUT(n2003));
    defparam add_1756_15.INIT0 = 16'hf555;
    defparam add_1756_15.INIT1 = 16'hf555;
    defparam add_1756_15.INJECT1_0 = "NO";
    defparam add_1756_15.INJECT1_1 = "NO";
    CCU2D add_1756_13 (.A0(char_idx[11]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[12]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2001), .COUT(n2002));
    defparam add_1756_13.INIT0 = 16'hf555;
    defparam add_1756_13.INIT1 = 16'hf555;
    defparam add_1756_13.INJECT1_0 = "NO";
    defparam add_1756_13.INJECT1_1 = "NO";
    CCU2D add_530_11 (.A0(char_idx[9]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[10]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2016), .COUT(n2017), .S0(char_idx_31__N_52[9]), .S1(char_idx_31__N_52[10]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_11.INIT0 = 16'h5aaa;
    defparam add_530_11.INIT1 = 16'h5aaa;
    defparam add_530_11.INJECT1_0 = "NO";
    defparam add_530_11.INJECT1_1 = "NO";
    CCU2D add_530_9 (.A0(char_idx[7]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[8]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2015), .COUT(n2016), .S0(char_idx_31__N_52[7]), .S1(char_idx_31__N_52[8]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_9.INIT0 = 16'h5aaa;
    defparam add_530_9.INIT1 = 16'h5aaa;
    defparam add_530_9.INJECT1_0 = "NO";
    defparam add_530_9.INJECT1_1 = "NO";
    CCU2D add_1756_11 (.A0(char_idx[9]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[10]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2000), .COUT(n2001));
    defparam add_1756_11.INIT0 = 16'hf555;
    defparam add_1756_11.INIT1 = 16'hf555;
    defparam add_1756_11.INJECT1_0 = "NO";
    defparam add_1756_11.INJECT1_1 = "NO";
    PFUMX mux_7_Mux_3_i31 (.BLUT(n15), .ALUT(n30), .C0(char_idx[4]), .Z(n6[3])) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;
    LUT4 char_idx_3__bdd_3_lut (.A(char_idx[3]), .B(char_idx[0]), .C(char_idx[1]), 
         .Z(n2455)) /* synthesis lut_function=(!(A+!(B+!(C)))) */ ;
    defparam char_idx_3__bdd_3_lut.init = 16'h4545;
    LUT4 mux_11_i1_3_lut (.A(current_char[0]), .B(current_char[4]), .C(nibble_select), 
         .Z(n50[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam mux_11_i1_3_lut.init = 16'hcaca;
    LUT4 char_idx_3__bdd_4_lut (.A(char_idx[3]), .B(char_idx[2]), .C(char_idx[0]), 
         .D(char_idx[1]), .Z(n2456)) /* synthesis lut_function=(!(A (B (C (D))+!B !((D)+!C))+!A !(B (C+(D))+!B (C (D))))) */ ;
    defparam char_idx_3__bdd_4_lut.init = 16'h7eca;
    LUT4 char_idx_3__bdd_4_lut_2124 (.A(char_idx[3]), .B(char_idx[4]), .C(char_idx[2]), 
         .D(char_idx[1]), .Z(n2409)) /* synthesis lut_function=(!(A (B+!(C (D)+!C !(D)))+!A !(B (D)+!B !(C (D)+!C !(D))))) */ ;
    defparam char_idx_3__bdd_4_lut_2124.init = 16'h6512;
    LUT4 mux_7_Mux_2_i31_then_4_lut (.A(char_idx[4]), .B(char_idx[3]), .C(char_idx[1]), 
         .D(char_idx[2]), .Z(n2516)) /* synthesis lut_function=(!(A (B+!(C (D)+!C !(D)))+!A (B (C)+!B (C+(D))))) */ ;
    defparam mux_7_Mux_2_i31_then_4_lut.init = 16'h2407;
    LUT4 mux_7_Mux_2_i31_else_4_lut (.A(char_idx[4]), .B(char_idx[3]), .C(char_idx[1]), 
         .D(char_idx[2]), .Z(n2515)) /* synthesis lut_function=(!(A (B+(C (D)+!C !(D)))+!A !(B (C (D))))) */ ;
    defparam mux_7_Mux_2_i31_else_4_lut.init = 16'h4220;
    CCU2D add_530_7 (.A0(char_idx[5]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[6]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2014), .COUT(n2015), .S0(char_idx_31__N_52[5]), .S1(char_idx_31__N_52[6]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_7.INIT0 = 16'h5aaa;
    defparam add_530_7.INIT1 = 16'h5aaa;
    defparam add_530_7.INJECT1_0 = "NO";
    defparam add_530_7.INJECT1_1 = "NO";
    CCU2D add_1756_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[0]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .COUT(n1996));
    defparam add_1756_1.INIT0 = 16'hF000;
    defparam add_1756_1.INIT1 = 16'h0aaa;
    defparam add_1756_1.INJECT1_0 = "NO";
    defparam add_1756_1.INJECT1_1 = "NO";
    CCU2D add_530_5 (.A0(char_idx[3]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[4]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2013), .COUT(n2014), .S0(char_idx_31__N_52[3]), .S1(char_idx_31__N_52[4]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_5.INIT0 = 16'h5aaa;
    defparam add_530_5.INIT1 = 16'h5aaa;
    defparam add_530_5.INJECT1_0 = "NO";
    defparam add_530_5.INJECT1_1 = "NO";
    CCU2D add_1756_9 (.A0(char_idx[7]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[8]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1999), .COUT(n2000));
    defparam add_1756_9.INIT0 = 16'hf555;
    defparam add_1756_9.INIT1 = 16'hf555;
    defparam add_1756_9.INJECT1_0 = "NO";
    defparam add_1756_9.INJECT1_1 = "NO";
    CCU2D add_530_3 (.A0(char_idx[1]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[2]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2012), .COUT(n2013), .S0(char_idx_31__N_52[1]), .S1(char_idx_31__N_52[2]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_3.INIT0 = 16'h5aaa;
    defparam add_530_3.INIT1 = 16'h5aaa;
    defparam add_530_3.INJECT1_0 = "NO";
    defparam add_530_3.INJECT1_1 = "NO";
    CCU2D add_530_1 (.A0(GND_net), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(visit_complete), .B1(n1403), .C1(char_idx[0]), .D1(GND_net), 
          .COUT(n2012), .S1(char_idx_31__N_52[0]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_1.INIT0 = 16'hF000;
    defparam add_530_1.INIT1 = 16'h7878;
    defparam add_530_1.INJECT1_0 = "NO";
    defparam add_530_1.INJECT1_1 = "NO";
    CCU2D add_1756_33 (.A0(char_idx[31]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2011), .S1(nibble_select_N_138));
    defparam add_1756_33.INIT0 = 16'h5555;
    defparam add_1756_33.INIT1 = 16'h0000;
    defparam add_1756_33.INJECT1_0 = "NO";
    defparam add_1756_33.INJECT1_1 = "NO";
    CCU2D add_1756_31 (.A0(char_idx[29]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[30]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2010), .COUT(n2011));
    defparam add_1756_31.INIT0 = 16'hf555;
    defparam add_1756_31.INIT1 = 16'hf555;
    defparam add_1756_31.INJECT1_0 = "NO";
    defparam add_1756_31.INJECT1_1 = "NO";
    CCU2D add_1756_29 (.A0(char_idx[27]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[28]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2009), .COUT(n2010));
    defparam add_1756_29.INIT0 = 16'hf555;
    defparam add_1756_29.INIT1 = 16'hf555;
    defparam add_1756_29.INJECT1_0 = "NO";
    defparam add_1756_29.INJECT1_1 = "NO";
    CCU2D add_1756_27 (.A0(char_idx[25]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[26]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2008), .COUT(n2009));
    defparam add_1756_27.INIT0 = 16'hf555;
    defparam add_1756_27.INIT1 = 16'hf555;
    defparam add_1756_27.INJECT1_0 = "NO";
    defparam add_1756_27.INJECT1_1 = "NO";
    LUT4 char_idx_3__bdd_2_lut (.A(char_idx[3]), .B(char_idx[4]), .Z(n2408)) /* synthesis lut_function=(!(A (B))) */ ;
    defparam char_idx_3__bdd_2_lut.init = 16'h7777;
    CCU2D add_1756_7 (.A0(char_idx[5]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[6]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1998), .COUT(n1999));
    defparam add_1756_7.INIT0 = 16'hf555;
    defparam add_1756_7.INIT1 = 16'hf555;
    defparam add_1756_7.INJECT1_0 = "NO";
    defparam add_1756_7.INJECT1_1 = "NO";
    CCU2D add_1756_25 (.A0(char_idx[23]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[24]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2007), .COUT(n2008));
    defparam add_1756_25.INIT0 = 16'hf555;
    defparam add_1756_25.INIT1 = 16'hf555;
    defparam add_1756_25.INJECT1_0 = "NO";
    defparam add_1756_25.INJECT1_1 = "NO";
    LUT4 char_idx_3__bdd_3_lut_2123 (.A(char_idx[2]), .B(char_idx[1]), .C(char_idx[4]), 
         .Z(n2365)) /* synthesis lut_function=(!((B+(C))+!A)) */ ;
    defparam char_idx_3__bdd_3_lut_2123.init = 16'h0202;
    LUT4 char_idx_3__bdd_4_lut_2098 (.A(char_idx[0]), .B(char_idx[2]), .C(char_idx[1]), 
         .D(char_idx[4]), .Z(n2366)) /* synthesis lut_function=(A (B (C (D)+!C !(D))+!B !(C (D)))+!A !(B (D)+!B !(C+(D)))) */ ;
    defparam char_idx_3__bdd_4_lut_2098.init = 16'h937e;
    CCU2D add_530_33 (.A0(char_idx[31]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(GND_net), .B1(GND_net), .C1(GND_net), .D1(GND_net), .CIN(n2027), 
          .S0(char_idx_31__N_52[31]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_33.INIT0 = 16'h5aaa;
    defparam add_530_33.INIT1 = 16'h0000;
    defparam add_530_33.INJECT1_0 = "NO";
    defparam add_530_33.INJECT1_1 = "NO";
    LUT4 i1_2_lut_3_lut (.A(nibble_select_N_138), .B(visit_complete), .C(nibble_select), 
         .Z(n2246)) /* synthesis lut_function=(A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(32[7] 51[14])
    defparam i1_2_lut_3_lut.init = 16'h8080;
    LUT4 nibble_select_I_0_2_lut (.A(nibble_select), .B(nibble_select_N_138), 
         .Z(nibble_select_N_137)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(34[9] 50[16])
    defparam nibble_select_I_0_2_lut.init = 16'h6666;
    CCU2D add_530_31 (.A0(char_idx[29]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[30]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2026), .COUT(n2027), .S0(char_idx_31__N_52[29]), .S1(char_idx_31__N_52[30]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_31.INIT0 = 16'h5aaa;
    defparam add_530_31.INIT1 = 16'h5aaa;
    defparam add_530_31.INJECT1_0 = "NO";
    defparam add_530_31.INJECT1_1 = "NO";
    CCU2D add_1756_23 (.A0(char_idx[21]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[22]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2006), .COUT(n2007));
    defparam add_1756_23.INIT0 = 16'hf555;
    defparam add_1756_23.INIT1 = 16'hf555;
    defparam add_1756_23.INJECT1_0 = "NO";
    defparam add_1756_23.INJECT1_1 = "NO";
    LUT4 char_idx_1__bdd_2_lut (.A(char_idx[3]), .B(char_idx[2]), .Z(n2404)) /* synthesis lut_function=(!(A+(B))) */ ;
    defparam char_idx_1__bdd_2_lut.init = 16'h1111;
    LUT4 mux_11_i3_3_lut (.A(current_char[2]), .B(current_char[6]), .C(nibble_select), 
         .Z(n50[2])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam mux_11_i3_3_lut.init = 16'hcaca;
    LUT4 mux_11_i2_3_lut (.A(current_char[1]), .B(current_char[5]), .C(nibble_select), 
         .Z(n50[1])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam mux_11_i2_3_lut.init = 16'hcaca;
    PFUMX i2143 (.BLUT(n2515), .ALUT(n2516), .C0(char_idx[0]), .Z(n2517));
    LUT4 char_idx_1__bdd_3_lut (.A(char_idx[4]), .B(char_idx[3]), .C(char_idx[2]), 
         .Z(n2445)) /* synthesis lut_function=(!(A (B)+!A !(B+(C)))) */ ;
    defparam char_idx_1__bdd_3_lut.init = 16'h7676;
    CCU2D add_530_29 (.A0(char_idx[27]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[28]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2025), .COUT(n2026), .S0(char_idx_31__N_52[27]), .S1(char_idx_31__N_52[28]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_29.INIT0 = 16'h5aaa;
    defparam add_530_29.INIT1 = 16'h5aaa;
    defparam add_530_29.INJECT1_0 = "NO";
    defparam add_530_29.INJECT1_1 = "NO";
    CCU2D add_1756_21 (.A0(char_idx[19]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[20]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2005), .COUT(n2006));
    defparam add_1756_21.INIT0 = 16'hf555;
    defparam add_1756_21.INIT1 = 16'hf555;
    defparam add_1756_21.INJECT1_0 = "NO";
    defparam add_1756_21.INJECT1_1 = "NO";
    CCU2D add_530_27 (.A0(char_idx[25]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[26]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2024), .COUT(n2025), .S0(char_idx_31__N_52[25]), .S1(char_idx_31__N_52[26]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_27.INIT0 = 16'h5aaa;
    defparam add_530_27.INIT1 = 16'h5aaa;
    defparam add_530_27.INJECT1_0 = "NO";
    defparam add_530_27.INJECT1_1 = "NO";
    LUT4 char_idx_1__bdd_4_lut_2120 (.A(char_idx[1]), .B(char_idx[3]), .C(char_idx[2]), 
         .D(char_idx[0]), .Z(n2405)) /* synthesis lut_function=(!(A (B (C+!(D))+!B (C (D)))+!A !(C))) */ ;
    defparam char_idx_1__bdd_4_lut_2120.init = 16'h5a72;
    FD1P3AX half_byte_i0_i2 (.D(n50[2]), .SP(fpga_gpio_clock_c_enable_43), 
            .CK(fpga_gpio_clock_c), .Q(print_state[2])) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam half_byte_i0_i2.GSR = "ENABLED";
    FD1P3AX half_byte_i0_i1 (.D(n50[1]), .SP(fpga_gpio_clock_c_enable_43), 
            .CK(fpga_gpio_clock_c), .Q(print_state[1])) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam half_byte_i0_i1.GSR = "ENABLED";
    CCU2D add_1756_5 (.A0(char_idx[3]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[4]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n1997), .COUT(n1998));
    defparam add_1756_5.INIT0 = 16'h0aaa;
    defparam add_1756_5.INIT1 = 16'h0aaa;
    defparam add_1756_5.INJECT1_0 = "NO";
    defparam add_1756_5.INJECT1_1 = "NO";
    PFUMX i2075 (.BLUT(n2366), .ALUT(n2365), .C0(char_idx[3]), .Z(n2367));
    CCU2D add_1756_19 (.A0(char_idx[17]), .B0(GND_net), .C0(GND_net), 
          .D0(GND_net), .A1(char_idx[18]), .B1(GND_net), .C1(GND_net), 
          .D1(GND_net), .CIN(n2004), .COUT(n2005));
    defparam add_1756_19.INIT0 = 16'hf555;
    defparam add_1756_19.INIT1 = 16'hf555;
    defparam add_1756_19.INJECT1_0 = "NO";
    defparam add_1756_19.INJECT1_1 = "NO";
    CCU2D add_530_25 (.A0(char_idx[23]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[24]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2023), .COUT(n2024), .S0(char_idx_31__N_52[23]), .S1(char_idx_31__N_52[24]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_25.INIT0 = 16'h5aaa;
    defparam add_530_25.INIT1 = 16'h5aaa;
    defparam add_530_25.INJECT1_0 = "NO";
    defparam add_530_25.INJECT1_1 = "NO";
    CCU2D add_530_23 (.A0(char_idx[21]), .B0(GND_net), .C0(GND_net), .D0(GND_net), 
          .A1(char_idx[22]), .B1(GND_net), .C1(GND_net), .D1(GND_net), 
          .CIN(n2022), .COUT(n2023), .S0(char_idx_31__N_52[21]), .S1(char_idx_31__N_52[22]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(42[11] 49[18])
    defparam add_530_23.INIT0 = 16'h5aaa;
    defparam add_530_23.INIT1 = 16'h5aaa;
    defparam add_530_23.INJECT1_0 = "NO";
    defparam add_530_23.INJECT1_1 = "NO";
    LUT4 i1_2_lut_3_lut_adj_20 (.A(nibble_select_N_138), .B(visit_complete), 
         .C(fpga_gpio_rst_c), .Z(fpga_gpio_clock_c_enable_8)) /* synthesis lut_function=(!(((C)+!B)+!A)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(32[7] 51[14])
    defparam i1_2_lut_3_lut_adj_20.init = 16'h0808;
    LUT4 i1191_4_lut_4_lut (.A(char_idx[1]), .B(char_idx[2]), .C(char_idx[3]), 
         .D(char_idx[0]), .Z(n15)) /* synthesis lut_function=(A (B (D))+!A (B (D)+!B (C (D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(36[32:40])
    defparam i1191_4_lut_4_lut.init = 16'hdc00;
    LUT4 i1223_2_lut (.A(nibble_select), .B(nibble_select_N_138), .Z(n1403)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1223_2_lut.init = 16'h8888;
    FD1P3AX half_byte_i0_i0 (.D(n50[0]), .SP(fpga_gpio_clock_c_enable_43), 
            .CK(fpga_gpio_clock_c), .Q(print_state[0])) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam half_byte_i0_i0.GSR = "ENABLED";
    FD1P3IX half_byte_i0_i3 (.D(current_char[3]), .SP(fpga_gpio_clock_c_enable_43), 
            .CD(n2246), .CK(fpga_gpio_clock_c), .Q(print_state[3])) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam half_byte_i0_i3.GSR = "ENABLED";
    LUT4 i441_1_lut (.A(fpga_gpio_rst_c), .Z(n495)) /* synthesis lut_function=(!(A)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(8[5:18])
    defparam i441_1_lut.init = 16'h5555;
    PFUMX i2096 (.BLUT(n2405), .ALUT(n2404), .C0(char_idx[4]), .Z(n2406));
    FD1P3AX nibble_select_29 (.D(nibble_select_N_137), .SP(visit_complete), 
            .CK(fpga_gpio_clock_c), .Q(nibble_select)) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=16, LSE_RCOL=38, LSE_LLINE=36, LSE_RLINE=36 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(26[5] 52[12])
    defparam nibble_select_29.GSR = "ENABLED";
    LUT4 i1192_4_lut_4_lut_4_lut (.A(char_idx[0]), .B(char_idx[1]), .C(char_idx[2]), 
         .D(char_idx[3]), .Z(n30)) /* synthesis lut_function=(!(A (B ((D)+!C)+!B (C+(D)))+!A (((D)+!C)+!B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/print_flag.vhd(36[32:40])
    defparam i1192_4_lut_4_lut_4_lut.init = 16'h00c2;
    LUT4 char_idx_1__bdd_4_lut (.A(char_idx[4]), .B(char_idx[0]), .C(char_idx[3]), 
         .D(char_idx[2]), .Z(n2446)) /* synthesis lut_function=(!(A (B (C+!(D))+!B (C (D)))+!A (B (C (D)+!C !(D))+!B !(C)))) */ ;
    defparam char_idx_1__bdd_4_lut.init = 16'h1e72;
    PFUMX i2125 (.BLUT(n2456), .ALUT(n2455), .C0(char_idx[4]), .Z(n2457));
    PFUMX i2121 (.BLUT(n2446), .ALUT(n2445), .C0(char_idx[1]), .Z(n2447));
    PFUMX i2099 (.BLUT(n2409), .ALUT(n2408), .C0(char_idx[0]), .Z(n2410));
    
endmodule
//
// Verilog Description of module FSM_CHALL
//

module FSM_CHALL (fpga_gpio_clock_c, n2643, fpga_gpio_i_c_2, visit_complete, 
            fpga_gpio_i_c_3, fpga_gpio_i_c_0, fpga_gpio_i_c_1, n7, n379, 
            n9, n10, n7_adj_1, n2257, n8, n8_adj_2);
    input fpga_gpio_clock_c;
    input n2643;
    input fpga_gpio_i_c_2;
    output visit_complete;
    input fpga_gpio_i_c_3;
    input fpga_gpio_i_c_0;
    input fpga_gpio_i_c_1;
    output n7;
    output n379;
    output n9;
    output n10;
    output n7_adj_1;
    output n2257;
    output n8;
    output n8_adj_2;
    
    wire fpga_gpio_clock_c /* synthesis SET_AS_NETWORK=fpga_gpio_clock_c, is_clock=1 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/top_entity.vhd(9[5:20])
    wire [15:0]visited;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(19[10:17])
    
    wire fpga_gpio_clock_c_enable_1, n2514, n2641, n114, n2262, n843;
    wire [0:0]n573;
    
    wire n2307;
    wire [0:0]n583;
    wire [15:0]n371;
    
    wire n442, n1359, n810, n2051, broken, broken_N_43, fpga_gpio_clock_c_enable_22, 
        n2508, n447, n2028, n808, n2054, n17, n30, n26, n18, 
        n2231, n2639, n2233, n806, n2524, n2500, n2036, n2503, 
        n2493, n2407, n2047, n805, n2496, n2518, n838, n839, 
        n2499, n172, n4, n2083, n4_adj_139, n2234, n2490, n986, 
        n2498, n2488, n2512, n2244, n2511, n410, n796, n2056, 
        n2265, n1385;
    wire [0:0]n560;
    
    wire n2465, n2489, n2464, n2502, n2522, fpga_gpio_clock_c_enable_41, 
        n2513, fpga_gpio_clock_c_enable_14, n2043, fpga_gpio_clock_c_enable_13, 
        fpga_gpio_clock_c_enable_12, fpga_gpio_clock_c_enable_27, fpga_gpio_clock_c_enable_44, 
        n965, n842, n2495, n2376, n2501, fpga_gpio_clock_c_enable_15, 
        fpga_gpio_clock_c_enable_16;
    wire [0:0]n536;
    
    wire n2310, n2279, n2290, n2300, n28, n22, n846, n2504, 
        n2509, fpga_gpio_clock_c_enable_17, n2640, n2055, n794, n795, 
        n2519, n2494, n2287, n1070;
    wire [0:0]n524;
    
    wire n1055, fpga_gpio_clock_c_enable_18, fpga_gpio_clock_c_enable_19, 
        fpga_gpio_clock_c_enable_20, n1069, fpga_gpio_clock_c_enable_21, 
        fpga_gpio_clock_c_enable_23, fpga_gpio_clock_c_enable_24, fpga_gpio_clock_c_enable_25, 
        fpga_gpio_clock_c_enable_26, n2044, n821, n819, n817, n2050, 
        n2037, n2466, n1012, n2523, n2497, n822;
    wire [0:0]n542;
    
    wire n7_adj_141, n339, n2377, n814, n1409, n812;
    
    FD1P3AX visited_i0_i0 (.D(n2643), .SP(fpga_gpio_clock_c_enable_1), .CK(fpga_gpio_clock_c), 
            .Q(visited[0])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i0.GSR = "ENABLED";
    LUT4 i1_2_lut_4_lut (.A(n2514), .B(n2641), .C(fpga_gpio_i_c_2), .D(n114), 
         .Z(n2262)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i1_2_lut_4_lut.init = 16'hffec;
    L6MUX21 mux_513_i1 (.D0(n843), .D1(n573[0]), .SD(n2307), .Z(n583[0]));
    LUT4 i2_4_lut (.A(n371[13]), .B(n442), .C(n1359), .D(n810), .Z(n2051)) /* synthesis lut_function=(A (B+((D)+!C))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_4_lut.init = 16'hffce;
    LUT4 i704_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[5]), .Z(fpga_gpio_clock_c_enable_22)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i704_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i394_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n371[4]), .D(n2508), .Z(n447)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i394_2_lut_3_lut_4_lut.init = 16'h0020;
    LUT4 i2_4_lut_adj_1 (.A(n114), .B(n2028), .C(n371[10]), .D(n808), 
         .Z(n2054)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_4_lut_adj_1.init = 16'hffec;
    LUT4 i15_4_lut (.A(n17), .B(n30), .C(n26), .D(n18), .Z(visit_complete)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i15_4_lut.init = 16'h8000;
    LUT4 i1_3_lut_4_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(n2231), .D(n2639), .Z(n2233)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (C)+!B (C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(138[15] 145[24])
    defparam i1_3_lut_4_lut_4_lut.init = 16'hf9f0;
    LUT4 i1_4_lut_4_lut_rep_66 (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_3), .D(fpga_gpio_i_c_0), .Z(n2641)) /* synthesis lut_function=(!((B (C+(D))+!B (C+!(D)))+!A)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i1_4_lut_4_lut_rep_66.init = 16'h0208;
    LUT4 i3_4_lut (.A(n806), .B(n2524), .C(n2500), .D(n371[5]), .Z(n2036)) /* synthesis lut_function=(A+(B+(C (D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i3_4_lut.init = 16'hfeee;
    LUT4 i634_3_lut (.A(n371[6]), .B(fpga_gpio_i_c_2), .C(n2503), .Z(n806)) /* synthesis lut_function=(A ((C)+!B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i634_3_lut.init = 16'ha2a2;
    LUT4 i1_3_lut_rep_42_4_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_3), .D(fpga_gpio_i_c_0), .Z(n2493)) /* synthesis lut_function=(!(A (B (C)+!B (C+!(D)))+!A ((C+!(D))+!B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i1_3_lut_rep_42_4_lut_4_lut.init = 16'h0e08;
    LUT4 n7_bdd_4_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), .C(fpga_gpio_i_c_3), 
         .D(fpga_gpio_i_c_0), .Z(n2407)) /* synthesis lut_function=(A (C (D))+!A ((C (D))+!B)) */ ;
    defparam n7_bdd_4_lut_4_lut.init = 16'hf111;
    LUT4 i633_4_lut (.A(n371[5]), .B(n2500), .C(n2047), .D(n371[14]), 
         .Z(n805)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i633_4_lut.init = 16'heca0;
    LUT4 i3_4_lut_else_4_lut (.A(fpga_gpio_i_c_3), .B(n2496), .C(n2641), 
         .D(n2508), .Z(n2518)) /* synthesis lut_function=(A (B+(C+!(D)))+!A (B+(C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i3_4_lut_else_4_lut.init = 16'hfcfe;
    LUT4 i667_3_lut (.A(n838), .B(visited[5]), .C(n371[5]), .Z(n839)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i667_3_lut.init = 16'hcaca;
    LUT4 i1_4_lut (.A(n2499), .B(n371[4]), .C(n371[0]), .D(n172), .Z(n4)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i1_4_lut.init = 16'heca0;
    LUT4 i1_4_lut_adj_2 (.A(n2500), .B(n371[3]), .C(n371[2]), .D(n2083), 
         .Z(n4_adj_139)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i1_4_lut_adj_2.init = 16'heca0;
    LUT4 i3_4_lut_adj_3 (.A(fpga_gpio_i_c_0), .B(fpga_gpio_i_c_2), .C(fpga_gpio_i_c_1), 
         .D(fpga_gpio_i_c_3), .Z(n2083)) /* synthesis lut_function=(A+(B+!(C (D)))) */ ;
    defparam i3_4_lut_adj_3.init = 16'hefff;
    LUT4 i1_2_lut_rep_39_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(n2234), .D(n2514), .Z(n2490)) /* synthesis lut_function=(A (C)+!A (B (C+(D))+!B (C))) */ ;
    defparam i1_2_lut_rep_39_3_lut_4_lut.init = 16'hf4f0;
    LUT4 fpga_gpio_i_c_1_bdd_4_lut_2170 (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_3), .D(fpga_gpio_i_c_0), .Z(n986)) /* synthesis lut_function=(!(A (B+!(C))+!A !(B (C)+!B (C (D))))) */ ;
    defparam fpga_gpio_i_c_1_bdd_4_lut_2170.init = 16'h7060;
    LUT4 i1_3_lut_rep_37_4_lut (.A(n2498), .B(n2234), .C(fpga_gpio_i_c_3), 
         .D(n2508), .Z(n2488)) /* synthesis lut_function=(A+(B+!(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(43[15] 50[24])
    defparam i1_3_lut_rep_37_4_lut.init = 16'heeef;
    LUT4 i1_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n2512), .D(n371[11]), .Z(n2244)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i1_2_lut_3_lut_4_lut.init = 16'h8000;
    LUT4 i1174_2_lut_rep_60 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .Z(n2511)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1174_2_lut_rep_60.init = 16'heeee;
    LUT4 i357_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(n371[0]), .D(n2511), .Z(n410)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i357_2_lut_3_lut_4_lut.init = 16'h0040;
    LUT4 i2_4_lut_adj_4 (.A(n114), .B(n410), .C(n371[2]), .D(n796), 
         .Z(n2056)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_4_lut_adj_4.init = 16'hffec;
    LUT4 i624_4_lut (.A(n371[1]), .B(n2265), .C(n1385), .D(n2234), .Z(n796)) /* synthesis lut_function=(A (B+((D)+!C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i624_4_lut.init = 16'haa8a;
    LUT4 i3_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), .C(n371[6]), 
         .D(n2511), .Z(n2028)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i3_3_lut_4_lut.init = 16'h0040;
    LUT4 i1179_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_2), .D(fpga_gpio_i_c_1), .Z(n1359)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1179_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i3_2_lut_rep_64 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .Z(n2639)) /* synthesis lut_function=(A (B)) */ ;
    defparam i3_2_lut_rep_64.init = 16'h8888;
    LUT4 i1177_2_lut_rep_57 (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), .Z(n2508)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i1177_2_lut_rep_57.init = 16'heeee;
    LUT4 mux_493_i1_3_lut (.A(visited[15]), .B(visited[0]), .C(n371[0]), 
         .Z(n560[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam mux_493_i1_3_lut.init = 16'hcaca;
    LUT4 i4_2_lut_rep_45_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_2), .D(fpga_gpio_i_c_1), .Z(n2496)) /* synthesis lut_function=(!(A+(B+((D)+!C)))) */ ;
    defparam i4_2_lut_rep_45_3_lut_4_lut.init = 16'h0010;
    LUT4 i1205_2_lut_3_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .C(fpga_gpio_i_c_2), 
         .Z(n1385)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i1205_2_lut_3_lut.init = 16'hfefe;
    LUT4 i2_2_lut_rep_61 (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), .Z(n2512)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i2_2_lut_rep_61.init = 16'h2222;
    LUT4 n385_bdd_4_lut (.A(fpga_gpio_i_c_0), .B(n371[1]), .C(n2508), 
         .D(fpga_gpio_i_c_3), .Z(n2465)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam n385_bdd_4_lut.init = 16'h0008;
    LUT4 n385_bdd_4_lut_2130 (.A(n2490), .B(n2489), .C(n2508), .D(fpga_gpio_i_c_3), 
         .Z(n2464)) /* synthesis lut_function=(A+(B+!(C+(D)))) */ ;
    defparam n385_bdd_4_lut_2130.init = 16'heeef;
    LUT4 i4_2_lut_rep_48_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_0), .D(fpga_gpio_i_c_3), .Z(n2499)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i4_2_lut_rep_48_3_lut_4_lut.init = 16'h0200;
    LUT4 i636_2_lut_3_lut (.A(fpga_gpio_i_c_2), .B(n2503), .C(n371[7]), 
         .Z(n808)) /* synthesis lut_function=(A (C)+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(107[22:28])
    defparam i636_2_lut_3_lut.init = 16'he0e0;
    LUT4 i1_2_lut_rep_51_3_lut_2_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .Z(n2502)) /* synthesis lut_function=(!(A (B)+!A !(B))) */ ;
    defparam i1_2_lut_rep_51_3_lut_2_lut.init = 16'h6666;
    LUT4 i2_4_lut_else_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n371[9]), .D(fpga_gpio_i_c_2), .Z(n2522)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;
    defparam i2_4_lut_else_3_lut_4_lut.init = 16'h0080;
    LUT4 i2066_2_lut_rep_40 (.A(visit_complete), .B(broken), .Z(fpga_gpio_clock_c_enable_41)) /* synthesis lut_function=(!(A+(B))) */ ;
    defparam i2066_2_lut_rep_40.init = 16'h1111;
    LUT4 i2_3_lut_4_lut (.A(visit_complete), .B(broken), .C(visited[0]), 
         .D(n371[0]), .Z(fpga_gpio_clock_c_enable_1)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i2_3_lut_4_lut.init = 16'h0100;
    LUT4 i4_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_0), .D(fpga_gpio_i_c_3), .Z(n114)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i4_2_lut_3_lut_4_lut.init = 16'h0002;
    LUT4 i2_2_lut_rep_62 (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), .Z(n2513)) /* synthesis lut_function=(A (B)) */ ;
    defparam i2_2_lut_rep_62.init = 16'h8888;
    LUT4 i688_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[13]), .Z(fpga_gpio_clock_c_enable_14)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i688_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i2_3_lut_4_lut_adj_5 (.A(n2508), .B(n2514), .C(n371[5]), .D(n4), 
         .Z(n2043)) /* synthesis lut_function=(A (D)+!A (B (C+(D))+!B (D))) */ ;
    defparam i2_3_lut_4_lut_adj_5.init = 16'hff40;
    LUT4 i686_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[14]), .Z(fpga_gpio_clock_c_enable_13)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i686_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i2_2_lut (.A(n371[15]), .B(n371[3]), .Z(n7)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_2_lut.init = 16'heeee;
    LUT4 i638_3_lut_4_lut (.A(fpga_gpio_i_c_2), .B(n2639), .C(fpga_gpio_i_c_1), 
         .D(n379), .Z(n810)) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(D))+!A !(D))) */ ;
    defparam i638_3_lut_4_lut.init = 16'h7f00;
    LUT4 i4_2_lut_rep_49_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_0), .D(fpga_gpio_i_c_3), .Z(n2500)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i4_2_lut_rep_49_3_lut_4_lut.init = 16'h8000;
    LUT4 i3_2_lut_rep_63 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .Z(n2514)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i3_2_lut_rep_63.init = 16'h4444;
    LUT4 i684_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[15]), .Z(fpga_gpio_clock_c_enable_12)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i684_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i2_3_lut_4_lut_adj_6 (.A(visit_complete), .B(broken), .C(n371[9]), 
         .D(n2500), .Z(fpga_gpio_clock_c_enable_27)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;
    defparam i2_3_lut_4_lut_adj_6.init = 16'h1000;
    LUT4 i615_2_lut_3_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .Z(fpga_gpio_clock_c_enable_44)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i615_2_lut_3_lut.init = 16'h1010;
    LUT4 i2_3_lut (.A(n371[11]), .B(n371[13]), .C(n371[9]), .Z(n965)) /* synthesis lut_function=(A+(B+(C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_3_lut.init = 16'hfefe;
    LUT4 i3_2_lut (.A(n371[7]), .B(n371[3]), .Z(n9)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i3_2_lut.init = 16'heeee;
    LUT4 i670_3_lut (.A(visited[11]), .B(visited[12]), .C(n371[12]), .Z(n842)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i670_3_lut.init = 16'hcaca;
    LUT4 i4_2_lut_rep_44_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_2), .D(fpga_gpio_i_c_1), .Z(n2495)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i4_2_lut_rep_44_3_lut_4_lut.init = 16'h0004;
    LUT4 i4_2_lut_rep_47_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_2), .D(fpga_gpio_i_c_1), .Z(n2498)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i4_2_lut_rep_47_3_lut_4_lut.init = 16'h0040;
    LUT4 n8_bdd_4_lut (.A(n371[11]), .B(n379), .C(fpga_gpio_i_c_1), .D(fpga_gpio_i_c_2), 
         .Z(n2376)) /* synthesis lut_function=(A (B (D)+!B !(C+!(D)))+!A (B (C (D)))) */ ;
    defparam n8_bdd_4_lut.init = 16'hca00;
    LUT4 i4_4_lut (.A(n371[2]), .B(n371[6]), .C(n371[11]), .D(n2501), 
         .Z(n10)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i4_4_lut.init = 16'hfffe;
    LUT4 i690_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[12]), .Z(fpga_gpio_clock_c_enable_15)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i690_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i2_2_lut_adj_7 (.A(n371[12]), .B(n371[6]), .Z(n7_adj_1)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_2_lut_adj_7.init = 16'heeee;
    LUT4 i692_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[11]), .Z(fpga_gpio_clock_c_enable_16)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i692_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 mux_475_i1_3_lut (.A(visited[9]), .B(visited[10]), .C(n371[10]), 
         .Z(n536[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam mux_475_i1_3_lut.init = 16'hcaca;
    LUT4 i2067_2_lut (.A(n371[0]), .B(n371[15]), .Z(n2310)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i2067_2_lut.init = 16'heeee;
    LUT4 i666_3_lut (.A(visited[3]), .B(visited[4]), .C(n371[4]), .Z(n838)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i666_3_lut.init = 16'hcaca;
    LUT4 i2074_4_lut (.A(n379), .B(n371[7]), .C(n371[6]), .D(n2279), 
         .Z(n2290)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i2074_4_lut.init = 16'hfffe;
    LUT4 i2011_3_lut (.A(n371[5]), .B(n371[4]), .C(n371[3]), .Z(n2279)) /* synthesis lut_function=(!(A+(B+(C)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i2011_3_lut.init = 16'h0101;
    PFUMX i671 (.BLUT(n536[0]), .ALUT(n842), .C0(n2300), .Z(n843));
    LUT4 i1_2_lut (.A(visited[0]), .B(visited[6]), .Z(n17)) /* synthesis lut_function=(A (B)) */ ;
    defparam i1_2_lut.init = 16'h8888;
    LUT4 i14_4_lut (.A(visited[10]), .B(n28), .C(n22), .D(visited[12]), 
         .Z(n30)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i14_4_lut.init = 16'h8000;
    LUT4 mux_465_i1_4_lut (.A(n846), .B(n583[0]), .C(n371[0]), .D(n2257), 
         .Z(broken_N_43)) /* synthesis lut_function=(A (B+!(C+(D)))+!A (B (C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam mux_465_i1_4_lut.init = 16'hccca;
    LUT4 i3_3_lut_4_lut_adj_8 (.A(n371[13]), .B(n2504), .C(n371[4]), .D(n2509), 
         .Z(n8)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i3_3_lut_4_lut_adj_8.init = 16'hfffe;
    LUT4 i694_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[10]), .Z(fpga_gpio_clock_c_enable_17)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i694_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i2_3_lut_4_lut_adj_9 (.A(n2513), .B(n2640), .C(n371[14]), .D(n4_adj_139), 
         .Z(n2055)) /* synthesis lut_function=(A (B (C+(D))+!B (D))+!A (D)) */ ;
    defparam i2_3_lut_4_lut_adj_9.init = 16'hff80;
    LUT4 i623_3_lut_4_lut (.A(n2513), .B(n2640), .C(n371[5]), .D(n794), 
         .Z(n795)) /* synthesis lut_function=(A (B (C+(D))+!B (D))+!A (D)) */ ;
    defparam i623_3_lut_4_lut.init = 16'hff80;
    LUT4 i1_2_lut_3_lut_4_lut_4_lut (.A(n2513), .B(n2640), .C(n986), .D(n2639), 
         .Z(n2265)) /* synthesis lut_function=(A (B+(C+(D)))+!A (C)) */ ;
    defparam i1_2_lut_3_lut_4_lut_4_lut.init = 16'hfaf8;
    LUT4 i2_3_lut_4_lut_adj_10 (.A(n371[10]), .B(n2504), .C(n371[12]), 
         .D(n965), .Z(n2257)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_3_lut_4_lut_adj_10.init = 16'hfffe;
    LUT4 i3_2_lut_rep_65 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .Z(n2640)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i3_2_lut_rep_65.init = 16'h2222;
    FD1P3AY state_FSM_i0_i0 (.D(n795), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[0]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i0.GSR = "ENABLED";
    LUT4 i3_4_lut_then_4_lut (.A(n2513), .B(fpga_gpio_i_c_3), .C(n2496), 
         .D(n2641), .Z(n2519)) /* synthesis lut_function=(A ((C+(D))+!B)+!A (C+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i3_4_lut_then_4_lut.init = 16'hfff2;
    LUT4 i2_3_lut_rep_52 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_1), .C(fpga_gpio_i_c_0), 
         .Z(n2503)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i2_3_lut_rep_52.init = 16'hfefe;
    LUT4 i1_2_lut_rep_43_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_1), 
         .C(fpga_gpio_i_c_0), .D(fpga_gpio_i_c_2), .Z(n2494)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i1_2_lut_rep_43_4_lut.init = 16'hfffe;
    LUT4 i2061_4_lut_4_lut (.A(n379), .B(n2287), .C(n1070), .D(n524[0]), 
         .Z(n1055)) /* synthesis lut_function=(A (C)+!A (B (D)+!B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2061_4_lut_4_lut.init = 16'hf4b0;
    FD1P3AX visited_i0_i15 (.D(n2643), .SP(fpga_gpio_clock_c_enable_12), 
            .CK(fpga_gpio_clock_c), .Q(visited[15])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i15.GSR = "ENABLED";
    LUT4 i696_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[9]), .Z(fpga_gpio_clock_c_enable_18)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i696_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i698_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n379), .Z(fpga_gpio_clock_c_enable_19)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i698_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i700_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[7]), .Z(fpga_gpio_clock_c_enable_20)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i700_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i887_3_lut (.A(n1069), .B(visited[8]), .C(n379), .Z(n1070)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i887_3_lut.init = 16'hcaca;
    LUT4 i702_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[6]), .Z(fpga_gpio_clock_c_enable_21)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i702_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i1_2_lut_rep_53 (.A(n371[14]), .B(n371[15]), .Z(n2504)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i1_2_lut_rep_53.init = 16'heeee;
    FD1P3AX visited_i0_i14 (.D(n2643), .SP(fpga_gpio_clock_c_enable_13), 
            .CK(fpga_gpio_clock_c), .Q(visited[14])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i14.GSR = "ENABLED";
    FD1P3AX visited_i0_i13 (.D(n2643), .SP(fpga_gpio_clock_c_enable_14), 
            .CK(fpga_gpio_clock_c), .Q(visited[13])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i13.GSR = "ENABLED";
    FD1P3AX visited_i0_i12 (.D(n2643), .SP(fpga_gpio_clock_c_enable_15), 
            .CK(fpga_gpio_clock_c), .Q(visited[12])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i12.GSR = "ENABLED";
    FD1P3AX visited_i0_i11 (.D(n2643), .SP(fpga_gpio_clock_c_enable_16), 
            .CK(fpga_gpio_clock_c), .Q(visited[11])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i11.GSR = "ENABLED";
    FD1P3AX visited_i0_i10 (.D(n2643), .SP(fpga_gpio_clock_c_enable_17), 
            .CK(fpga_gpio_clock_c), .Q(visited[10])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i10.GSR = "ENABLED";
    FD1P3AX visited_i0_i9 (.D(n2643), .SP(fpga_gpio_clock_c_enable_18), 
            .CK(fpga_gpio_clock_c), .Q(visited[9])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i9.GSR = "ENABLED";
    FD1P3AX visited_i0_i8 (.D(n2643), .SP(fpga_gpio_clock_c_enable_19), 
            .CK(fpga_gpio_clock_c), .Q(visited[8])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i8.GSR = "ENABLED";
    FD1P3AX visited_i0_i7 (.D(n2643), .SP(fpga_gpio_clock_c_enable_20), 
            .CK(fpga_gpio_clock_c), .Q(visited[7])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i7.GSR = "ENABLED";
    FD1P3AX visited_i0_i6 (.D(n2643), .SP(fpga_gpio_clock_c_enable_21), 
            .CK(fpga_gpio_clock_c), .Q(visited[6])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i6.GSR = "ENABLED";
    FD1P3AX visited_i0_i5 (.D(n2643), .SP(fpga_gpio_clock_c_enable_22), 
            .CK(fpga_gpio_clock_c), .Q(visited[5])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i5.GSR = "ENABLED";
    FD1P3AX visited_i0_i4 (.D(n2643), .SP(fpga_gpio_clock_c_enable_23), 
            .CK(fpga_gpio_clock_c), .Q(visited[4])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i4.GSR = "ENABLED";
    FD1P3AX visited_i0_i3 (.D(n2643), .SP(fpga_gpio_clock_c_enable_24), 
            .CK(fpga_gpio_clock_c), .Q(visited[3])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i3.GSR = "ENABLED";
    FD1P3AX visited_i0_i2 (.D(n2643), .SP(fpga_gpio_clock_c_enable_25), 
            .CK(fpga_gpio_clock_c), .Q(visited[2])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i2.GSR = "ENABLED";
    FD1P3AX visited_i0_i1 (.D(n2643), .SP(fpga_gpio_clock_c_enable_26), 
            .CK(fpga_gpio_clock_c), .Q(visited[1])) /* synthesis lse_init_val=0, LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam visited_i0_i1.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i15 (.D(n2643), .SP(fpga_gpio_clock_c_enable_27), 
            .CK(fpga_gpio_clock_c), .Q(n371[15]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i15.GSR = "ENABLED";
    LUT4 i2068_2_lut_3_lut_4_lut (.A(n371[14]), .B(n371[15]), .C(n371[0]), 
         .D(n371[13]), .Z(n2307)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2068_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i2019_2_lut (.A(n371[7]), .B(n371[6]), .Z(n2287)) /* synthesis lut_function=(!(A+(B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i2019_2_lut.init = 16'h1111;
    LUT4 i1_2_lut_rep_50_3_lut (.A(n371[14]), .B(n371[15]), .C(n371[10]), 
         .Z(n2501)) /* synthesis lut_function=(A+(B+(C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i1_2_lut_rep_50_3_lut.init = 16'hfefe;
    FD1P3AX state_FSM_i0_i14 (.D(n2044), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[14]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i14.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i13 (.D(n821), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[13]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i13.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i12 (.D(n819), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[12]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i12.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i11 (.D(n817), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[11]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i11.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i10 (.D(n2050), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[10]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i10.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i9 (.D(n2037), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[9]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i9.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i8 (.D(n2051), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n379));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i8.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i7 (.D(n2054), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[7]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i7.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i6 (.D(n2036), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[6]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i6.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i5 (.D(n805), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[5]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i5.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i4 (.D(n2043), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[4]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i4.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i3 (.D(n2055), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[3]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i3.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i2 (.D(n2466), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[2]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i2.GSR = "ENABLED";
    FD1P3AX state_FSM_i0_i1 (.D(n2056), .SP(fpga_gpio_clock_c_enable_41), 
            .CK(fpga_gpio_clock_c), .Q(n371[1]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam state_FSM_i0_i1.GSR = "ENABLED";
    LUT4 i886_3_lut (.A(visited[6]), .B(visited[7]), .C(n371[7]), .Z(n1069)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i886_3_lut.init = 16'hcaca;
    LUT4 i10_4_lut (.A(visited[8]), .B(visited[3]), .C(visited[13]), .D(visited[5]), 
         .Z(n26)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i10_4_lut.init = 16'h8000;
    LUT4 i622_4_lut (.A(n371[0]), .B(n2407), .C(n1012), .D(n2262), .Z(n794)) /* synthesis lut_function=(A (B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i622_4_lut.init = 16'haaa8;
    LUT4 i2_2_lut_adj_11 (.A(visited[1]), .B(visited[4]), .Z(n18)) /* synthesis lut_function=(A (B)) */ ;
    defparam i2_2_lut_adj_11.init = 16'h8888;
    LUT4 i12_4_lut (.A(visited[11]), .B(visited[9]), .C(visited[14]), 
         .D(visited[15]), .Z(n28)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i12_4_lut.init = 16'h8000;
    LUT4 i2072_2_lut (.A(n371[12]), .B(n371[11]), .Z(n2300)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam i2072_2_lut.init = 16'heeee;
    LUT4 i6_2_lut (.A(visited[2]), .B(visited[7]), .Z(n22)) /* synthesis lut_function=(A (B)) */ ;
    defparam i6_2_lut.init = 16'h8888;
    LUT4 i2_4_lut_then_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n371[3]), .D(fpga_gpio_i_c_2), .Z(n2523)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i2_4_lut_then_3_lut_4_lut.init = 16'h0020;
    FD1P3AX broken_62 (.D(n2643), .SP(fpga_gpio_clock_c_enable_44), .CK(fpga_gpio_clock_c), 
            .Q(broken)) /* synthesis LSE_LINE_FILE_ID=20, LSE_LCOL=11, LSE_RCOL=32, LSE_LLINE=26, LSE_RLINE=26 */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(32[7] 181[14])
    defparam broken_62.GSR = "ENABLED";
    LUT4 i2_4_lut_adj_12 (.A(n2497), .B(n2244), .C(n371[13]), .D(n822), 
         .Z(n2044)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_4_lut_adj_12.init = 16'hffec;
    LUT4 i2_3_lut_4_lut_adj_13 (.A(n114), .B(n2488), .C(n1012), .D(n2499), 
         .Z(n2231)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(43[15] 50[24])
    defparam i2_3_lut_4_lut_adj_13.init = 16'hfffe;
    LUT4 i650_3_lut_4_lut (.A(n114), .B(n2488), .C(n986), .D(n371[14]), 
         .Z(n822)) /* synthesis lut_function=(A (D)+!A (B (D)+!B (C (D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(43[15] 50[24])
    defparam i650_3_lut_4_lut.init = 16'hfe00;
    LUT4 i871_2_lut_3_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), .C(fpga_gpio_i_c_2), 
         .Z(n1012)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;
    defparam i871_2_lut_3_lut.init = 16'h2020;
    LUT4 mux_479_i1_3_lut (.A(visited[13]), .B(visited[14]), .C(n371[14]), 
         .Z(n542[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam mux_479_i1_3_lut.init = 16'hcaca;
    LUT4 mux_467_i1_3_lut (.A(visited[1]), .B(visited[2]), .C(n371[2]), 
         .Z(n524[0])) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(34[22:49])
    defparam mux_467_i1_3_lut.init = 16'hcaca;
    LUT4 i706_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[4]), .Z(fpga_gpio_clock_c_enable_23)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i706_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i708_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[3]), .Z(fpga_gpio_clock_c_enable_24)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i708_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i1_2_lut_rep_38_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n986), .D(n2513), .Z(n2489)) /* synthesis lut_function=(A (B (C)+!B (C+(D)))+!A (C)) */ ;
    defparam i1_2_lut_rep_38_3_lut_4_lut.init = 16'hf2f0;
    LUT4 i4_2_lut_rep_46_3_lut_4_lut (.A(fpga_gpio_i_c_1), .B(fpga_gpio_i_c_2), 
         .C(fpga_gpio_i_c_0), .D(fpga_gpio_i_c_3), .Z(n2497)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i4_2_lut_rep_46_3_lut_4_lut.init = 16'h0100;
    LUT4 i1_2_lut_rep_58 (.A(n371[5]), .B(n371[7]), .Z(n2509)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i1_2_lut_rep_58.init = 16'heeee;
    LUT4 i649_4_lut (.A(n371[13]), .B(n7_adj_141), .C(n339), .D(n371[12]), 
         .Z(n821)) /* synthesis lut_function=(A (B (C)+!B (C+(D)))+!A !(B+!(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i649_4_lut.init = 16'hb3a0;
    LUT4 i3_3_lut_4_lut_adj_14 (.A(n371[5]), .B(n371[7]), .C(n371[1]), 
         .D(n965), .Z(n8_adj_2)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i3_3_lut_4_lut_adj_14.init = 16'hfffe;
    LUT4 i3_4_lut_adj_15 (.A(n2495), .B(n2489), .C(n2496), .D(n2262), 
         .Z(n172)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(77[15] 86[24])
    defparam i3_4_lut_adj_15.init = 16'hfffe;
    LUT4 n241_bdd_2_lut_2101_3_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n2376), .Z(n2377)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam n241_bdd_2_lut_2101_3_lut.init = 16'h8080;
    LUT4 i320_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n172), .D(n2513), .Z(n339)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (C)) */ ;
    defparam i320_2_lut_3_lut_4_lut.init = 16'hf8f0;
    PFUMX i2131 (.BLUT(n2465), .ALUT(n2464), .C0(n371[2]), .Z(n2466));
    LUT4 i1_2_lut_3_lut_4_lut_adj_16 (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_1), .D(fpga_gpio_i_c_2), .Z(n7_adj_141)) /* synthesis lut_function=(((C+!(D))+!B)+!A) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_16.init = 16'hf7ff;
    LUT4 i710_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[2]), .Z(fpga_gpio_clock_c_enable_25)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i710_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i712_2_lut_3_lut_3_lut_4_lut (.A(visit_complete), .B(broken), .C(broken_N_43), 
         .D(n371[1]), .Z(fpga_gpio_clock_c_enable_26)) /* synthesis lut_function=(!(A+(B+(C+!(D))))) */ ;
    defparam i712_2_lut_3_lut_3_lut_4_lut.init = 16'h0100;
    LUT4 i647_4_lut (.A(n371[12]), .B(n371[4]), .C(n7_adj_141), .D(n1359), 
         .Z(n819)) /* synthesis lut_function=(A (B (C+!(D))+!B (C))+!A !((D)+!B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i647_4_lut.init = 16'ha0ec;
    LUT4 i645_4_lut (.A(n371[11]), .B(n2494), .C(n2233), .D(n371[7]), 
         .Z(n817)) /* synthesis lut_function=(A (B (C)+!B (C+(D)))+!A !(B+!(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i645_4_lut.init = 16'hb3a0;
    LUT4 i3_4_lut_adj_17 (.A(n814), .B(n2377), .C(n2498), .D(n371[1]), 
         .Z(n2050)) /* synthesis lut_function=(A+(B+(C (D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i3_4_lut_adj_17.init = 16'hfeee;
    LUT4 i642_4_lut (.A(n371[10]), .B(n2265), .C(n1409), .D(n2493), 
         .Z(n814)) /* synthesis lut_function=(A (B+((D)+!C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i642_4_lut.init = 16'haa8a;
    LUT4 i640_3_lut_4_lut (.A(n2639), .B(n2502), .C(n2231), .D(n371[9]), 
         .Z(n812)) /* synthesis lut_function=(A (B (D)+!B (C (D)))+!A (C (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(120[15] 127[24])
    defparam i640_3_lut_4_lut.init = 16'hf800;
    LUT4 i2_3_lut_4_lut_adj_18 (.A(n2498), .B(n2234), .C(n1385), .D(n986), 
         .Z(n2047)) /* synthesis lut_function=(A+(B+((D)+!C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(43[15] 50[24])
    defparam i2_3_lut_4_lut_adj_18.init = 16'hffef;
    PFUMX i2147 (.BLUT(n2522), .ALUT(n2523), .C0(fpga_gpio_i_c_1), .Z(n2524));
    LUT4 i389_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(n371[4]), .D(n2513), .Z(n442)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i389_2_lut_3_lut_4_lut.init = 16'h8000;
    PFUMX mux_504_i1 (.BLUT(n542[0]), .ALUT(n560[0]), .C0(n2310), .Z(n573[0]));
    PFUMX i674 (.BLUT(n839), .ALUT(n1055), .C0(n2290), .Z(n846));
    PFUMX i2145 (.BLUT(n2518), .ALUT(n2519), .C0(fpga_gpio_i_c_0), .Z(n2234));
    LUT4 i1229_2_lut_3_lut_4_lut (.A(fpga_gpio_i_c_3), .B(fpga_gpio_i_c_0), 
         .C(fpga_gpio_i_c_2), .D(fpga_gpio_i_c_1), .Z(n1409)) /* synthesis lut_function=(A (B+(C+(D)))+!A (C+(D))) */ ;
    defparam i1229_2_lut_3_lut_4_lut.init = 16'hfff8;
    LUT4 i2_4_lut_adj_19 (.A(n2496), .B(n447), .C(n371[10]), .D(n812), 
         .Z(n2037)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(41[11] 179[20])
    defparam i2_4_lut_adj_19.init = 16'hffec;
    
endmodule
