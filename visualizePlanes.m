function h = visualizePlanes(N)

load('imgDataMeanSize.mat');
samples = readStringStruct();
randomIndeces = randperm(N);
samples = {samples{randomIndeces}};
meanSize = round(meanSize./10);
U = zeros(prod([meanSize 3]), N);

for i = 1:N
    U(:, i) = readSample(samples{i}, meanSize);
end

displayData(U', meanSize);
title('')