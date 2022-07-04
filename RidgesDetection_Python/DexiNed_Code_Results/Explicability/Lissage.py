# -*- coding: utf-8 -*-
"""
Created on Sat Apr 16 14:05:42 2022

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

#On applique le filtre gaussien a l'image, avec en parametre la valeur de sigma
traitement = ndimage.gaussian_filter(im, 1)

#On creer une image de la librairie PIL
img = Image.fromarray(traitement)
      
#On sauvegarde l'image finale
img.save('eye_lissage_1.png')

plt.imshow(img)
