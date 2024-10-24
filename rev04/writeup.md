# ECSC Jeopardy 2024

## [rev] Next Gen Crackme (1 solves)

The world is constantly evolving, and so do CTF challenges.

_Note: this and the Old Gen Crackme challenge are not related._

_The timeout on the remote is 60 seconds._

`nc ngc.challs.jeopardy.ecsc2024.it 47018`

Author: Matteo Protopapa <@matpro>

## Overview

The challenge simply asks for some input and "transforms" it, up to 350 times. If at some point a special variable is at least 1000, the binary prints the flag.

## Solution

The main loops 350 times, calling just two functions.

The first function starts checking is the first character of the input. Only five values are accepted as valid.

### Q

Exits the program.

### W

Does nothing and proceed with the main loop.

### B

The challenge reads other two characters and converts them to a number with the association AA -> 0, AB -> 1, ..., BA -> 26, ...

The number is then used in a switch. The cases are very similar to each other. They firstly compare element-wise two objects looking like an array of 16 int. If the first one has every element less than or equal, then it is subtracted (element-wise) from the second one and some data (with size 0x138) is `memcpy`-ed into a `struct`. Two vectors are allocated with the following code and added to the `struct`, which is pushed to a global vector.

```c++
    v25 = 0LL;
    v26 = 0LL;
    v27 = 0LL;
    sub_659C(&v25);
    sub_69EC(&v29, &v25);
    sub_68CE(&v25);
```

### T

The same encoding as before is used to communicate an index used in the global array of `struct`s. If valid, every element from the 16 int array at a certain offset is "moved" (i.e. subtracted from one array and added to another one) from the indexed `struct` of the global vector into another global array, which is the one used for the comparison in the `B` command.

### C

This command, unlike `B` and `T`, takes two indexes (always in the same `XX` form) instead of one. These indexes are used to retrieve two `struct`s from the global vector filled with `B` commands. If some conditions on an `int` member of the `struct`s are met, each `struct` will push the index of the other one into one of its own vectors allocated at the end of the `B` command. The order of the indexes in the command defines some sort of hierarchy between the two `struct`s, given the indexes conditions and the different vectors in which the indexes are copied.

---

The second function iterates over the global vector of `struct`s, and, based on the hierarchy set with the `C` command it performs some checks very similar to the ones made with `T`, just repeatedly. If the checks pass, at least part of one of the 16 `int` arrays values of the first `struct` are "moved" to another array of the second one and then at least part of this last array is "moved" to another one (always in the second `struct`).

---

The implementation reminds of an industry-based game, in which you have to extract some materials and combine them to obtain other ones. In fact, the commands stands for Quit, Wait, Build, Take, Connect and the 16 `int` arrays are the quantity of each of the 16 resources.

The remaining part is to actually build a factory that produces the last resource. It has to be decently fast, but it doesn't need to be extremely optimized.

## Exploit

A winning sequence of moves is the following:

