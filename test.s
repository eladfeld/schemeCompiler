;;; All the macros and the scheme-object printing procedure
;;; are defined in compiler.s
%include "compiler.s"

section .bss
;;; This pointer is used to manage allocations on our heap.
malloc_pointer:
    resq 1

;;; here we REServe enough Quad-words (64-bit "cells") for the free variables
;;; each free variable has 8 bytes reserved for a 64-bit pointer to its value
fvar_tbl:
    resq 48

section .data
const_tbl:
MAKE_VOID

MAKE_NIL

MAKE_LITERAL_BOOL(1)

MAKE_LITERAL_BOOL(0)

MAKE_LITERAL_STRING "whatever"

MAKE_LITERAL_SYMBOL(const_tbl+6)

MAKE_LITERAL_CHAR(0)

MAKE_LITERAL_RATIONAL(0,1)

MAKE_LITERAL_RATIONAL(1,1)

MAKE_LITERAL_RATIONAL(-1,1)

MAKE_LITERAL_CHAR(49)

MAKE_LITERAL_RATIONAL(770,1)

MAKE_LITERAL_PAIR(const_tbl+85,const_tbl+87)

MAKE_LITERAL_STRING "wt^k88"

MAKE_LITERAL_SYMBOL(const_tbl+121)

MAKE_LITERAL_PAIR(const_tbl+104,const_tbl+136)

MAKE_LITERAL_FLOAT(9.81762993813e-11)

MAKE_LITERAL_RATIONAL(149,166)

MAKE_LITERAL_PAIR(const_tbl+162,const_tbl+171)

MAKE_LITERAL_FLOAT(6703.5226282)

MAKE_LITERAL_RATIONAL(-293,1)

MAKE_LITERAL_PAIR(const_tbl+205,const_tbl+214)

MAKE_LITERAL_PAIR(const_tbl+188,const_tbl+231)

MAKE_LITERAL_PAIR(const_tbl+145,const_tbl+248)

MAKE_LITERAL_FLOAT(2.83281821004e-08)

MAKE_LITERAL_FLOAT(0.0790234523418)

MAKE_LITERAL_PAIR(const_tbl+291,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+282,const_tbl+300)

MAKE_LITERAL_STRING "t4^k0-ui"

MAKE_LITERAL_SYMBOL(const_tbl+334)

MAKE_LITERAL_FLOAT(9.715097718e-08)

MAKE_LITERAL_PAIR(const_tbl+360,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+351,const_tbl+369)

MAKE_LITERAL_PAIR(const_tbl+317,const_tbl+386)

MAKE_LITERAL_PAIR(const_tbl+265,const_tbl+403)

MAKE_LITERAL_RATIONAL(43,37)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+437)

MAKE_LITERAL_RATIONAL(-207,1)

MAKE_LITERAL_STRING "y+?0<jo87"

MAKE_LITERAL_SYMBOL(const_tbl+488)

MAKE_LITERAL_PAIR(const_tbl+471,const_tbl+506)

MAKE_LITERAL_CHAR(68)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+532)

MAKE_LITERAL_PAIR(const_tbl+515,const_tbl+534)

MAKE_LITERAL_FLOAT(88872923.8028)

MAKE_LITERAL_FLOAT(0.000296757975588)

MAKE_LITERAL_RATIONAL(-703,1)

MAKE_LITERAL_PAIR(const_tbl+577,const_tbl+586)

MAKE_LITERAL_PAIR(const_tbl+568,const_tbl+603)

MAKE_LITERAL_PAIR(const_tbl+551,const_tbl+620)

MAKE_LITERAL_PAIR(const_tbl+454,const_tbl+637)

MAKE_LITERAL_PAIR(const_tbl+420,const_tbl+654)

MAKE_LITERAL_CHAR(44)

MAKE_LITERAL_PAIR(const_tbl+688,const_tbl+1)

MAKE_LITERAL_FLOAT(54138341.7145)

MAKE_LITERAL_PAIR(const_tbl+707,const_tbl+2)

MAKE_LITERAL_PAIR(const_tbl+690,const_tbl+716)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+733)

MAKE_LITERAL_FLOAT(41826.1795921)

MAKE_LITERAL_CHAR(51)

MAKE_LITERAL_PAIR(const_tbl+767,const_tbl+776)

MAKE_LITERAL_STRING "a9zzcd"

MAKE_LITERAL_SYMBOL(const_tbl+795)

MAKE_LITERAL_PAIR(const_tbl+778,const_tbl+810)

MAKE_LITERAL_STRING "q*a0?7i?ca"

MAKE_LITERAL_SYMBOL(const_tbl+836)

MAKE_LITERAL_PAIR(const_tbl+855,const_tbl+2)

MAKE_LITERAL_CHAR(52)

MAKE_LITERAL_CHAR(55)

MAKE_LITERAL_PAIR(const_tbl+881,const_tbl+883)

MAKE_LITERAL_PAIR(const_tbl+864,const_tbl+885)

MAKE_LITERAL_PAIR(const_tbl+819,const_tbl+902)

MAKE_LITERAL_PAIR(const_tbl+750,const_tbl+919)

MAKE_LITERAL_STRING "v$j73$=y+s"

MAKE_LITERAL_SYMBOL(const_tbl+953)

MAKE_LITERAL_FLOAT(8.50267466649e-08)

MAKE_LITERAL_PAIR(const_tbl+972,const_tbl+981)

MAKE_LITERAL_STRING "a0>v^8vq1<"

MAKE_LITERAL_SYMBOL(const_tbl+1007)

MAKE_LITERAL_RATIONAL(261,719)

MAKE_LITERAL_PAIR(const_tbl+1026,const_tbl+1035)

MAKE_LITERAL_PAIR(const_tbl+990,const_tbl+1052)

MAKE_LITERAL_STRING "aocx42t7"

MAKE_LITERAL_SYMBOL(const_tbl+1086)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+1103)

MAKE_LITERAL_RATIONAL(-394,1)

MAKE_LITERAL_PAIR(const_tbl+1129,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+1112,const_tbl+1146)

MAKE_LITERAL_PAIR(const_tbl+1069,const_tbl+1163)

MAKE_LITERAL_RATIONAL(-45,89)

MAKE_LITERAL_CHAR(100)

MAKE_LITERAL_PAIR(const_tbl+1197,const_tbl+1214)

MAKE_LITERAL_RATIONAL(-117,1)

MAKE_LITERAL_PAIR(const_tbl+1233,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+1216,const_tbl+1250)

MAKE_LITERAL_RATIONAL(206,1)

MAKE_LITERAL_PAIR(const_tbl+1284,const_tbl+2)

MAKE_LITERAL_RATIONAL(-67,1)

MAKE_LITERAL_STRING "u5v7a>j6^"

MAKE_LITERAL_SYMBOL(const_tbl+1335)

MAKE_LITERAL_PAIR(const_tbl+1318,const_tbl+1353)

MAKE_LITERAL_PAIR(const_tbl+1301,const_tbl+1362)

MAKE_LITERAL_PAIR(const_tbl+1267,const_tbl+1379)

MAKE_LITERAL_PAIR(const_tbl+1180,const_tbl+1396)

MAKE_LITERAL_PAIR(const_tbl+936,const_tbl+1413)

MAKE_LITERAL_PAIR(const_tbl+671,const_tbl+1430)

MAKE_LITERAL_STRING "se!4190>"

MAKE_LITERAL_SYMBOL(const_tbl+1464)

MAKE_LITERAL_RATIONAL(-503,1)

MAKE_LITERAL_PAIR(const_tbl+1481,const_tbl+1490)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+1507)

MAKE_LITERAL_RATIONAL(814,1)

MAKE_LITERAL_FLOAT(5.33685475812e-08)

MAKE_LITERAL_PAIR(const_tbl+1541,const_tbl+1558)

