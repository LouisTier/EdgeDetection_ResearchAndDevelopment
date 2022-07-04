# -*- coding: utf-8 -*-
"""
Created on Sat Apr 16 15:16:38 2022

@author: Adrien
"""

import tensorflow as tf
import numpy as np
import scipy
from scipy import ndimage
import matplotlib.pyplot as plt
from PIL import Image

im = Image.open('eye.jpg')


im = np.asarray(im)
#im = im[:,:]   #commenter si image en RGB
im = im[:,:,0] #commenter si image en niveau de gris


#Test

# a = 30
# b = 200
# for x in range(im.shape[0]):
#     for y in range(im.shape[1]):
#         if(im[x,y]<a):
#             im[x,y] = 0
#         elif (im[x,y]>b):
#             im[x,y]=255
#         else:
#             im[x,y]=255*(im[x,y]-a)/(b-a)
            
   
        
#Fonction de réhaussement de contraste

a = 0
b = 5
for x in range(im.shape[0]):
    for y in range(im.shape[1]):
        if(im[x,y]<a):
            im[x,y] = b/a*im[x,y]
        elif (im[x,y]>a):
            im[x,y]=((255-b)*im[x,y]+255*(b-a))/(255-a)
    


#im = ndimage.gaussian_filter(im, 1)
im = np.dstack([im]*3)

img = Image.fromarray((im).astype(np.uint8))
      
    # saving the final output 
    # as a PNG file
img.save('eye_lissage_laplace_1_RN_contraste.png')

plt.imshow(im)
#plt.savefig('testLaplace.png',dpi = 300)