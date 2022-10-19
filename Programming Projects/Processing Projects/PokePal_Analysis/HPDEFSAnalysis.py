import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import math
import heapq

file = open("C:/Users/danlo/OneDrive/Desktop/Programming Projects/Processing Projects/PokePal_Analysis/hp_defs_spdefs.txt", "r")
hps    = []
defs   = []
spdefs = []

file_contents = file.readlines()

for val in file_contents:
    if val.split('[')[0] == "hp":
        hps.append(int(val.split('[')[1].split(']')[0]))
    if val.split('[')[0] == "defs":
        defs.append(int(val.split('[')[1].split(']')[0]))
    if val.split('[')[0] == "spdefs":
        spdefs.append(int(val.split('[')[1].split(']')[0]))

print(len(hps))
print(len(defs))
print(len(spdefs))

#print("Example1: ", defs[24], hps[24])
#print("Example2: ", defs[200], hps[200])
#print("Example3: ", defs[2], hps[2])
#print("Example4: ", defs[12], hps[12])
#print("Example5: ", defs[600], hps[600])
hps,defs, spdefs = zip(*sorted(zip(hps,defs, spdefs)))
#print("Example1: ", defs[24], hps[24])
#print("Example2: ", defs[200], hps[200])
#print("Example3: ", defs[2], hps[2])
#print("Example4: ", defs[12], hps[12])
#print("Example5: ", defs[600], hps[600])


mat_defs = []
for i in range(len(defs)):
    def_val = defs[i]
    mat_defs.append([])
    for j in range(len(defs)):
        def_val_2 = defs[j]
        #mat_defs[-1].append( (hps[j]*0.6666+hps[i]*0.3333)/(def_val_2*0.3333+def_val*0.6666) )
        #mat_defs[-1].append( (hps[j]*0.6666+hps[i]*0.3333) + (def_val_2*0.3333+def_val*0.6666) + (spdefs[j]*0.3333+spdefs[i]*0.6666) )
        mat_defs[-1].append( (hps[j]*0.6666+hps[i]*0.3333)*(def_val_2*0.3333+def_val*0.6666) )

sns.heatmap(mat_defs)
plt.savefig("C:/Users/danlo/OneDrive/Desktop/Programming Projects/Processing Projects/PokePal_Analysis/hptimedef.png")
plt.close()

n = 100

def find_biggest_n(n):
    best_n      = []
    best_n_inds = []

    whole_array = []
    whole_array_inds = []

    for x in range(len(mat_defs)):
        for y in range(len(mat_defs)):
            val = mat_defs[x][y]

            whole_array.append(val)
            whole_array_inds.append([x,y])
    
    whole_array, whole_array_inds = zip(*sorted(zip(whole_array, whole_array_inds)))

    return whole_array[-n:], whole_array_inds[-n:]

biggest = find_biggest_n(n)
biggest_n, biggest_n_inds = biggest[0], biggest[1]
#print(biggest_n)

plt.plot(biggest_n)
plt.savefig("C:/Users/danlo/OneDrive/Desktop/Programming Projects/Processing Projects/PokePal_Analysis/biggest_bois_spdefs.png")
plt.close()


file_of_best = open("C:/Users/danlo/OneDrive/Desktop/Programming Projects/Processing Projects/PokePal_Analysis/best_inds_defs.txt", 'w')
for ind_pair in biggest_n_inds:
    file_of_best.write(str(ind_pair[0]) + " " + str(ind_pair[1]) + "\n")
file_of_best.close()