MAKE_LITERAL_PAIR(const_tbl+1524,const_tbl+1567)

MAKE_LITERAL_RATIONAL(-5,7)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+1601)

MAKE_LITERAL_STRING "x/g9i"

MAKE_LITERAL_SYMBOL(const_tbl+1635)

MAKE_LITERAL_PAIR(const_tbl+881,const_tbl+1649)

MAKE_LITERAL_PAIR(const_tbl+1618,const_tbl+1658)

MAKE_LITERAL_STRING "rjx781d"

MAKE_LITERAL_SYMBOL(const_tbl+1692)

MAKE_LITERAL_RATIONAL(-125,174)

MAKE_LITERAL_PAIR(const_tbl+1708,const_tbl+1717)

MAKE_LITERAL_RATIONAL(185,1)

MAKE_LITERAL_RATIONAL(-43,180)

MAKE_LITERAL_PAIR(const_tbl+1751,const_tbl+1768)

MAKE_LITERAL_PAIR(const_tbl+1734,const_tbl+1785)

MAKE_LITERAL_PAIR(const_tbl+1675,const_tbl+1802)

MAKE_LITERAL_PAIR(const_tbl+1584,const_tbl+1819)

MAKE_LITERAL_RATIONAL(265,174)

MAKE_LITERAL_FLOAT(1.59616353909e-08)

MAKE_LITERAL_PAIR(const_tbl+1853,const_tbl+1870)

MAKE_LITERAL_STRING "y6-co4t9"

MAKE_LITERAL_SYMBOL(const_tbl+1896)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+1913)

MAKE_LITERAL_PAIR(const_tbl+1879,const_tbl+1922)

MAKE_LITERAL_PAIR(const_tbl+1939,const_tbl+1)

MAKE_LITERAL_RATIONAL(-166,311)

MAKE_LITERAL_STRING "t!37+"

MAKE_LITERAL_SYMBOL(const_tbl+1990)

MAKE_LITERAL_RATIONAL(-485,1)

MAKE_LITERAL_PAIR(const_tbl+2013,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+2004,const_tbl+2030)

MAKE_LITERAL_PAIR(const_tbl+1973,const_tbl+2047)

MAKE_LITERAL_CHAR(40)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+2081)

MAKE_LITERAL_FLOAT(9.94259010484e-10)

MAKE_LITERAL_PAIR(const_tbl+2100,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+2083,const_tbl+2109)

MAKE_LITERAL_PAIR(const_tbl+2064,const_tbl+2126)

MAKE_LITERAL_PAIR(const_tbl+1956,const_tbl+2143)

MAKE_LITERAL_PAIR(const_tbl+1836,const_tbl+2160)

MAKE_LITERAL_STRING "hsz1mc>*_8"

MAKE_LITERAL_SYMBOL(const_tbl+2194)

MAKE_LITERAL_PAIR(const_tbl+2213,const_tbl+2)

MAKE_LITERAL_CHAR(77)

MAKE_LITERAL_FLOAT(5.3859153991e-09)

MAKE_LITERAL_PAIR(const_tbl+2239,const_tbl+2241)

MAKE_LITERAL_PAIR(const_tbl+2222,const_tbl+2250)

MAKE_LITERAL_FLOAT(9.3498795545e-07)

MAKE_LITERAL_CHAR(48)

MAKE_LITERAL_PAIR(const_tbl+2284,const_tbl+2293)

MAKE_LITERAL_STRING "f8<l$45*$1"

MAKE_LITERAL_SYMBOL(const_tbl+2312)

MAKE_LITERAL_STRING "v5e??>>i="

MAKE_LITERAL_SYMBOL(const_tbl+2340)

MAKE_LITERAL_PAIR(const_tbl+2331,const_tbl+2358)

MAKE_LITERAL_PAIR(const_tbl+2295,const_tbl+2367)

MAKE_LITERAL_PAIR(const_tbl+2267,const_tbl+2384)

MAKE_LITERAL_STRING "w^+2e"

MAKE_LITERAL_SYMBOL(const_tbl+2418)

MAKE_LITERAL_CHAR(79)

MAKE_LITERAL_PAIR(const_tbl+2432,const_tbl+2441)

MAKE_LITERAL_PAIR(const_tbl+2401,const_tbl+2443)

MAKE_LITERAL_STRING "p8yon<1o8"

MAKE_LITERAL_SYMBOL(const_tbl+2477)

MAKE_LITERAL_RATIONAL(-395,531)

MAKE_LITERAL_PAIR(const_tbl+2495,const_tbl+2504)

MAKE_LITERAL_FLOAT(12808877.0061)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+2538)

MAKE_LITERAL_PAIR(const_tbl+2521,const_tbl+2547)

MAKE_LITERAL_RATIONAL(-35,1)

MAKE_LITERAL_FLOAT(4.99701505343)

MAKE_LITERAL_PAIR(const_tbl+2581,const_tbl+2598)

MAKE_LITERAL_CHAR(112)

MAKE_LITERAL_RATIONAL(125,869)

MAKE_LITERAL_PAIR(const_tbl+2624,const_tbl+2626)

MAKE_LITERAL_PAIR(const_tbl+2607,const_tbl+2643)

MAKE_LITERAL_PAIR(const_tbl+2564,const_tbl+2660)

MAKE_LITERAL_RATIONAL(-684,1)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+2694)

MAKE_LITERAL_FLOAT(7297015.41075)

MAKE_LITERAL_RATIONAL(595,1)

MAKE_LITERAL_PAIR(const_tbl+2728,const_tbl+2737)

MAKE_LITERAL_PAIR(const_tbl+2711,const_tbl+2754)

MAKE_LITERAL_STRING "p2*7373j"

MAKE_LITERAL_SYMBOL(const_tbl+2788)

MAKE_LITERAL_PAIR(const_tbl+2805,const_tbl+2)

MAKE_LITERAL_FLOAT(6.60098550742e-07)

MAKE_LITERAL_RATIONAL(-267,1)

MAKE_LITERAL_PAIR(const_tbl+2831,const_tbl+2840)

MAKE_LITERAL_PAIR(const_tbl+2814,const_tbl+2857)

MAKE_LITERAL_PAIR(const_tbl+2771,const_tbl+2874)

MAKE_LITERAL_PAIR(const_tbl+2677,const_tbl+2891)

MAKE_LITERAL_PAIR(const_tbl+2460,const_tbl+2908)

MAKE_LITERAL_PAIR(const_tbl+2177,const_tbl+2925)

MAKE_LITERAL_PAIR(const_tbl+1447,const_tbl+2942)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+1)

MAKE_LITERAL_CHAR(83)

MAKE_LITERAL_PAIR(const_tbl+2993,const_tbl+2)

MAKE_LITERAL_PAIR(const_tbl+2976,const_tbl+2995)

MAKE_LITERAL_FLOAT(7531175.88192)

MAKE_LITERAL_RATIONAL(-524,1)

MAKE_LITERAL_PAIR(const_tbl+3029,const_tbl+3038)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+4)

MAKE_LITERAL_PAIR(const_tbl+3055,const_tbl+3072)

MAKE_LITERAL_PAIR(const_tbl+3012,const_tbl+3089)

MAKE_LITERAL_RATIONAL(925,1)

MAKE_LITERAL_CHAR(53)

MAKE_LITERAL_PAIR(const_tbl+3123,const_tbl+3140)

MAKE_LITERAL_FLOAT(3.74690936354e-09)

MAKE_LITERAL_PAIR(const_tbl+3159,const_tbl+4)

MAKE_LITERAL_PAIR(const_tbl+3142,const_tbl+3168)

MAKE_LITERAL_STRING "j4h1$o$"

MAKE_LITERAL_SYMBOL(const_tbl+3202)

MAKE_LITERAL_RATIONAL(-211,196)

