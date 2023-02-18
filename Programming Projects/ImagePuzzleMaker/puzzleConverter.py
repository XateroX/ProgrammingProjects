import numpy as np  
import pandas
import os
import math
import random
from matplotlib import image as img
import matplotlib.pyplot as plt
from PIL import Image

import scipy
from scipy import ndimage

import sys

gridSize = int(sys.argv[2])

image = img.imread( sys.argv[1] )

img.imsave("loaded-image-pre-crop.png", image)

if len(image) != len(image[0]):
    smaller = min( len(image), len(image[0]) )
    image = image[:smaller, :smaller, :3]

img.imsave("loaded-image-post-crop.png", image)


image = ndimage.zoom(image, (gridSize/len(image), gridSize/len(image), 1))

for x in range(len(image)):
    for y in range(len(image[0])):
        for rgbind in range(len(image[0][0])):
            if image[x][y][rgbind] > 1.0:
                image[x][y][rgbind] = 1.0
            if image[x][y][rgbind] < 0.0:
                image[x][y][rgbind] = 0.0

img.imsave("loaded-image-post-zoom.png", image)

avg = 0
n = 0
for x in range(len(image)):
    for y in range(len(image[0])):
        total = image[x][y][0] + image[x][y][1] + image[x][y][2]
        if (total < 1.0*3 * 0.99):
            avg  += total
            n    += 1
        #if (total > (1.0*3)/2):
        #    image[x][y] = [1.0, 1.0, 1.0]
        #    #print("1")
        #else:
        #    image[x][y] = [0.0, 0.0, 0.0]
        #    #print("0")
        #image[x][y] = total/(255*3)
avg /= n


for x in range(len(image)):
    for y in range(len(image[0])):
        total = image[x][y][0] + image[x][y][1] + image[x][y][2]
        #avg  += total
        #n    += 1
        if (total > avg):
            image[x][y] = [1.0, 1.0, 1.0]
            #print("1")
        else:
            image[x][y] = [0.0, 0.0, 0.0]
            #print("0")

img.imsave("loaded-image-post-bandw.png", image)


def adjSum(arr, ind):
    total = 0
    for [x,y] in [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1],[0,0]]:
        #print(" ")
        #print(arr[x][y])
        #print(arr[ind[0]+x][ind[1]+y])
        #print(" ")
        if arr[ind[0]+x][ind[1]+y][0] == 0.0:
            total+=1
    return total

imagePips = []
for x in range(1,len(image)-1):
    imagePips.append([])
    for y in range(1,len(image[0])-1):
        imagePips[-1].append([])
        total_pips = adjSum(image,[x,y])
        imagePips[-1][-1].append(total_pips)

img.imsave("loaded-image-post-pipCount.png", imagePips)

fig, ax = plt.subplots()

for x in range(len(imagePips)):
    for y in range(len(imagePips[0])):
        imagePips[x][y] = imagePips[x][y][0]
#print(imagePips)

blankData = []
for x in range(len(imagePips)):
    blankData.append([])
    for y in range(len(imagePips[0])):
        blankData[-1].append([])
        blankData[-1][-1].append(1.0)
ax.matshow(blankData, cmap='Greys')
for (i, j), z in np.ndenumerate(imagePips):
    ax.text(j, i, '{:1d}'.format(z), ha='center', va='center', fontsize=3)

plt.savefig("pipGrid.pdf")


