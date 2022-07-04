# -*- coding: utf-8 -*-
"""
Created on Fri Apr 29 21:58:55 2022

@author: Adrien
"""

import torch
import torch.nn as nn
import torchvision
from torchvision import models, transforms, utils
from torch.autograd import Variable
import numpy as np
import matplotlib.pyplot as plt
import scipy.misc
from PIL import Image
import json
import cv2

#import du modele Dexined
from model import DexiNed


#On definit la partie hardware qui va effectuer les calculs 
#i.e GPU (NVIDIA) si configuré avec Cuda sinon CPU
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

#Initialisation du model Dexined
model = DexiNed()

#On affecte les paramètres déjà entrainés à notre model (téléchargés sur le GitHub de Dexined)
model.load_state_dict(torch.load('test.pt',
                                 map_location=device))


#On charge le model et ses paramètres dans le CPU/GPU 
model = model.to(device)


#On prépare un opérateur qui va nous permettre de pouvoir transformer notre
#image sous forme de tenseur pour pouvoir faire des opérations de Pytorch dessus    
transform = transforms.Compose([
    transforms.Resize((512, 512)),
    transforms.ToTensor(),
    transforms.Normalize(mean=0., std=1.)
])

#On vient définir le chemin de l'image pour pouvoir l'instancier en tant que variable
path = r'data\eye.jpg'
image = Image.open(path)
#plt.imshow(image)

#On transforme notre image en tenseur Pytorch grâce à l'opérateur que nous avons défini plus haut
image = transform(image)

#affichage des dimensions de l'image (après avoir y avoir appliqué l'opérateur "transform")
print(f"Dimensions de l'image avant traitement': {image.shape}")

#On rajoute une dimension, celle du batch, car le réseau de neurone attend une dimension en plus
image = image.unsqueeze(0)
print(f"Dimensions de l'image (indispensable pour pouvoir la rentrer dans le réseau': {image.shape}")


#Charge l'image sur le CPU ou GPU
image = image.to(device)

#On va chercher toutes les résultats de chacun des 6 blocs
#Le dernier élément de la liste étant la fusion de ces 6 blocs
outputs_blocks = model.forward(image)

#Liste qui va convertir les résultats des blocs en image afin de pouvoir les afficher correctement
resultat_blocs = []

#On vient redimensionner tous les résultats des blocs du réseau en matrice "classique"
for feature_map in outputs_blocks:
    feature_map = feature_map.detach()
    feature_map = feature_map.squeeze(0)
    gray_scale = torch.sum(feature_map,0)
    gray_scale = gray_scale / feature_map.shape[0]
    
    
    resultat_blocs.append(gray_scale.data.cpu().numpy())

#On affiche la dimension
for fm in resultat_blocs:
    print(fm.shape)

#On vient afficher les sorties des blocs dans un subplot
fig = plt.figure(figsize=(30, 50))
for i in range(len(resultat_blocs)):
    a = fig.add_subplot(5, 4, i+1)
    imgplot = plt.imshow(resultat_blocs[i])
    a.axis("off")
    if i+1<7:
        a.set_title("Bloc "+str(i+1), fontsize=30)
    else:
        a.set_title("Fusion des 6 blocs", fontsize=30)
plt.savefig(str('feature_maps_par_bloc.jpg'), bbox_inches='tight')
