// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.13.0.56.2
// Netlist written on Wed Sep 25 22:29:03 2024
//
// Verilog Description of module FSM_CHALL
//

module FSM_CHALL (RST, CLK, o, i);   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(4[8:17])
    input RST;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(6[5:8])
    input CLK;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(7[5:8])
    output [3:0]o;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(8[5:6])
    input [3:0]i;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(9[5:6])
    
    wire CLK_c /* synthesis is_clock=1, SET_AS_NETWORK=CLK_c */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(7[5:8])
    
    wire VCC_net, GND_net, RST_c, o_c_3, o_c_2, o_c_1, o_c_0, 
        i_c_3, i_c_2, i_c_1, i_c_0, n910;
    wire [3:0]o_3__N_45;
    
    wire n501;
    wire [3:0]o_3__N_29;
    
    wire n916;
    wire [3:0]o_3__N_25;
    
    wire n911, n896, n497, n6, n1072, n1071, n1143, n493, n145, 
        n641, n1105, n1126, n4, n7, n6_adj_1, n1070, n1104, 
        n263, n1103, n10, n507, n515, n909, n913, n1102, n8, 
        n998, n517, n1101, n509, n771, n4_adj_2, CLK_c_enable_1, 
        n387, n388, n389, n390, n391, n392, n393, n394, n395, 
        n396, n397, n398, n399, n400, n401, n402, n1116, n407, 
        n1100, n504, n6_adj_3, n1099, n4_adj_4, n1125, n1180, 
        n510, n1097, n1012, n1111, n1110, n899, CLK_c_enable_2, 
        n1095, n1117, n1109, n1108, n1107, n1016, n1106, n10_adj_5;
    
    VLO i1006 (.Z(GND_net));
    LUT4 i1_4_lut (.A(n389), .B(n1100), .C(n771), .D(n398), .Z(CLK_c_enable_1)) /* synthesis lut_function=(A (B ((D)+!C)+!B !(C))+!A (B (D))) */ ;
    defparam i1_4_lut.init = 16'hce0a;
    FD1S3AX state_FSM_i4 (.D(n501), .CK(CLK_c), .Q(n398));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i4.GSR = "ENABLED";
    TSALL TSALL_INST (.TSALL(GND_net));
    FD1S3AX state_FSM_i10 (.D(n916), .CK(CLK_c), .Q(n392));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i10.GSR = "ENABLED";
    FD1S3AX state_FSM_i3 (.D(n909), .CK(CLK_c), .Q(n399));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i3.GSR = "ENABLED";
    FD1S3AX state_FSM_i9 (.D(n509), .CK(CLK_c), .Q(n393));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i9.GSR = "ENABLED";
    FD1S3AX state_FSM_i2 (.D(n497), .CK(CLK_c), .Q(n400));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i2.GSR = "ENABLED";
    FD1S3AX state_FSM_i1 (.D(n910), .CK(CLK_c), .Q(n401));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i1.GSR = "ENABLED";
    FD1S3AY state_FSM_i0 (.D(n493), .CK(CLK_c), .Q(n402));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i0.GSR = "ENABLED";
    LUT4 i1_2_lut (.A(n394), .B(n391), .Z(n6_adj_3)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_2_lut.init = 16'heeee;
    LUT4 i432_4_lut (.A(n390), .B(n398), .C(n7), .D(n771), .Z(n515)) /* synthesis lut_function=(A (B (C+!(D))+!B (C))+!A !((D)+!B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i432_4_lut.init = 16'ha0ec;
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    LUT4 i_c_3_bdd_3_lut_1000 (.A(i_c_0), .B(i_c_1), .C(i_c_2), .Z(n1125)) /* synthesis lut_function=(A+(B+(C))) */ ;
    defparam i_c_3_bdd_3_lut_1000.init = 16'hfefe;
    LUT4 i410_4_lut (.A(n402), .B(n1101), .C(n1117), .D(n397), .Z(n493)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i410_4_lut.init = 16'heca0;
    FD1P3AX state_FSM_i8 (.D(n1180), .SP(CLK_c_enable_1), .CK(CLK_c), 
            .Q(n394));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i8.GSR = "ENABLED";
    IB i_pad_0 (.I(i[0]), .O(i_c_0));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(9[5:6])
    LUT4 i2_4_lut (.A(n1095), .B(n407), .C(n400), .D(n1126), .Z(n910)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_4_lut.init = 16'hffec;
    LUT4 i414_4_lut (.A(n400), .B(n145), .C(n1143), .D(n401), .Z(n497)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i414_4_lut.init = 16'heca0;
    IB i_pad_1 (.I(i[1]), .O(i_c_1));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(9[5:6])
    LUT4 i_c_3_bdd_4_lut_984 (.A(i_c_3), .B(i_c_0), .C(i_c_1), .D(i_c_2), 
         .Z(n1117)) /* synthesis lut_function=(A (B+((D)+!C))+!A (B+(C+!(D)))) */ ;
    defparam i_c_3_bdd_4_lut_984.init = 16'hfedf;
    VHI i1007 (.Z(VCC_net));
    LUT4 i1_2_lut_3_lut_4_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_3), 
         .Z(n263)) /* synthesis lut_function=(!(A (B (C)))) */ ;
    defparam i1_2_lut_3_lut_4_lut_4_lut.init = 16'h7f7f;
    LUT4 n1069_bdd_2_lut_3_lut_4_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), 
         .D(i_c_3), .Z(n1070)) /* synthesis lut_function=(A (B+!(C (D)+!C !(D)))+!A !(B (C (D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(59[13] 70[22])
    defparam n1069_bdd_2_lut_3_lut_4_lut_4_lut.init = 16'h9ffd;
    LUT4 n401_bdd_4_lut_979 (.A(n401), .B(i_c_1), .C(i_c_0), .D(i_c_3), 
         .Z(n1126)) /* synthesis lut_function=(A (B+((D)+!C))) */ ;
    defparam n401_bdd_4_lut_979.init = 16'haa8a;
    LUT4 i1_2_lut_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(i_c_1), .D(i_c_2), 
         .Z(o_3__N_29[2])) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(108[20:26])
    defparam i1_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i_c_2_bdd_4_lut (.A(i_c_2), .B(i_c_1), .C(i_c_3), .D(i_c_0), 
         .Z(n1116)) /* synthesis lut_function=(!(A (B (C))+!A !(B+(D)))) */ ;
    defparam i_c_2_bdd_4_lut.init = 16'h7f6e;
    LUT4 n391_bdd_4_lut_1003 (.A(n395), .B(i_c_1), .C(i_c_2), .D(n1104), 
         .Z(n1071)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam n391_bdd_4_lut_1003.init = 16'h0002;
    LUT4 i424_4_lut (.A(n395), .B(n10), .C(o_3__N_29[2]), .D(n1104), 
         .Z(n507)) /* synthesis lut_function=(A (B (C+!(D))+!B (C))+!A !((D)+!B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i424_4_lut.init = 16'ha0ec;
    LUT4 i21_4_lut (.A(n396), .B(i_c_1), .C(i_c_2), .D(n392), .Z(n10)) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(C))+!A ((C+!(D))+!B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i21_4_lut.init = 16'h2c20;
    LUT4 i_c_3_bdd_4_lut_999 (.A(i_c_3), .B(i_c_1), .C(i_c_2), .D(i_c_0), 
         .Z(n1143)) /* synthesis lut_function=(!(A (B (C (D)))+!A !((C+(D))+!B))) */ ;
    defparam i_c_3_bdd_4_lut_999.init = 16'h7ffb;
    LUT4 i2_4_lut_adj_1 (.A(n1100), .B(n896), .C(n397), .D(n504), .Z(n899)) /* synthesis lut_function=(A (B+(C+(D)))+!A (B+(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_4_lut_adj_1.init = 16'hffec;
    LUT4 i2_3_lut (.A(i_c_3), .B(i_c_2), .C(n8), .Z(n896)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_3_lut.init = 16'h2020;
    LUT4 i421_4_lut (.A(n396), .B(n1104), .C(i_c_2), .D(i_c_1), .Z(n504)) /* synthesis lut_function=(A (B+((D)+!C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i421_4_lut.init = 16'haa8a;
    LUT4 i418_4_lut (.A(n398), .B(n1097), .C(n1116), .D(n402), .Z(n501)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i418_4_lut.init = 16'heca0;
    LUT4 i21_4_lut_adj_2 (.A(n399), .B(i_c_0), .C(i_c_1), .D(n393), 
         .Z(n8)) /* synthesis lut_function=(!(A (B (C+!(D))+!B !(C))+!A ((C+!(D))+!B))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i21_4_lut_adj_2.init = 16'h2c20;
    LUT4 i2_3_lut_4_lut (.A(n1106), .B(n1107), .C(n389), .D(n4_adj_2), 
         .Z(n911)) /* synthesis lut_function=(A (D)+!A (B (C+(D))+!B (D))) */ ;
    defparam i2_3_lut_4_lut.init = 16'hff40;
    LUT4 i2_3_lut_4_lut_adj_3 (.A(n1109), .B(n1108), .C(n388), .D(n4_adj_4), 
         .Z(n913)) /* synthesis lut_function=(A (B (C+(D))+!B (D))+!A (D)) */ ;
    defparam i2_3_lut_4_lut_adj_3.init = 16'hff80;
    LUT4 i2_4_lut_adj_4 (.A(n1012), .B(n1103), .C(n510), .D(n401), .Z(n916)) /* synthesis lut_function=(A+(B (C+(D))+!B (C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_4_lut_adj_4.init = 16'hfefa;
    LUT4 i5_3_lut (.A(n389), .B(n10_adj_5), .C(n998), .Z(o_c_0)) /* synthesis lut_function=(A+(B+(C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i5_3_lut.init = 16'hfefe;
    LUT4 i427_3_lut_4_lut (.A(n1104), .B(i_c_2), .C(i_c_1), .D(n392), 
         .Z(n510)) /* synthesis lut_function=(A (D)+!A (B (D)+!B !(C+!(D)))) */ ;
    defparam i427_3_lut_4_lut.init = 16'hef00;
    LUT4 i4_4_lut (.A(n387), .B(n397), .C(n401), .D(n393), .Z(n10_adj_5)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i4_4_lut.init = 16'hfffe;
    LUT4 i2_3_lut_adj_5 (.A(n399), .B(n391), .C(n395), .Z(n998)) /* synthesis lut_function=(A+(B+(C))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_3_lut_adj_5.init = 16'hfefe;
    LUT4 i2_3_lut_4_lut_adj_6 (.A(n1109), .B(n1107), .C(n388), .D(n4), 
         .Z(n909)) /* synthesis lut_function=(A (B (C+(D))+!B (D))+!A (D)) */ ;
    defparam i2_3_lut_4_lut_adj_6.init = 16'hff80;
    LUT4 i1_4_lut_adj_7 (.A(n1101), .B(n397), .C(n398), .D(n263), .Z(n4_adj_4)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_4_lut_adj_7.init = 16'heca0;
    LUT4 i1_4_lut_adj_8 (.A(n1105), .B(n388), .C(n1102), .D(n263), .Z(n4_adj_2)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_4_lut_adj_8.init = 16'heca0;
    LUT4 i552_1_lut (.A(RST_c), .Z(n641)) /* synthesis lut_function=(!(A)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(6[5:8])
    defparam i552_1_lut.init = 16'h5555;
    LUT4 i4_4_lut_adj_9 (.A(n396), .B(n998), .C(n1110), .D(n6_adj_1), 
         .Z(o_c_1)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i4_4_lut_adj_9.init = 16'hfffe;
    LUT4 i1_2_lut_adj_10 (.A(n392), .B(n400), .Z(n6_adj_1)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_2_lut_adj_10.init = 16'heeee;
    LUT4 i1_4_lut_adj_11 (.A(n1100), .B(n399), .C(n400), .D(o_3__N_45[0]), 
         .Z(n4)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_4_lut_adj_11.init = 16'heca0;
    LUT4 i323_2_lut_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(n402), .D(n1111), 
         .Z(n407)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(108[20:26])
    defparam i323_2_lut_3_lut_4_lut.init = 16'h1000;
    LUT4 i3_4_lut (.A(i_c_1), .B(i_c_0), .C(i_c_3), .D(i_c_2), .Z(o_3__N_45[0])) /* synthesis lut_function=((B+((D)+!C))+!A) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(108[20:26])
    defparam i3_4_lut.init = 16'hffdf;
    LUT4 i4_4_lut_adj_12 (.A(n398), .B(n1016), .C(n397), .D(n6), .Z(o_c_2)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i4_4_lut_adj_12.init = 16'hfffe;
    LUT4 i1_2_lut_adj_13 (.A(n395), .B(n396), .Z(n6)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i1_2_lut_adj_13.init = 16'heeee;
    LUT4 i434_4_lut (.A(n389), .B(n7), .C(n1125), .D(n390), .Z(n517)) /* synthesis lut_function=(A (B (C)+!B (C+(D)))+!A !(B+!(D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i434_4_lut.init = 16'hb3a0;
    LUT4 i426_4_lut (.A(n393), .B(n1099), .C(o_3__N_25[3]), .D(n398), 
         .Z(n509)) /* synthesis lut_function=(A (B (C+(D))+!B (C))+!A (B (D))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i426_4_lut.init = 16'heca0;
    LUT4 i2_2_lut_rep_29 (.A(i_c_1), .B(i_c_2), .Z(n1105)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i2_2_lut_rep_29.init = 16'h2222;
    LUT4 i4_2_lut_rep_19_3_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), 
         .D(i_c_3), .Z(n1095)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i4_2_lut_rep_19_3_lut_4_lut.init = 16'h0002;
    LUT4 i674_2_lut_rep_30 (.A(i_c_1), .B(i_c_2), .Z(n1106)) /* synthesis lut_function=(A+(B)) */ ;
    defparam i674_2_lut_rep_30.init = 16'heeee;
    LUT4 i1_2_lut_rep_28 (.A(i_c_3), .B(i_c_0), .Z(n1104)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(108[20:26])
    defparam i1_2_lut_rep_28.init = 16'heeee;
    LUT4 i684_2_lut_3_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), .D(i_c_3), 
         .Z(n771)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;
    defparam i684_2_lut_3_lut_4_lut.init = 16'hfffe;
    LUT4 i1_2_lut_4_lut (.A(i_c_0), .B(i_c_3), .C(i_c_1), .D(i_c_2), 
         .Z(o_3__N_25[3])) /* synthesis lut_function=(((C+(D))+!B)+!A) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(101[20:26])
    defparam i1_2_lut_4_lut.init = 16'hfff7;
    LUT4 i2_2_lut_rep_35 (.A(i_c_1), .B(i_c_2), .Z(n1111)) /* synthesis lut_function=(!(A+!(B))) */ ;
    defparam i2_2_lut_rep_35.init = 16'h4444;
    LUT4 i1_2_lut_4_lut_adj_14 (.A(i_c_0), .B(i_c_3), .C(i_c_1), .D(i_c_2), 
         .Z(n7)) /* synthesis lut_function=(((C+!(D))+!B)+!A) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(101[20:26])
    defparam i1_2_lut_4_lut_adj_14.init = 16'hf7ff;
    LUT4 i382_2_lut_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(n391), .D(n1105), 
         .Z(CLK_c_enable_2)) /* synthesis lut_function=(!(A+(B+!(C (D))))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(108[20:26])
    defparam i382_2_lut_3_lut_4_lut.init = 16'h1000;
    LUT4 i4_4_lut_adj_15 (.A(n392), .B(n1016), .C(n393), .D(n6_adj_3), 
         .Z(o_c_3)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i4_4_lut_adj_15.init = 16'hfffe;
    IB i_pad_2 (.I(i[2]), .O(i_c_2));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(9[5:6])
    LUT4 i3_2_lut_rep_31 (.A(i_c_3), .B(i_c_0), .Z(n1107)) /* synthesis lut_function=(!((B)+!A)) */ ;
    defparam i3_2_lut_rep_31.init = 16'h2222;
    FD1S3AX state_FSM_i7 (.D(n507), .CK(CLK_c), .Q(n395));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i7.GSR = "ENABLED";
    LUT4 i4_2_lut_rep_23_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(i_c_2), 
         .D(i_c_1), .Z(n1099)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i4_2_lut_rep_23_3_lut_4_lut.init = 16'h0002;
    LUT4 i4_2_lut_rep_21_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(i_c_2), 
         .D(i_c_1), .Z(n1097)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i4_2_lut_rep_21_3_lut_4_lut.init = 16'h0200;
    IB i_pad_3 (.I(i[3]), .O(i_c_3));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(9[5:6])
    FD1S3AX state_FSM_i6 (.D(n899), .CK(CLK_c), .Q(n396));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i6.GSR = "ENABLED";
    LUT4 i3_2_lut_rep_32 (.A(i_c_3), .B(i_c_0), .Z(n1108)) /* synthesis lut_function=(A (B)) */ ;
    defparam i3_2_lut_rep_32.init = 16'h8888;
    IB CLK_pad (.I(CLK), .O(CLK_c));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(7[5:8])
    PFUMX i961 (.BLUT(n1071), .ALUT(n1070), .C0(n391), .Z(n1072));
    LUT4 i1_2_lut_3_lut_4_lut_adj_16 (.A(i_c_3), .B(i_c_0), .C(n1111), 
         .D(n391), .Z(n1012)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_16.init = 16'h8000;
    IB RST_pad (.I(RST), .O(RST_c));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(6[5:8])
    LUT4 i1_2_lut_rep_26_3_lut (.A(i_c_3), .B(i_c_0), .C(n391), .Z(n1102)) /* synthesis lut_function=(A (B (C))) */ ;
    defparam i1_2_lut_rep_26_3_lut.init = 16'h8080;
    LUT4 i2_2_lut_rep_33 (.A(i_c_1), .B(i_c_2), .Z(n1109)) /* synthesis lut_function=(A (B)) */ ;
    defparam i2_2_lut_rep_33.init = 16'h8888;
    FD1P3AX state_FSM_i15 (.D(n1180), .SP(CLK_c_enable_2), .CK(CLK_c), 
            .Q(n387));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i15.GSR = "ENABLED";
    FD1S3AX state_FSM_i11 (.D(n1072), .CK(CLK_c), .Q(n391));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i11.GSR = "ENABLED";
    OB o_pad_0 (.I(o_c_0), .O(o[0]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(8[5:6])
    LUT4 i4_2_lut_rep_27_3_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), 
         .D(i_c_3), .Z(n1103)) /* synthesis lut_function=(!(A+(((D)+!C)+!B))) */ ;
    defparam i4_2_lut_rep_27_3_lut_4_lut.init = 16'h0040;
    FD1S3AX state_FSM_i5 (.D(n913), .CK(CLK_c), .Q(n397));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i5.GSR = "ENABLED";
    LUT4 m1_lut (.Z(n1180)) /* synthesis lut_function=1, syn_instantiated=1 */ ;
    defparam m1_lut.init = 16'hffff;
    FD1S3AX state_FSM_i14 (.D(n911), .CK(CLK_c), .Q(n388));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i14.GSR = "ENABLED";
    GSR GSR_INST (.GSR(n641));
    LUT4 i4_2_lut_rep_24_3_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), 
         .D(i_c_3), .Z(n1100)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i4_2_lut_rep_24_3_lut_4_lut.init = 16'h8000;
    OB o_pad_1 (.I(o_c_1), .O(o[1]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(8[5:6])
    LUT4 i4_2_lut_rep_25_3_lut_4_lut (.A(i_c_1), .B(i_c_2), .C(i_c_0), 
         .D(i_c_3), .Z(n1101)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i4_2_lut_rep_25_3_lut_4_lut.init = 16'h0800;
    OB o_pad_2 (.I(o_c_2), .O(o[2]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(8[5:6])
    LUT4 i4_2_lut_3_lut_4_lut (.A(i_c_3), .B(i_c_0), .C(i_c_2), .D(i_c_1), 
         .Z(n145)) /* synthesis lut_function=(!(A+((C+(D))+!B))) */ ;
    defparam i4_2_lut_3_lut_4_lut.init = 16'h0004;
    FD1S3AX state_FSM_i13 (.D(n517), .CK(CLK_c), .Q(n389));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i13.GSR = "ENABLED";
    OB o_pad_3 (.I(o_c_3), .O(o[3]));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(8[5:6])
    FD1S3AX state_FSM_i12 (.D(n515), .CK(CLK_c), .Q(n390));   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam state_FSM_i12.GSR = "ENABLED";
    LUT4 i4_2_lut_rep_34 (.A(n388), .B(n387), .Z(n1110)) /* synthesis lut_function=(A+(B)) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i4_2_lut_rep_34.init = 16'heeee;
    LUT4 i2_3_lut_4_lut_adj_17 (.A(n388), .B(n387), .C(n389), .D(n390), 
         .Z(n1016)) /* synthesis lut_function=(A+(B+(C+(D)))) */ ;   // f:/gits/challenge-154/src/pizzafpga/vhdl/fsm_chall.vhd(23[9] 157[18])
    defparam i2_3_lut_4_lut_adj_17.init = 16'hfffe;
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