MAKE_LITERAL_PAIR(const_tbl+3218,const_tbl+3227)

MAKE_LITERAL_RATIONAL(522,1)

MAKE_LITERAL_PAIR(const_tbl+3244,const_tbl+3261)

MAKE_LITERAL_PAIR(const_tbl+3185,const_tbl+3278)

MAKE_LITERAL_PAIR(const_tbl+3106,const_tbl+3295)

MAKE_LITERAL_STRING "z>929+"

MAKE_LITERAL_SYMBOL(const_tbl+3329)

MAKE_LITERAL_FLOAT(173351.360148)

MAKE_LITERAL_STRING "juk<wvm0?"

MAKE_LITERAL_SYMBOL(const_tbl+3362)

MAKE_LITERAL_PAIR(const_tbl+3353,const_tbl+3380)

MAKE_LITERAL_PAIR(const_tbl+3344,const_tbl+3389)

MAKE_LITERAL_STRING "vu87$"

MAKE_LITERAL_SYMBOL(const_tbl+3423)

MAKE_LITERAL_PAIR(const_tbl+3437,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+3446)

MAKE_LITERAL_PAIR(const_tbl+3406,const_tbl+3463)

MAKE_LITERAL_RATIONAL(-156,463)

MAKE_LITERAL_FLOAT(715.993927838)

MAKE_LITERAL_PAIR(const_tbl+3497,const_tbl+3514)

MAKE_LITERAL_RATIONAL(-624,1)

MAKE_LITERAL_PAIR(const_tbl+3540,const_tbl+4)

MAKE_LITERAL_PAIR(const_tbl+3523,const_tbl+3557)

MAKE_LITERAL_STRING "a9/<2iqp$"

MAKE_LITERAL_SYMBOL(const_tbl+3591)

MAKE_LITERAL_RATIONAL(199,1)

MAKE_LITERAL_PAIR(const_tbl+3609,const_tbl+3618)

MAKE_LITERAL_RATIONAL(-141,1)

MAKE_LITERAL_PAIR(const_tbl+3652,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+3635,const_tbl+3669)

MAKE_LITERAL_PAIR(const_tbl+3574,const_tbl+3686)

MAKE_LITERAL_PAIR(const_tbl+3480,const_tbl+3703)

MAKE_LITERAL_PAIR(const_tbl+3312,const_tbl+3720)

MAKE_LITERAL_RATIONAL(923,660)

MAKE_LITERAL_PAIR(const_tbl+3754,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+3737,const_tbl+3771)

MAKE_LITERAL_CHAR(87)

MAKE_LITERAL_FLOAT(10.4212734339)

MAKE_LITERAL_PAIR(const_tbl+3805,const_tbl+3807)

MAKE_LITERAL_RATIONAL(944,1)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+3833,const_tbl+3850)

MAKE_LITERAL_PAIR(const_tbl+3816,const_tbl+3867)

MAKE_LITERAL_PAIR(const_tbl+881,const_tbl+2293)

MAKE_LITERAL_RATIONAL(-630,1)

MAKE_LITERAL_FLOAT(0.0899816734596)

MAKE_LITERAL_PAIR(const_tbl+3918,const_tbl+3935)

MAKE_LITERAL_FLOAT(3.36679098586e-09)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+3961)

MAKE_LITERAL_PAIR(const_tbl+3944,const_tbl+3970)

MAKE_LITERAL_PAIR(const_tbl+3901,const_tbl+3987)

MAKE_LITERAL_RATIONAL(34,21)

MAKE_LITERAL_PAIR(const_tbl+4021,const_tbl+1)

MAKE_LITERAL_RATIONAL(-997,613)

MAKE_LITERAL_RATIONAL(-98,159)

MAKE_LITERAL_PAIR(const_tbl+4055,const_tbl+4072)

MAKE_LITERAL_CHAR(118)

MAKE_LITERAL_RATIONAL(-671,1)

MAKE_LITERAL_PAIR(const_tbl+4106,const_tbl+4108)

MAKE_LITERAL_PAIR(const_tbl+4089,const_tbl+4125)

MAKE_LITERAL_PAIR(const_tbl+4038,const_tbl+4142)

MAKE_LITERAL_PAIR(const_tbl+4004,const_tbl+4159)

MAKE_LITERAL_PAIR(const_tbl+3884,const_tbl+4176)

MAKE_LITERAL_RATIONAL(-859,1)

MAKE_LITERAL_PAIR(const_tbl+4210,const_tbl+1)

MAKE_LITERAL_RATIONAL(-242,353)

MAKE_LITERAL_RATIONAL(-943,799)

MAKE_LITERAL_PAIR(const_tbl+4261,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+4278)

MAKE_LITERAL_PAIR(const_tbl+4244,const_tbl+4295)

MAKE_LITERAL_RATIONAL(368,343)

MAKE_LITERAL_RATIONAL(6,1)

MAKE_LITERAL_PAIR(const_tbl+4329,const_tbl+4346)

MAKE_LITERAL_STRING "yj$75"

MAKE_LITERAL_SYMBOL(const_tbl+4380)

MAKE_LITERAL_CHAR(121)

MAKE_LITERAL_PAIR(const_tbl+4394,const_tbl+4403)

MAKE_LITERAL_PAIR(const_tbl+4363,const_tbl+4405)

MAKE_LITERAL_PAIR(const_tbl+4312,const_tbl+4422)

MAKE_LITERAL_PAIR(const_tbl+4227,const_tbl+4439)

MAKE_LITERAL_FLOAT(9092985.94945)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+4473)

MAKE_LITERAL_RATIONAL(-109,59)

MAKE_LITERAL_RATIONAL(309,191)

MAKE_LITERAL_PAIR(const_tbl+4499,const_tbl+4516)

MAKE_LITERAL_PAIR(const_tbl+4482,const_tbl+4533)

MAKE_LITERAL_PAIR(const_tbl+4456,const_tbl+4550)

MAKE_LITERAL_PAIR(const_tbl+4193,const_tbl+4567)

MAKE_LITERAL_PAIR(const_tbl+3788,const_tbl+4584)

MAKE_LITERAL_PAIR(const_tbl+2959,const_tbl+4601)

MAKE_LITERAL_RATIONAL(203,375)

MAKE_LITERAL_CHAR(66)

MAKE_LITERAL_RATIONAL(-47,228)

MAKE_LITERAL_PAIR(const_tbl+4652,const_tbl+4654)

MAKE_LITERAL_CHAR(33)

MAKE_LITERAL_RATIONAL(-379,1)

MAKE_LITERAL_PAIR(const_tbl+4688,const_tbl+4690)

MAKE_LITERAL_STRING "di*q6?u*j"

MAKE_LITERAL_SYMBOL(const_tbl+4724)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+4742)

MAKE_LITERAL_PAIR(const_tbl+4707,const_tbl+4751)

MAKE_LITERAL_RATIONAL(498,1)

MAKE_LITERAL_PAIR(const_tbl+4785,const_tbl+1)

MAKE_LITERAL_RATIONAL(-873,893)

MAKE_LITERAL_STRING "l<6yw5_"

MAKE_LITERAL_SYMBOL(const_tbl+4836)

MAKE_LITERAL_PAIR(const_tbl+4819,const_tbl+4852)

MAKE_LITERAL_PAIR(const_tbl+4802,const_tbl+4861)

MAKE_LITERAL_PAIR(const_tbl+4768,const_tbl+4878)

MAKE_LITERAL_PAIR(const_tbl+4671,const_tbl+4895)

MAKE_LITERAL_CHAR(59)

MAKE_LITERAL_PAIR(const_tbl+4929,const_tbl+1)

MAKE_LITERAL_RATIONAL(-38,51)

MAKE_LITERAL_PAIR(const_tbl+4948,const_tbl+1)

MAKE_LITERAL_STRING "g3be8+8j/z"

