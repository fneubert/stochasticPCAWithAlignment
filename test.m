function [U, S, D] = test()
%% Test client for Stochastic PCA on FCVG Data

% Load data mean size
load('imgDataMeanSize.mat');

% Load n sample names in to string array
filePath = '/Users/Fariz/Documents/Kurser/ECP/directedStudies/fgvcData/data/images/';
samples = readStringStruct(filePath, 100);

% Set dimensionality parameters
c = 100;
meanSize = round(meanSize./c);
d = prod([cropImage(meanSize) 3]);
k = d;

parm.translatevert = true;
parm.translatehoriz = true;
parm.lrflip = true;

% Perform sPCA
[U, S, D] = alternativePCA(samples, k, meanSize, filePath, parm);
% [U, S, D] = incrementalPCA2(samples, k, meanSize,
% alignmentIO,filepath,parm);

% Visualize the top K eigenvectors found
displayData(U', c);

end