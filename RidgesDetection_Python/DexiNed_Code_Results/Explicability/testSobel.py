# -*- coding: utf-8 -*-
"""
Created on Fri Apr 15 09:28:10 2022

@author: Adrien
"""

import tensorflow as tf
import numpy as np
import scipy
from scipy import ndimage
import matplotlib.pyplot as plt
from PIL import Image


im = Image.open('eye.png')

dx = ndimage.sobel(im, 0)  # horizontal derivative
dy = ndimage.sobel(im, 1)  # vertical derivative
mag = np.hypot(dx, dy)  # magnitude
#mag *= 255.0 / np.max(mag)  # normalize (Q&D)

mag = mag.astype(int)
plt.imshow(mag)
plt.savefig('testSobel.png',dpi = 300)

#tf.keras.preprocessing.image.save_img('test.png',mag)