MAKE_LITERAL_SYMBOL(const_tbl+4982)

MAKE_LITERAL_STRING "f7n86204m*"

MAKE_LITERAL_SYMBOL(const_tbl+5010)

MAKE_LITERAL_PAIR(const_tbl+5001,const_tbl+5029)

MAKE_LITERAL_PAIR(const_tbl+4965,const_tbl+5038)

MAKE_LITERAL_RATIONAL(637,454)

MAKE_LITERAL_FLOAT(74641.4927958)

MAKE_LITERAL_PAIR(const_tbl+5072,const_tbl+5089)

MAKE_LITERAL_PAIR(const_tbl+5098,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+5055,const_tbl+5115)

MAKE_LITERAL_PAIR(const_tbl+4931,const_tbl+5132)

MAKE_LITERAL_PAIR(const_tbl+4912,const_tbl+5149)

MAKE_LITERAL_STRING "dv9pf639"

MAKE_LITERAL_SYMBOL(const_tbl+5183)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+2)

MAKE_LITERAL_FLOAT(0.765015794496)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+5226)

MAKE_LITERAL_PAIR(const_tbl+5209,const_tbl+5235)

MAKE_LITERAL_PAIR(const_tbl+5200,const_tbl+5252)

MAKE_LITERAL_RATIONAL(-390,1)

MAKE_LITERAL_FLOAT(5.56798715483e-06)

MAKE_LITERAL_PAIR(const_tbl+5303,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+881,const_tbl+5312)

MAKE_LITERAL_PAIR(const_tbl+5286,const_tbl+5329)

MAKE_LITERAL_PAIR(const_tbl+5346,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+5269,const_tbl+5363)

MAKE_LITERAL_FLOAT(8.47382658762e-05)

MAKE_LITERAL_PAIR(const_tbl+5397,const_tbl+1)

MAKE_LITERAL_RATIONAL(124,1)

MAKE_LITERAL_RATIONAL(155,1)

MAKE_LITERAL_PAIR(const_tbl+5423,const_tbl+5440)

MAKE_LITERAL_PAIR(const_tbl+5406,const_tbl+5457)

MAKE_LITERAL_FLOAT(0.0556596526203)

MAKE_LITERAL_STRING "q1c6d0u2"

MAKE_LITERAL_SYMBOL(const_tbl+5500)

MAKE_LITERAL_RATIONAL(-354,1)

MAKE_LITERAL_PAIR(const_tbl+5517,const_tbl+5526)

MAKE_LITERAL_PAIR(const_tbl+5491,const_tbl+5543)

MAKE_LITERAL_PAIR(const_tbl+5474,const_tbl+5560)

MAKE_LITERAL_CHAR(63)

MAKE_LITERAL_FLOAT(645.016131053)

MAKE_LITERAL_PAIR(const_tbl+5594,const_tbl+5596)

MAKE_LITERAL_RATIONAL(-273,1)

MAKE_LITERAL_PAIR(const_tbl+5605,const_tbl+5622)

MAKE_LITERAL_CHAR(57)

MAKE_LITERAL_CHAR(116)

MAKE_LITERAL_PAIR(const_tbl+5656,const_tbl+5658)

MAKE_LITERAL_CHAR(69)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+5677)

MAKE_LITERAL_PAIR(const_tbl+5660,const_tbl+5679)

MAKE_LITERAL_PAIR(const_tbl+5639,const_tbl+5696)

MAKE_LITERAL_PAIR(const_tbl+5577,const_tbl+5713)

MAKE_LITERAL_PAIR(const_tbl+5380,const_tbl+5730)

MAKE_LITERAL_PAIR(const_tbl+5166,const_tbl+5747)

MAKE_LITERAL_PAIR(const_tbl+4635,const_tbl+5764)

MAKE_LITERAL_STRING "zh><>d$o"

MAKE_LITERAL_SYMBOL(const_tbl+5798)

MAKE_LITERAL_FLOAT(3.59935512583e-09)

MAKE_LITERAL_PAIR(const_tbl+5815,const_tbl+5824)

MAKE_LITERAL_PAIR(const_tbl+4,const_tbl+2)

MAKE_LITERAL_PAIR(const_tbl+5833,const_tbl+5850)

MAKE_LITERAL_PAIR(const_tbl+5867,const_tbl+2976)

MAKE_LITERAL_RATIONAL(970,1)

MAKE_LITERAL_PAIR(const_tbl+5901,const_tbl+1)

MAKE_LITERAL_FLOAT(33070.2852975)

MAKE_LITERAL_FLOAT(8.77865834575e-05)

MAKE_LITERAL_PAIR(const_tbl+5935,const_tbl+5944)

MAKE_LITERAL_PAIR(const_tbl+5918,const_tbl+5953)

MAKE_LITERAL_STRING "e5i6bd6"

MAKE_LITERAL_SYMBOL(const_tbl+5987)

MAKE_LITERAL_RATIONAL(-167,1)

MAKE_LITERAL_PAIR(const_tbl+6003,const_tbl+6012)

MAKE_LITERAL_PAIR(const_tbl+1,const_tbl+2)

MAKE_LITERAL_PAIR(const_tbl+6029,const_tbl+6046)

MAKE_LITERAL_PAIR(const_tbl+5970,const_tbl+6063)

MAKE_LITERAL_PAIR(const_tbl+5884,const_tbl+6080)

MAKE_LITERAL_FLOAT(30852840.6638)

MAKE_LITERAL_FLOAT(5.23986962147e-05)

MAKE_LITERAL_PAIR(const_tbl+6123,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+2,const_tbl+6132)

MAKE_LITERAL_PAIR(const_tbl+6149,const_tbl+1)

MAKE_LITERAL_PAIR(const_tbl+6114,const_tbl+6166)

MAKE_LITERAL_PAIR(const_tbl+6097,const_tbl+6183)

MAKE_LITERAL_PAIR(const_tbl+5781,const_tbl+6200)

MAKE_LITERAL_PAIR(const_tbl+4618,const_tbl+6217)


;;; These macro definitions are required for the primitive
;;; definitions in the epilogue to work properly
%define SOB_VOID_ADDRESS const_tbl+0
%define SOB_NIL_ADDRESS const_tbl+1
%define SOB_FALSE_ADDRESS const_tbl+4
%define SOB_TRUE_ADDRESS const_tbl+2

global main
section .text
main:
    ;; set up the heap
    mov rdi, GB(2)
    call malloc
    mov [malloc_pointer], rax

    ;; Set up the dummy activation frame
    ;; The dummy return address is T_UNDEFINED
    ;; (which a is a macro for 0) so that returning
    ;; from the top level (which SHOULD NOT HAPPEN
    ;; AND IS A BUG) will cause a segfault.
    push 0                ; argument count
    push SOB_NIL_ADDRESS  ; lexical environment address
    push T_UNDEFINED      ; return address
    push rbp                    
    mov rbp, rsp                ; anchor the dummy frame

    ;; Set up the primitive stdlib fvars:
    ;; Since the primtive procedures are defined in assembly,
    ;; they are not generated by scheme (define ...) expressions.
    ;; This is where we simulate the missing (define ...) expressions
    ;; for all the primitive procedures.
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, boolean?)
mov [fvar_tbl+320], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, flonum?)
mov [fvar_tbl+200], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, rational?)
mov [fvar_tbl+208], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, pair?)
mov [fvar_tbl+112], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, null?)
mov [fvar_tbl+8], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, char?)
mov [fvar_tbl+296], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string?)
mov [fvar_tbl+304], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, procedure?)
mov [fvar_tbl+328], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, symbol?)
mov [fvar_tbl+336], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_length)
mov [fvar_tbl+288], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_ref)
mov [fvar_tbl+280], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, string_set)
mov [fvar_tbl+344], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, make_string)
mov [fvar_tbl+120], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, symbol_to_string)
mov [fvar_tbl+352], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, char_to_integer)
mov [fvar_tbl+312], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, integer_to_char)
mov [fvar_tbl+360], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, exact_to_inexact)
mov [fvar_tbl+216], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, eq?)
mov [fvar_tbl+80], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, add)
mov [fvar_tbl+136], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, mul)
mov [fvar_tbl+144], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, div)
mov [fvar_tbl+152], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, eq)
mov [fvar_tbl+184], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, lt)
mov [fvar_tbl+192], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, numerator)
mov [fvar_tbl+160], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, denominator)
mov [fvar_tbl+168], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, gcd)
mov [fvar_tbl+176], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, cons)
mov [fvar_tbl+32], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, apply)
mov [fvar_tbl+40], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, car)
mov [fvar_tbl+16], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, cdr)
mov [fvar_tbl+24], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, set_car)
mov [fvar_tbl+368], rax
MAKE_CLOSURE(rax, SOB_NIL_ADDRESS, set_cdr)
mov [fvar_tbl+376], rax