```
BAA
W
W
W
TAA
BAA
W
W
W
W
TAA
TAB
BAA
BAA
BAA
W
W
W
TAA
BAC
TAB
BAC
TAC
BAC
TAD
BAC
TAE
BAC
BAB
TAA
TAB
TAC
TAD
TAF
TAG
TAH
TAI
TAJ
TAK
TAE
BAE
CAJAL
BAE
CAIAM
BAE
CAHAN
BAE
CAGAO
BAE
CAFAP
TAA
BAC
TAF
TAG
TAH
TAI
TAJ
TAB
BAF
CAPAR
CAOAR
CANAR
CAEAR
CADAR
BAF
CANAS
CAMAS
CALAS
CACAS
CABAS
TAB
TAC
TAD
TAE
BAA
BAA
BAC
BAG
CAVAW
CAUAW
BAA
BAC
BAG
CAXAZ
CAYAZ
TAK
TAR
BAJ
CAZBA
CAWBA
TAQ
BAB
BAC
BAH
CBBBD
CBCBD
TAA
BAB
BAC
BAH
CBEBG
CBFBG
BAK
CBDBH
CBGBH
TAA
BAC
BAC
BAL
CBHBK
CBIBK
CBJBK
TAT
BAC
BAB
BAH
CBLBN
CBMBN
TAA
TAT
BAC
BAB
BAH
CBOBQ
CBPBQ
TAA
BAA
TAT
TBR
BAC
TAU
TAX
TBA
W
W
TAA
TAS
BAD
TAT
TBR
BAI
CBSBU
CBTBU
TAA
BAC
BAD
TAT
BAI
CBVBX
CBWBX
TBK
BAM
CBNBY
CBQBY
CBUBY
CBXBY
TAA
TBR
BAC
BAC
CBZBY
CCABY
TAT
TBR
TAA
BAC
BAC
CCBBY
CCCBY
TBY
TAQ
BAN
CBACD
TBY
BAA
BAA
TAA
BAA
BAA
BAC
BAC
TAT
BAC
BAC
TBR
BAG
BAG
CCECM
CCICM
CCFCN
CCJCN
TCE
TCF
TCG
TCH
BAG
BAG
CCGCO
CCKCO
CCHCP
CCLCP
BAB
BAB
BAB
BAB
TAA
TAT
BAC
BAC
BAC
BAC
TBR
BAH
BAH
BAH
BAH
CCQCY
CCRCZ
CCSDA
CCTDB
CCUCY
CCVCZ
CCWDA
CCXDB
TAA
TAT
TBR
BAA
BAD
BAD
BAD
BAD
BAC
TCG
TCH
TAA
TAT
TBR
BAC
BAC
BAC
BAI
TAA
TAT
TBR
TDC
BAI
BAI
BAI
CDDDL
CDEDM
CDFDN
CDGDO
CDHDL
CDIDM
CDJDN
CDKDO
TAA
BAO
CCMDP
CCYDP
CDLDP
CCNDP
CCZDP
CDMDP
CCODP
CDADP
CDNDP
CCPDP
CDBDP
CDODP
TDP
TAK
TAA
TAT
TBR
BAA
BAA
BAC
BAC
BAG
CDQDU
CDSDU
BAG
CDRDV
CDTDV
BAJ
CDUDW
CDVDW
TAA
BAP
CCDDX
CDPDX
CDWDX
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
W
TDX
```

It results in the following factory:

```
   0 AA -> iron_miner
   1 AB -> iron_miner        >----------------+
   2 AC -> iron_miner        >----------------+
   3 AD -> iron_miner        >------------+   |
   4 AE -> iron_miner        >------------+   |
   5 AF -> coal_miner        >---------+  |   |
   6 AG -> coal_miner        >-------+ |  |   |
   7 AH -> coal_miner        >-----+ | |  |   |
   8 AI -> coal_miner        >---+ | | |  |   |
   9 AJ -> coal_miner        >-+ | | | |  |   |
  10 AK -> copper_miner        | | | | |  |   |
  11 AL -> coke_oven         <-+ | | | |  | >-+
  12 AM -> coke_oven         <---+ | | |  | >-+
  13 AN -> coke_oven         <-----+ | | -+---+
  14 AO -> coke_oven         <-------+ | -+   |
  15 AP -> coke_oven         <---------+ -+   |
  16 AQ -> coal_miner                     |   |
  17 AR -> blast_furnace     <------------+   |
  18 AS -> blast_furnace     <----------------+
  19 AT -> iron_miner
  20 AU -> iron_miner        --+
  21 AV -> coal_miner        --+
  22 AW -> iron_smelter      <-+ >-+
  23 AX -> iron_miner        --+   |
  24 AY -> coal_miner        --+   |
  25 AZ -> iron_smelter      <-+ >-+
  26 BA -> extruder          <-----+ >---+
  27 BB -> copper_miner      >-+         |
  28 BC -> coal_miner        >-+         |
  29 BD -> copper_smelter    <-+ >-+     |
  30 BE -> copper_miner      >-+   |     |
  31 BF -> coal_miner        >-+   |     |
  32 BG -> copper_smelter    <-+ >-+     |
  33 BH -> copper_press      <-----+ >-+ |
  34 BI -> coal_miner        >---------+ |
  35 BJ -> coal_miner        >---------+ |
  36 BK -> copper_soldering  <---------+ |
  37 BL -> coal_miner        >-+         |
  38 BM -> copper_miner      >-+         |
  39 BN -> copper_smelter    <-+ >-+     |
  40 BO -> coal_miner        >-+   |     |
  41 BP -> copper_miner      >-+   |     |
  42 BQ -> copper_smelter    <-+ >-+     |
  43 BR -> iron_miner              |     |
  44 BS -> coal_miner        >-+   |     |
  45 BT -> tin_miner         >-+   |     |
  46 BU -> tin_smelter       <-+ >-+     |
  47 BV -> coal_miner        >-+   |     |
  48 BW -> tin_miner         >-+   |     |
  49 BX -> tin_smelter       <-+ >-+     |
  50 BY -> bronze_smelter    <-----+     |
  51 BZ -> coal_miner        >-----+     |
  52 CA -> coal_miner        >-----+     |
  53 CB -> coal_miner        >-----+     |
  54 CC -> coal_miner        >-----+     |
  55 CD -> screw_maker       <-----------+ >-+
  56 CE -> iron_miner        >-+             |
  57 CF -> iron_miner        >-|-+           |
  58 CG -> iron_miner        >-|-|-+         |
  59 CH -> iron_miner        >-|-|-|-+       |
  60 CI -> coal_miner        >-+ | | |       |
  61 CJ -> coal_miner        >-|-+ | |       |
  62 CK -> coal_miner        >-|-|-+ |       |
  63 CL -> coal_miner        >-|-|-|-+       |
  64 CM -> iron_smelter      <-+ | | | >-+   |
  65 CN -> iron_smelter      <---+ | | >-+   |
  66 CO -> iron_smelter      <-----+ | >-+   |
  67 CP -> iron_smelter      <-------+ >-+   |
  68 CQ -> copper_miner      >-+         |   |
  69 CR -> copper_miner      >-|-+       |   |
  70 CS -> copper_miner      >-|-|-+     |   |
  71 CT -> copper_miner      >-|-|-|-+   |   |
  72 CU -> coal_miner        >-+ | | |   |   |
  73 CV -> coal_miner        >-|-+ | |   |   |
  74 CW -> coal_miner        >-|-|-+ |   |   |
  75 CX -> coal_miner        >-|-|-|-+   |   |
  76 CY -> copper_smelter    <-+ | | | >-+   |
  77 CZ -> copper_smelter    <---+ | | >-+   |
  78 DA -> copper_smelter    <-----+ | >-+   |
  79 DB -> copper_smelter    <-------+ >-+   |
  80 DC -> iron_miner                    |   |
  81 DD -> tin_miner         >-+         |   |
  82 DE -> tin_miner         >-|-+       |   |
  83 DF -> tin_miner         >-|-|-+     |   |
  84 DG -> tin_miner         >-|-|-|-+   |   |
  85 DH -> coal_miner        >-+ | | |   |   |
  86 DI -> coal_miner        >-|-+ | |   |   |
  87 DJ -> coal_miner        >-|-|-+ |   |   |
  88 DK -> coal_miner        >-|-|-|-+ >-+   |
  89 DL -> tin_smelter       <-+ | | | >-+   |
  90 DM -> tin_smelter       <---+ | | >-+   |
  91 DN -> tin_smelter       <-----+ | >-+   |
  92 DO -> tin_smelter       <-------+ >-+   |
  93 DP -> foundry           <-----------+ >-+
  94 DQ -> iron_miner        >-+             |
  95 DR -> iron_miner        >-|-+           |
  96 DS -> coal_miner        >-+ |           |
  97 DT -> coal_miner        >-|-+           |
  98 DU -> iron_smelter      <-+ | >-+       |
  99 DV -> iron_smelter      <---+ >-+       |
 100 DW -> extruder          <-------+ >-----+
 101 DX -> assembler         <---------------+
```
