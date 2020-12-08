COMMENT BEGIN	
    I'm level 2 test. Without pointer.
 COMMENT END

scope 9	8	int	j
scope 9	6	int	i
scope 9	4	int	j
scope 9	2	int	i
scope 9	0	int	len
scope 9	0	lose	k3
scope 9	0	lose	k2
scope 9	0	lose	k1
scope 9	0	Matrix	m3
scope 9	0	Matrix	m2
scope 9	0	Matrix	m1
0	program					child: 1 12 23 28
1	struct					child: 2 3 6 9 10 11
2	variable	Matrix			child:
3	statement	DECL		child: 4 5
4	type		INTEGER		child:
5	variable	id			child:
6	statement	DECL		child: 7 8
7	type		INTEGER		child:
8	variable	arr			child:
9	variable	m1			child:
10	variable	m2			child:
11	variable	m3			child:
12	struct					child: 13 14 17 20 21 22
13	variable	lose			child:
14	statement	DECL		child: 15 16
15	type		INTEGER		child:
16	variable	id			child:
17	statement	DECL		child: 18 19
18	type		INTEGER		child:
19	variable	arr			child:
20	variable	k1			child:
21	variable	k2			child:
22	variable	k3			child:
23	statement	DECL		child: 24 25
24	type		INTEGER		child:
25	assign					child: 26 27
26	variable	len			child:
27	constint	10			child:
28	function				child: 29 30 31 44 87
29	type		VOID		child:
30	variable	main			child:
31	statement	ASSIGN		child: 32 36 40
32	assign					child: 33 35
33	variable	m1			child: 34
34	variable	id			child:
35	constint	1			child:
36	assign					child: 37 39
37	variable	m2			child: 38
38	variable	id			child:
39	constint	2			child:
40	assign					child: 41 43
41	variable	m3			child: 42
42	variable	id			child:
43	constint	3			child:
44	statement	FOR			child: 45 56
45	FORargs					child: 46 51 54
46	statement	DECL		child: 47 48
47	type		INTEGER		child:
48	assign					child: 49 50
49	variable	i			child:
50	constint	0			child:
51	op			<			child: 52 53
52	variable	i			child:
53	variable	len			child:
54	assign					child: 55
55	variable	i			child:
56	statement	FOR			child: 57 68 73 78
57	FORargs					child: 58 63 66
58	statement	DECL		child: 59 60
59	type		INTEGER		child:
60	assign					child: 61 62
61	variable	j			child:
62	constint	0			child:
63	op			<			child: 64 65
64	variable	j			child:
65	variable	len			child:
66	assign					child: 67
67	variable	j			child:
68	statement	ASSIGN		child: 69
69	assign					child: 70 72
70	variable	m1			child: 71
71	variable	arr			child:
72	variable	i			child:
73	statement	ASSIGN		child: 74
74	assign					child: 75 77
75	variable	m2			child: 76
76	variable	arr			child:
77	variable	j			child:
78	statement	ASSIGN		child: 79
79	assign					child: 80 82
80	variable	m3			child: 81
81	variable	arr			child:
82	op			+			child: 83 85
83	variable	m1			child: 84
84	variable	arr			child:
85	variable	m2			child: 86
86	variable	arr			child:
87	statement	FOR			child: 88 99 119
88	FORargs					child: 89 94 97
89	statement	DECL		child: 90 91
90	type		INTEGER		child:
91	assign					child: 92 93
92	variable	i			child:
93	constint	0			child:
94	op			<			child: 95 96
95	variable	i			child:
96	variable	len			child:
97	assign					child: 98
98	variable	i			child:
99	statement	FOR			child: 100 111
100	FORargs					child: 101 106 109
101	statement	DECL		child: 102 103
102	type		INTEGER		child:
103	assign					child: 104 105
104	variable	j			child:
105	constint	0			child:
106	op			<			child: 107 108
107	variable	j			child:
108	variable	len			child:
109	assign					child: 110
110	variable	j			child:
111	statement	PRINTF		child: 112 113 115 116 117
112	conststr	<%d>[%d][%d] %d\t			child:
113	variable	m3			child: 114
114	variable	id			child:
115	variable	i			child:
116	variable	j			child:
117	variable	m3			child: 118
118	variable	arr			child:
119	statement	PRINTF		child: 120
120	conststr	\n			child:
