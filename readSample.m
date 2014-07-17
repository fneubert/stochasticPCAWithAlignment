function x = readSample(sample, meanSize,filePath)

% Image filepath
%filePath = '/Users/Fariz/Documents/Kurser/ECP/directedStudies/fgvcData/data/images/';

% Read, resize and vectorize image sample
fileDir = strcat(filePath, sample);
img = imread(fileDir, 'jpg');

% Resize images to mean size
imgResize = imresize(img, meanSize, 'nearest');
croppedImgSize = cropImage(meanSize);

% Turn into (double type) row vector
x = double(imgResize);
% x = x(1:end - floor(meanSize(1)/73) - 1*(1 > floor(meanSize(1)/73)), :, :);
x = x(1:croppedImgSize(1), :, :);
x = x(:);
%x = normalizeData(x);
