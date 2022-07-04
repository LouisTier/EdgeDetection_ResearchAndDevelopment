# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 12:07:44 2022

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
img = im
im = im.astype(int)
#im = im[:,:]   #commenter si image en RGB
im = im[:,:,0] #commenter si image en niveau de gris




#Normalisation de l'image
im = (im-im.min()) /(im.max()-im.min())

#On applique le laplacien a l'image
laplacian1 = ndimage.laplace(im)

#Normalisation du resultat
laplacian1 = (laplacian1-laplacian1.min()) /(laplacian1.max()-laplacian1.min())

#On vient augmenter le contraste de l'image
im  = (im  - 0.05*laplacian1)


#On reconstitue l'image en niveau de gris
im = np.dstack([im*255]*3)


#On creer une image de la librairie PIL
img = Image.fromarray((im).astype(np.uint8))
      
#On sauvegarde l'image finale
img.save('eye.png')

#Affichage de l'image
plt.imshow(img)
