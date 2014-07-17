function samples = readStringStruct(filePath, N)

% Image filepath
if(~exist('filePath','var'))
    filePath = '/Users/Fariz/Documents/Kurser/ECP/directedStudies/fgvcData/data/images/';
end
files = dir(fullfile(filePath, '*.jpg'));

if ~exist('N', 'var')
    N = length(files);
end

samples = {files.name};
samples = samples(1:N);