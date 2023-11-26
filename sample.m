% minimize lab
Ab = [-1  -1   1   1   0   0   0   0   100   100   100   100   0 ;
       0   1  -2   1   1   0   0   0     0     0     0     0  11 ;
       0  -2   0   1   0   0   0   0     1     0     0     0   1 ;
       0   1   0   0   0  -1   0   0     0     1     0     0   0 ;
       0   0   1   0   0   0  -1   0     0     0     1     0   0 ;
       0   0   0   1   0   0   0  -1     0     0     0     1   0 ]
maximize(Ab, 3)

% brilliant
z = [1; 0; 0]
choice = [-7 -5; 2 3; 3 2]
slack = [0 0; 1 0; 0 1]
b = [0; 90; 120]
Ab = [z choice slack b]
maximize(Ab, 2) % solution should be 282 (36, 6)

% brilliant
Ab = [ -1      1    -10      0      0      0   1000      0 ;
        0     -1      5      1      0      0      0     25 ;
        0      6      5      0      1      0      0     60 ;
        0      1      1      0      0     -1      1      2 ]

maximize(Ab, 2) % solution should be [-55 5 6 0 0 9 0 0]'

% brilliant
z = [-1; 0; 0; 0; 0]
choice = [12 9 12; 1 0 1; 0 1 0; 0 0 1; 5 4 -10]
slack = [0 0 0; 1 0 0; 0 1 0; 0 0 -1; 0 0 0]
artificial = [1000 1000; 0 0; 0 0; 1 0; 0 1]
b = [0; 40; 40; 20; 0]
Ab = [z choice slack artificial b]
maximize(Ab, 3) % should be [696 8 40 20 12 0 0 0 0 0 ]

% hillier
z = [1; 0; 0; 0]
choice = [-3 -5 0 0 0; 1 0 1 0 0; 0 2 0 1 0; 3 2 0 0 1]
slack = []
artificial = []
b = [0; 4; 12; 18]
Ab = [z choice slack artificial b]
maximize(Ab, 2) % should be sol=36 x1=2, x2=6, x3=2

% hillier
z = [1; 0; 0; 0]
choice = [-3 -5; 1 0; 0 2; 3 2]
slack = [0 0; 1 0; 0 1; 0 0]
artificial = [1000; 0; 0; 1]
b = [0; 4; 12; 18]
Ab = [z choice slack artificial b]
maximize(Ab, 2)

% hillier p123
z = [-1; 0; 0; 0]
choice = [0.4 0.5; 0.3 0.1; 0.5 0.5; 0.6 0.4]
slack = [0 0; 1 0; 0 0; 0 -1]
artificial = [1000 1000; 0 0; 1 0; 0 1]
b = [0; 2.7; 6; 6]
Ab = [z choice slack artificial b]
maximize(Ab, 2)
