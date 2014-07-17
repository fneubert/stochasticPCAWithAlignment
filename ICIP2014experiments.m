function [U, S, D] = ICIP2014experiments(expno,filepath)
%% Test client for Stochastic PCA on FCVG Data

if(~exist('filepath','var'))
  filepath = '/home/blaschko/work/OID/FGVC-Aircraft/fgvc-aircraft-2013b/data/images/';
end

if(~exist('expno','var'))
  expno = 1;
end

switch(expno)
    case 1
        parm.translatevert = false;
        parm.translatehoriz = false;
        parm.lrflip = false;
    case 2
        parm.translatevert = false;
        parm.translatehoriz = false;
        parm.lrflip = true;
    case 3
        parm.translatevert = false;
        parm.translatehoriz = true;
        parm.lrflip = false;
    case 4
        parm.translatevert = false;
        parm.translatehoriz = true;
        parm.lrflip = true;
    case 5
        parm.translatevert = true;
        parm.translatehoriz = false;
        parm.lrflip = false;
    case 6
        parm.translatevert = true;
        parm.translatehoriz = false;
        parm.lrflip = true;
    case 7
        parm.translatevert = true;
        parm.translatehoriz = true;
        parm.lrflip = false;
    case 8
        parm.translatevert = true;
        parm.translatehoriz = true;
        parm.lrflip = true;
end

% Load data mean size
load('imgDataMeanSize.mat');

% Load n sample names in to string array
samples = readStringStruct(filepath);

% Set dimensionality parameters
c = 10;
meanSize = round(meanSize./c);
%d = prod([meanSize 3]);
k = 60;

% Perform sPCA
alignmentIO = 1; % With/without alignment
[U, S, D] = incrementalPCA2(samples, k, meanSize, alignmentIO, filepath, parm);

% Visualize the top K eigenvectors found
% meanSize(1) = meanSize(1) - floor(meanSize(1)/73);
% displayData(U', meanSize);

end
