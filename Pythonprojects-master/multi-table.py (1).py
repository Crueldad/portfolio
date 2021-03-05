multi_table = []
for i in range(0,13):
    a = []
    for j in range(0,13):
        c = i*j
        a.append(c)
    multi_table.append(a)
for i in range(0,13):
    multi_table[0][i]= i
for j in range(0,13):
    multi_table[j][0]= j
multi_table[0][0]= "X"
for row in range (0,13):
    for col in range (0,13):
        print(str(multi_table[row][col]), end=' ')
    print('\n')


        
        



