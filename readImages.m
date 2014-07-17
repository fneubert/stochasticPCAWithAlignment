function X = readImages(N)

% Image filepath
filePath = '/Users/Fariz/Documents/Kurser/ECP/directedStudies/fgvcData/data/images/';
files = dir(fullfile(filePath, '*.jpg'));

if ~exist('N','var')
    N = length(files);
end

meanSize = [275 187];

X = zeros(N, prod(meanSize)*3);

% Read in each image
for i = 1:N
    fileDir = strcat(filePath, files(i).name);
    img = imread(fileDir, 'jpg');
    % Resize images to mean size
    imgResize = imresize(img, meanSize,'nearest');
    % Turn into row vector
    x = double(imgResize(:)');
    X(i, :) = x;
end