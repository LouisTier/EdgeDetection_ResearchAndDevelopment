function [imnorm] = f_normalisation (imskin)

%imnorm=(imskin-min(imskin(:)))/(max(imskin(:))-min(imskin(:)));
imnorm = (imskin - min(min(imskin)))./(max(max(imskin)) - min(min(imskin)));

