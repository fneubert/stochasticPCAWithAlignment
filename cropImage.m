function croppedSize = cropImage(meanSize)

croppedSize = [meanSize(1) - floor(meanSize(1)/73) - 1*(1 > floor(meanSize(1)/73)) meanSize(2)];