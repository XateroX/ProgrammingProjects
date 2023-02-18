import math

def bestMonth(prices):
    sum = 0
    n   = len(prices)
    for i in range(n):
        sum += prices[i]
    
    leftSum      =  0
    bestMonthInd = -1
    bestDiff     = float("inf")
    for i in range(n):
        
        leftSum += prices[i]
        leftAvg  = math.floor(leftSum/(i+1))
        rightAvg = math.floor((sum-leftSum)/max((n-(i+1)),1))

        diff = abs(leftAvg-rightAvg)
        #print("month", i, ":  ", leftAvg, " ", rightAvg, " ", diff)

        if diff < bestDiff:
            bestDiff     = diff
            bestMonthInd = i
    return (bestMonthInd + 1)

print(bestMonth([1,3,2,3]))
print(bestMonth([1,3,2,4,5]))
print(bestMonth([2,1,1]))
print(bestMonth([5,1]))
        

