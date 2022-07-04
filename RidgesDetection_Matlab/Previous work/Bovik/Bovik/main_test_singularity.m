clear all
close all
pkg load image

I = imread('cercle_dilate.tif');
%I = imread('pieces.png');

nrScales = 5
preservePolarity = 0
min_scale = 1

[psi,orientation,NMS,scaleMap, polarity, pos_psi, posNMS, neg_psi, negNMS] = ...
    SingularityIndex2D(I,nrScales, preservePolarity, min_scale);