user_code_fragment:
;;; The code you compiled will be added here.
;;; It will be executed immediately after the closures for 
;;; the primitive procedures are set up.
mov rax, qword[fvar_tbl+40]
push rax
mov rax, qword[fvar_tbl+32]
push rax
mov rax, qword[fvar_tbl+24]
push rax
mov rax, qword[fvar_tbl+16]
push rax
mov rax, qword[fvar_tbl+8]
push rax
push 5
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode1)
jmp Lcont1
Lcode1:
push rbp
mov rbp, rsp
mov rax,const_tbl+23
push rax
mov rax,const_tbl+23
push rax
push 2
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode2)
jmp Lcont2
Lcode2:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8 * (4 + 0)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 0)],rax
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
mov rax, qword[rbp + 8 * (4 + 1)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 1)],rax
mov qword [rbp + 8*(4+1)], rax
mov rax, SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode3)
jmp Lcont3
Lcode3:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse4
mov rax,const_tbl+1
jmp Lexit4
Lelse4:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit4:
leave
ret
Lcont3:
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode5)
jmp Lcont5
Lcode5:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse6
mov rax,const_tbl+1
jmp Lexit6
Lelse6:
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*(4+0)]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit6:
leave
ret
Lcont5:
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode7)
jmp Lcont7
Lcode7:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont7:
leave
ret
Lcont2:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont1:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+0], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode8)
jmp Lcont8
Lcode8:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+2)]
push rax
push 1
mov rax, qword[fvar_tbl+8]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse9
mov rax, qword[rbp + 8*(4+1)]
jmp Lexit9
Lelse9:
mov rax, qword[rbp + 8*(4+2)]
push rax
push 1
mov rax, qword[fvar_tbl+24]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+2)]
push rax
push 1
mov rax, qword[fvar_tbl+16]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
push 2
mov rax, qword[rbp + 8*(4+0)]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 3
mov rax, qword[fvar_tbl+48]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
Lexit9:
leave
ret
Lcont8:
mov qword[fvar_tbl+48], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode10)
jmp Lcont10
Lcode10:
push rbp
mov rbp, rsp
mov rax,const_tbl+1
push rax
mov rax, qword[rbp + 8*(4+2)]
push rax
push 2
mov rax, qword[fvar_tbl+64]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse11
mov rax, qword[rbp + 8*(4+1)]
jmp Lexit11
Lelse11:
mov rax, qword[rbp + 8*(4+2)]
push rax
push 1
mov rax, qword[fvar_tbl+24]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 3
mov rax, qword[fvar_tbl+56]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+2)]
push rax
push 1
mov rax, qword[fvar_tbl+16]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*(4+0)]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit11:
leave
ret
Lcont10:
mov qword[fvar_tbl+56], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode12)
jmp Lcont12
Lcode12:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax,const_tbl+1
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
push 2
mov rax, qword[fvar_tbl+80]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse13
mov rax, qword[rbp + 8*(4+0)]
jmp Lexit13
Lelse13:
mov rax,const_tbl+23
push rax
push 1
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode14)
jmp Lcont14
Lcode14:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8 * (4 + 0)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 0)],rax
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode15)
jmp Lcont15
Lcode15:
push rbp
mov rbp, rsp
mov rax,const_tbl+1
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+24]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[fvar_tbl+80]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse16
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+16]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit16
Lelse16:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+24]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+16]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[fvar_tbl+32]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit16:
leave
ret
Lcont15:
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
push rax
push 1
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 2
mov rax, qword[fvar_tbl+32]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont14:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
Lexit13:
leave
ret
Lcont12:
mov qword[fvar_tbl+72], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+32]
push rax
mov rax, qword[fvar_tbl+56]
push rax
mov rax, qword[fvar_tbl+8]
push rax
push 3
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode17)
jmp Lcont17
Lcode17:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode18)
jmp Lcont18
Lcode18:
FIX_STACK_LAMBDA_OPT 1
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+1
push rax
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode19)
jmp Lcont19
Lcode19:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse20
mov rax, qword[rbp + 8*(4+0)]
jmp Lexit20
Lelse20:
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
Lexit20:
leave
ret
Lcont19:
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont18:
leave
ret
Lcont17:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+88], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode21)
jmp Lcont21
Lcode21:
FIX_STACK_LAMBDA_OPT 1
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
leave
ret
Lcont21:
mov qword[fvar_tbl+96], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+24]
push rax
mov rax, qword[fvar_tbl+112]
push rax
mov rax, qword[fvar_tbl+8]
push rax
push 3
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode22)
jmp Lcont22
Lcode22:
push rbp
mov rbp, rsp
mov rax,const_tbl+23
push rax
push 1
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode23)
jmp Lcont23
Lcode23:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode24)
jmp Lcont24
Lcode24:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
jne Lexit25
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse26
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[fvar_tbl+104]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit26
Lelse26:
mov rax,const_tbl+4
Lexit26:
cmp rax, SOB_FALSE_ADDRESS
jne Lexit25
Lexit25:
leave
ret
Lcont24:
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
mov rax, qword[rbp + 8*(4+0)]
leave
ret
Lcont23:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont22:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+104], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+120]
push rax
mov rax, qword[fvar_tbl+16]
push rax
mov rax, qword[fvar_tbl+8]
push rax
push 3
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode27)
jmp Lcont27
Lcode27:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode28)
jmp Lcont28
Lcode28:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse29
mov rax,const_tbl+32
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit29
Lelse29:
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit29:
leave
ret
Lcont28:
leave
ret
Lcont27:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+120], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode30)
jmp Lcont30
Lcode30:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
cmp rax, SOB_FALSE_ADDRESS
je Lelse31
mov rax,const_tbl+4
jmp Lexit31
Lelse31:
mov rax,const_tbl+2
Lexit31:
leave
ret
Lcont30:
mov qword[fvar_tbl+128], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+8]
push rax
mov rax, qword[fvar_tbl+24]
push rax
mov rax, qword[fvar_tbl+16]
push rax
mov rax, qword[fvar_tbl+192]
push rax
mov rax, qword[fvar_tbl+184]
push rax
mov rax, qword[fvar_tbl+152]
push rax
mov rax, qword[fvar_tbl+144]
push rax
mov rax, qword[fvar_tbl+136]
push rax
mov rax, qword[fvar_tbl+0]
push rax
mov rax, qword[fvar_tbl+48]
push rax
mov rax, qword[fvar_tbl+216]
push rax
mov rax, qword[fvar_tbl+208]
push rax
mov rax, qword[fvar_tbl+200]
push rax
push 13
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode32)
jmp Lcont32
Lcode32:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode33)
jmp Lcont33
Lcode33:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode34)
jmp Lcont34
Lcode34:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse38
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit38
Lelse38:
mov rax,const_tbl+4
Lexit38:
cmp rax, SOB_FALSE_ADDRESS
je Lelse35
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit35
Lelse35:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse37
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit37
Lelse37:
mov rax,const_tbl+4
Lexit37:
cmp rax, SOB_FALSE_ADDRESS
je Lelse36
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit36
Lelse36:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit36:
Lexit35:
leave
ret
Lcont34:
leave
ret
Lcont33:
push rax
push 1
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode39)
jmp Lcont39
Lcode39:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode40)
jmp Lcont40
Lcode40:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse41
mov rax, qword[rbp + 8*(4+0)]
jmp Lexit41
Lelse41:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+168]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[fvar_tbl+160]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[fvar_tbl+176]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode42)
jmp Lcont42
Lcode42:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1
mov rax, qword[fvar_tbl+168]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 7]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1
mov rax, qword[fvar_tbl+160]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 7]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 7]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont42:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
Lexit41:
leave
ret
Lcont40:
push rax
push 1
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode43)
jmp Lcont43
Lcode43:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode44)
jmp Lcont44
Lcode44:
FIX_STACK_LAMBDA_OPT 1
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+34
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 5]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont44:
mov qword [fvar_tbl+136],rax
mov rax,SOB_VOID_ADDRESS
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode45)
jmp Lcont45
Lcode45:
FIX_STACK_LAMBDA_OPT 1
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+51
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 6]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont45:
mov qword [fvar_tbl+144],rax
mov rax,SOB_VOID_ADDRESS
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 7]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode46)
jmp Lcont46
Lcode46:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 4
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode47)
jmp Lcont47
Lcode47:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 3]
mov rax, qword[rax + 8 * 12]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse48
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+51
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit48
Lelse48:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 3]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
Lexit48:
leave
ret
Lcont47:
leave
ret
Lcont46:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword [fvar_tbl+152],rax
mov rax,SOB_VOID_ADDRESS
leave
ret
Lcont43:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode49)
jmp Lcont49
Lcode49:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode50)
jmp Lcont50
Lcode50:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
MAKE_EXT_ENV 4
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode51)
jmp Lcont51
Lcode51:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont51:
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax,const_tbl+2
push rax
MAKE_EXT_ENV 4
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode52)
jmp Lcont52
Lcode52:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
cmp rax, SOB_FALSE_ADDRESS
je Lelse53
mov rax, qword[rbp + 8*(4+1)]
jmp Lexit53
Lelse53:
mov rax,const_tbl+4
Lexit53:
leave
ret
Lcont52:
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont50:
leave
ret
Lcont49:
push rax
push 1
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode54)
jmp Lcont54
Lcode54:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 8]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*(4+0)]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword [fvar_tbl+184],rax
mov rax,SOB_VOID_ADDRESS
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 9]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 1
mov rax, qword[rbp + 8*(4+0)]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword [fvar_tbl+192],rax
mov rax,SOB_VOID_ADDRESS
leave
ret
Lcont54:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont39:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont32:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+8]
push rax
mov rax, qword[fvar_tbl+136]
push rax
mov rax, qword[fvar_tbl+40]
push rax
push 3
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode55)
jmp Lcont55
Lcode55:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode56)
jmp Lcont56
Lcode56:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse57
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+68
push rax
push 2
mov rax, qword[fvar_tbl+144]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax,const_tbl+34
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit57
Lelse57:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax,const_tbl+68
push rax
push 2
mov rax, qword[fvar_tbl+144]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit57:
leave
ret
Lcont56:
leave
ret
Lcont55:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+224], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+48]
push rax
mov rax, qword[fvar_tbl+184]
push rax
mov rax, qword[fvar_tbl+192]
push rax
mov rax, qword[fvar_tbl+128]
push rax
mov rax, qword[fvar_tbl+8]
push rax
push 5
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode58)
jmp Lcont58
Lcode58:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode59)
jmp Lcont59
Lcode59:
FIX_STACK_LAMBDA_OPT 2
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax,const_tbl+2
push rax
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode60)
jmp Lcont60
Lcode60:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
cmp rax, SOB_FALSE_ADDRESS
je Lelse61
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
jne Lexit62
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
jne Lexit62
Lexit62:
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit61
Lelse61:
mov rax,const_tbl+4
Lexit61:
leave
ret
Lcont60:
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont59:
leave
ret
Lcont58:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+232], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+24]
push rax
mov rax, qword[fvar_tbl+16]
push rax
mov rax, qword[fvar_tbl+8]
push rax
mov rax, qword[fvar_tbl+176]
push rax
push 4
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode63)
jmp Lcont63
Lcode63:
push rbp
mov rbp, rsp
mov rax,const_tbl+23
push rax
push 1
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode64)
jmp Lcont64
Lcode64:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8 * (4 + 0)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 0)],rax
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode65)
jmp Lcont65
Lcode65:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse66
mov rax, qword[rbp + 8*(4+0)]
jmp Lexit66
Lelse66:
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit66:
leave
ret
Lcont65:
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode67)
jmp Lcont67
Lcode67:
FIX_STACK_LAMBDA_OPT 1
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse68
mov rax,const_tbl+34
jmp Lexit68
Lelse68:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit68:
leave
ret
Lcont67:
leave
ret
Lcont64:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont63:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+176], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+184]
push rax
push 1
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode69)
jmp Lcont69
Lcode69:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode70)
jmp Lcont70
Lcode70:
push rbp
mov rbp, rsp
mov rax,const_tbl+34
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont70:
leave
ret
Lcont69:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+240], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+168]
push rax
mov rax, qword[fvar_tbl+184]
push rax
mov rax, qword[fvar_tbl+208]
push rax
push 3
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode71)
jmp Lcont71
Lcode71:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode72)
jmp Lcont72
Lcode72:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse73
mov rax,const_tbl+51
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit73
Lelse73:
mov rax,const_tbl+4
Lexit73:
leave
ret
Lcont72:
leave
ret
Lcont71:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+248], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+208]
push rax
mov rax, qword[fvar_tbl+200]
push rax
push 2
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode74)
jmp Lcont74
Lcode74:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode75)
jmp Lcont75
Lcode75:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
jne Lexit76
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
cmp rax, SOB_FALSE_ADDRESS
jne Lexit76
Lexit76:
leave
ret
Lcont75:
leave
ret
Lcont74:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+256], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+136]
push rax
mov rax, qword[fvar_tbl+48]
push rax
push 2
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode77)
jmp Lcont77
Lcode77:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode78)
jmp Lcont78
Lcode78:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax,const_tbl+34
push rax
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode79)
jmp Lcont79
Lcode79:
push rbp
mov rbp, rsp
mov rax,const_tbl+51
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont79:
push rax
push 3
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 6
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont78:
leave
ret
Lcont77:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+264], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+32]
push rax
mov rax, qword[fvar_tbl+224]
push rax
mov rax, qword[fvar_tbl+192]
push rax
mov rax, qword[fvar_tbl+288]
push rax
mov rax, qword[fvar_tbl+280]
push rax
push 5
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode80)
jmp Lcont80
Lcode80:
push rbp
mov rbp, rsp
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode81)
jmp Lcont81
Lcode81:
push rbp
mov rbp, rsp
mov rax,const_tbl+23
push rax
push 1
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode82)
jmp Lcont82
Lcode82:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8 * (4 + 0)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 0)],rax
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
MAKE_EXT_ENV 3
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode83)
jmp Lcont83
Lcode83:
push rbp
mov rbp, rsp
mov rax,const_tbl+34
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse84
mov rax, qword[rbp + 8*(4+1)]
jmp Lexit84
Lelse84:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax,const_tbl+51
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 2]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit84:
leave
ret
Lcont83:
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
mov rax,const_tbl+1
push rax
mov rax,const_tbl+51
push rax
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont82:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont81:
leave
ret
Lcont80:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+272], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax, qword[fvar_tbl+312]
push rax
mov rax, qword[fvar_tbl+24]
push rax
mov rax, qword[fvar_tbl+16]
push rax
mov rax, qword[fvar_tbl+80]
push rax
mov rax, qword[fvar_tbl+304]
push rax
mov rax, qword[fvar_tbl+296]
push rax
mov rax, qword[fvar_tbl+112]
push rax
mov rax, qword[fvar_tbl+200]
push rax
mov rax, qword[fvar_tbl+208]
push rax
mov rax, qword[fvar_tbl+272]
push rax
mov rax, qword[fvar_tbl+184]
push rax
push 11
MAKE_EXT_ENV 0
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode85)
jmp Lcont85
Lcode85:
push rbp
mov rbp, rsp
mov rax,const_tbl+23
push rax
push 1
MAKE_EXT_ENV 1
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode86)
jmp Lcont86
Lcode86:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8 * (4 + 0)]
push SOB_NIL_ADDRESS ; something for the cdr
push rax             ; car
push 2               ; argc
push SOB_NIL_ADDRESS ;fake env
call cons
add rsp,8*1          ;pop env
pop rbx              ;pop argc
shl rbx,3            ;rbx=rbx*8
add rsp,rbx          ;pop args
mov qword[rbp + 8 * (4 + 0)],rax
mov qword [rbp + 8*(4+0)], rax
mov rax, SOB_VOID_ADDRESS
MAKE_EXT_ENV 2
mov rbx, rax
MAKE_CLOSURE(rax, rbx, Lcode87)
jmp Lcont87
Lcode87:
push rbp
mov rbp, rsp
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse98
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 2]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit98
Lelse98:
mov rax,const_tbl+4
Lexit98:
cmp rax, SOB_FALSE_ADDRESS
je Lelse88
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit88
Lelse88:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse97
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 3]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit97
Lelse97:
mov rax,const_tbl+4
Lexit97:
cmp rax, SOB_FALSE_ADDRESS
je Lelse89
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit89
Lelse89:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 5]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse96
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 5]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit96
Lelse96:
mov rax,const_tbl+4
Lexit96:
cmp rax, SOB_FALSE_ADDRESS
je Lelse90
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 10]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 10]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 0]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit90
Lelse90:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse95
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 4]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit95
Lelse95:
mov rax,const_tbl+4
Lexit95:
cmp rax, SOB_FALSE_ADDRESS
je Lelse91
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 8]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 8]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse94
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 9]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 9]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit94
Lelse94:
mov rax,const_tbl+4
Lexit94:
jmp Lexit91
Lelse91:
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 6]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
cmp rax, SOB_FALSE_ADDRESS
je Lelse93
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 6]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
jmp Lexit93
Lelse93:
mov rax,const_tbl+4
Lexit93:
cmp rax, SOB_FALSE_ADDRESS
je Lelse92
mov rax, qword[rbp + 8*(4+1)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 1]
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 0]
mov rax, qword[rax + 8 * 0]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
jmp Lexit92
Lelse92:
mov rax, qword[rbp + 8*(4+1)]
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
mov rax, qword[rbp + 8*2]
mov rax, qword[rax + 8 * 1]
mov rax, qword[rax + 8 * 7]
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 5
CLOSURE_CODE rbx, rax
jmp rbx
Lexit92:
Lexit91:
Lexit90:
Lexit89:
Lexit88:
leave
ret
Lcont87:
push rax
mov rax, qword[rbp + 8*(4+0)]
push rax
push 2
push SOB_NIL_ADDRESS
call set_car
add rsp, 8              ;pop env
pop rbx                 ;pop argc

