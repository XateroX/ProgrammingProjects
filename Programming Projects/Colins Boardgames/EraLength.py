import random
from matplotlib import pyplot as plt

maxInd    = 7

ageIndTrack      = []
healthIndTrack   = []
eraLengthTrack   = []
cardOfDeathTrack = []

testNumber = 0
maxTestNumber = 100000
while testNumber < maxTestNumber:
    cardList  = [[2,0],[1,0],[1,0],[1,1],[0,0],[1,1],[2,0],[0,1],[1,2]]

    ageInd    = 0
    healthInd = maxInd

    lengthOfEra    = 0
    eventCard      = -1
    eventCardInd   = -1

    ageIndTrack.append([])
    healthIndTrack.append([])
    cardOfDeathTrack.append([])
    while ageInd < healthInd and len(cardList)>0:
        lengthOfEra += 1
        nextEventInd = random.randint(0,len(cardList)-1)
        eventCard    = cardList.pop(nextEventInd)#cardList[nextEventInd]

        ageInd    += eventCard[0]
        healthInd -= eventCard[1]

        ageIndTrack[-1].append(ageInd)
        healthIndTrack[-1].append(healthInd)
    eraLengthTrack.append(lengthOfEra)
    cardOfDeathTrack.append(eventCardInd)

    testNumber += 1

eraLengthDict = {}
for eraLength in eraLengthTrack:
    if eraLength not in eraLengthDict.keys():
        eraLengthDict[eraLength] = 1
    else:
        eraLengthDict[eraLength] += 1

sortedKeys = sorted(list(eraLengthDict.keys()))
keyCounts  = [eraLengthDict[key] for key in sorted(list(eraLengthDict.keys()))]

plt.bar(sortedKeys,keyCounts)
plt.xlabel('Number of rounds before death')
plt.ylabel('Number of games out of ' +str(maxTestNumber))
plt.show()



