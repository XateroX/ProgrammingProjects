def amtOfHealth(power, armour):
    n = len(power)
    sum = 0
    bigest = 0
    for i in range(n):
        bigest = max(bigest, power[i])
        sum   += power[i]
    
    return sum - min(armour,bigest) + 1

print(amtOfHealth([1,2,6,7],5))
print(amtOfHealth([1,2,3],5))
print(amtOfHealth([2],2))
print(amtOfHealth([2,0,0,0],2))