shl rbx, 3              ;rbx=rbx*8
add rsp, rbx            ;pop args
mov rax,SOB_VOID_ADDRESS
mov rax, qword[rbp + 8*(4+0)]
push rax
push 1                 ;push argc
push SOB_NIL_ADDRESS   ;fake env
call car
add rsp,8*1            ;pop env
pop rbx                ;pop argc
shl rbx,3              ;rbx=rbx*8 
add rsp, rbx           ;pop args
leave
ret
Lcont86:
CLOSURE_ENV rbx, rax
push rbx
push qword[rbp + 8 * 1] ;old ret addr
FIX_STACK_APPLICTP 4
CLOSURE_CODE rbx, rax
jmp rbx
leave
ret
Lcont85:
CLOSURE_ENV rbx, rax
push rbx
CLOSURE_CODE rbx, rax
call rbx
add rsp,8*1 ;pop env
pop rbx     ;pop arg count
shl rbx,3   ;rbx = rbx*8
add rsp,rbx ;pop args
mov qword[fvar_tbl+64], rax
mov rax, SOB_VOID_ADDRESS

	call write_sob_if_not_void

mov rax,const_tbl+6234

	call write_sob_if_not_void;;; Clean up the dummy frame, set the exit status to 0 ("success"), 
   ;;; and return from main
   pop rbp
   add rsp, 3*8
   mov rax, 0

   ret
boolean?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_BOOL
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

flonum?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_FLOAT
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

rational?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_RATIONAL
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

pair?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_PAIR
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

null?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_NIL
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

char?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_CHAR
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

string?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_STRING
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

symbol?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_SYMBOL
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

procedure?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov sil, byte [rsi]
	cmp sil, T_CLOSURE
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

div:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov dl, byte [rsi]
             cmp dl, T_FLOAT
	     jne .div_rat
             FLOAT_VAL rsi, rsi 
          movq xmm0, rsi
          FLOAT_VAL rdi, rdi 
          movq xmm1, rdi
	  divsd xmm0, xmm1
          movq rsi, xmm0
          MAKE_FLOAT(rax, rsi)
             jmp .op_return
          .div_rat:
             DENOMINATOR rcx, rsi
	  DENOMINATOR rdx, rdi
	  NUMERATOR rsi, rsi
	  NUMERATOR rdi, rdi
          MAKE_RATIONAL(rax, rdx, rdi)
         mov PVAR(1), rax
         pop rbp
         jmp mul
          MAKE_RATIONAL(rax, rsi, rcx)
          .op_return:
         pop rbp
         ret

mul:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov dl, byte [rsi]
             cmp dl, T_FLOAT
	     jne .mul_rat
             FLOAT_VAL rsi, rsi 
          movq xmm0, rsi
          FLOAT_VAL rdi, rdi 
          movq xmm1, rdi
	  mulsd xmm0, xmm1
          movq rsi, xmm0
          MAKE_FLOAT(rax, rsi)
             jmp .op_return
          .mul_rat:
             DENOMINATOR rcx, rsi
	  DENOMINATOR rdx, rdi
	  NUMERATOR rsi, rsi
	  NUMERATOR rdi, rdi
          imul rsi, rdi
	 imul rcx, rdx
          MAKE_RATIONAL(rax, rsi, rcx)
          .op_return:
         pop rbp
         ret

add:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov dl, byte [rsi]
             cmp dl, T_FLOAT
	     jne .add_rat
             FLOAT_VAL rsi, rsi 
          movq xmm0, rsi
          FLOAT_VAL rdi, rdi 
          movq xmm1, rdi
	  addsd xmm0, xmm1
          movq rsi, xmm0
          MAKE_FLOAT(rax, rsi)
             jmp .op_return
          .add_rat:
             DENOMINATOR rcx, rsi
	  DENOMINATOR rdx, rdi
	  NUMERATOR rsi, rsi
	  NUMERATOR rdi, rdi
          imul rsi, rdx
	 imul rdi, rcx
	 add rsi, rdi
	 imul rcx, rdx
          MAKE_RATIONAL(rax, rsi, rcx)
          .op_return:
         pop rbp
         ret

eq:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov dl, byte [rsi]
             cmp dl, T_FLOAT
	     jne .eq_rat
             FLOAT_VAL rsi, rsi
	 FLOAT_VAL rdi, rdi
	 cmp rsi, rdi
             jmp .op_return
          .eq_rat:
             NUMERATOR rcx, rsi
	 NUMERATOR rdx, rdi
	 cmp rcx, rdx
	 jne .false
	 DENOMINATOR rcx, rsi
	 DENOMINATOR rdx, rdi
	 cmp rcx, rdx
         .false:
          .op_return:
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

lt:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov dl, byte [rsi]
             cmp dl, T_FLOAT
	     jne .lt_rat
             FLOAT_VAL rsi, rsi
	 movq xmm0, rsi
	 FLOAT_VAL rdi, rdi
	 movq xmm1, rdi
	 ucomisd xmm0, xmm1
             jmp .op_return
          .lt_rat:
             DENOMINATOR rcx, rsi
	 DENOMINATOR rdx, rdi
	 NUMERATOR rsi, rsi
	 NUMERATOR rdi, rdi
	 imul rsi, rdx
	 imul rdi, rcx
	 cmp rsi, rdi
          .op_return:
      jl .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

string_length:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	STRING_LENGTH rsi, rsi
         MAKE_RATIONAL(rax, rsi, 1)
         pop rbp
         ret

string_ref:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	STRING_ELEMENTS rsi, rsi
         NUMERATOR rdi, rdi
         add rsi, rdi
         mov sil, byte [rsi]
         MAKE_CHAR(rax, sil)
         pop rbp
         ret

string_set:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	mov rdx, PVAR(2)
	STRING_ELEMENTS rsi, rsi
         NUMERATOR rdi, rdi
         add rsi, rdi
         CHAR_VAL rax, rdx
         mov byte [rsi], al
         mov rax, SOB_VOID_ADDRESS
         pop rbp
         ret

make_string:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	NUMERATOR rsi, rsi
         CHAR_VAL rdi, rdi
         and rdi, 255
         MAKE_STRING rax, rsi, dil
         pop rbp
         ret

symbol_to_string:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	SYMBOL_VAL rsi, rsi
	 STRING_LENGTH rcx, rsi
	 STRING_ELEMENTS rdi, rsi
	 push rcx
	 push rdi
	 mov dil, byte [rdi]
	 MAKE_CHAR(rax, dil)
	 push rax
	 MAKE_RATIONAL(rax, rcx, 1)
	 push rax
	 push 2
	 push SOB_NIL_ADDRESS
	 call make_string
	 add rsp, 4*8
	 STRING_ELEMENTS rsi, rax   
	 pop rdi
	 pop rcx
	 cmp rcx, 0
	 je .end
         .loop:
	 lea r8, [rdi+rcx]
	 lea r9, [rsi+rcx]
	 mov bl, byte [r8]
	 mov byte [r9], bl
	 loop .loop
         .end:
         pop rbp
         ret

eq?:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	cmp rsi, rdi
      je .true
       mov rax, SOB_FALSE_ADDRESS
       jmp .return
       .true:
       mov rax, SOB_TRUE_ADDRESS
       .return:
         pop rbp
         ret

char_to_integer:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	CHAR_VAL rsi, rsi
	 and rsi, 255
	 MAKE_RATIONAL(rax, rsi, 1)
         pop rbp
         ret

integer_to_char:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	NUMERATOR rsi, rsi
	 and rsi, 255
	 MAKE_CHAR(rax, sil)
         pop rbp
         ret

exact_to_inexact:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	DENOMINATOR rdi, rsi
	 NUMERATOR rsi, rsi 
	 cvtsi2sd xmm0, rsi
	 cvtsi2sd xmm1, rdi
	 divsd xmm0, xmm1
	 movq rsi, xmm0
	 MAKE_FLOAT(rax, rsi)
         pop rbp
         ret

numerator:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	NUMERATOR rsi, rsi
	 mov rdi, 1
	 MAKE_RATIONAL(rax, rsi, rdi)
         pop rbp
         ret

denominator:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	DENOMINATOR rsi, rsi
	 mov rdi, 1
	 MAKE_RATIONAL(rax, rsi, rdi)
         pop rbp
         ret

gcd:
       push rbp
       mov rbp, rsp 
       mov rsi, PVAR(0)
	mov rdi, PVAR(1)
	xor rdx, rdx
	 NUMERATOR rax, rsi
         NUMERATOR rdi, rdi
       .loop:
	 and rdi, rdi
	 jz .end_loop
	 xor rdx, rdx 
	 div rdi
	 mov rax, rdi
	 mov rdi, rdx
	 jmp .loop	
       .end_loop:
	 mov rdx, rax
         MAKE_RATIONAL(rax, rdx, 1)
         pop rbp
         ret


    cons:
      push rbp
      mov rbp, rsp
      mov rsi, PVAR(0)          ;rsi = car
      mov rdi, PVAR(1)          ;rdi = cdr
      MAKE_PAIR(rax, rsi, rdi)
      pop rbp
      ret
    
    apply:
      push rbp
      mov rbp, rsp
      mov rax, [rbp + 8 * 3]      ; rax = argc
      dec rax
      mov rax, PVAR(rax)          ; rax = last arg = list


      mov rdx, 0                  ; rdx = list_size
      
      push_args:
        cmp byte[rax], T_NIL
        je end_push_args
        CAR rbx, rax              ; rbx = car
        push rbx
        CDR rax, rax              ; rax = cdr
        inc rdx
        jmp push_args
      end_push_args:

      mov rsi,rdx                   ; rsi = list_size backup
      mov rcx, 0                    ; i = 0 
      mov rbx, rdx                  ; rbx = list_size
      shr rbx, 1                    ; rbx = list_size/2
      dec rdx                       ; rdx = list_size -1
      _revert_args:
        cmp rcx, rbx
        jae end_revert_args
        mov rax, [rsp + 8 * (rdx)]          ; rax = [rsp + 8*(list_size - i -1)]
        mov rdi,[rsp+8*rcx]               
        mov [rsp + 8 * rdx], rdi
        mov [rsp + 8 * rcx],  rax
        dec rdx
        inc rcx
        jmp _revert_args
      end_revert_args:

        mov rax, [rbp + 8 * 3]      ;rax = argc
        mov rdi, rax                ;rdi = index
        add rdi,2
        push_objs:
          cmp rdi, 4
          jbe end_push_objs
          push qword [rbp + 8 * rdi]
          inc rsi
          dec rdi
          jmp push_objs
        end_push_objs:
        push rsi                    ;push number of args
        mov rax, PVAR(0)            ; rax = closure of the procedure
        CLOSURE_ENV rbx, rax
        push rbx
        CLOSURE_CODE rbx, rax
        call rbx
        add rsp, 8 * 1
        pop rbx
        shl rbx, 3
        add rsp, rbx
      pop rbp
      ret

    car:
      push rbp
      mov rbp,rsp
      mov rdi,PVAR(0)           ; rdi = pair
      CAR rax,rdi
      pop rbp
      ret
    
      cdr:
        push rbp
        mov rbp, rsp
        mov rdi, PVAR(0)          ;rsi = pair
        CDR rax, rdi
        pop rbp
        ret

      set_car:
        push rbp
        mov rbp, rsp
        mov rdi, PVAR(0)          ;rdi = pair
        mov rsi, PVAR(1)          ;rsi = value
        mov [rdi + TYPE_SIZE], rsi
        pop rbp
        ret

      set_cdr:
        push rbp
        mov rbp, rsp
        mov rdi, PVAR(0)          ;rdi = pair
        mov rsi, PVAR(1)          ;rsi = value
        mov [rdi + WORD_SIZE +TYPE_SIZE], rsi
        pop rbp
        ret
    