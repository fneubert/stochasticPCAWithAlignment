function mu = getSampleMean(samples, meanSize)

N = length(samples);
d = prod([meanSize 3]);
mu = zeros(d, 1);

for i = 1:N
    fprintf('Iteration %4d: \n', i);
    xi = readSample(samples{i}, meanSize);
    mu = mu + xi;
end

mu = 1/N.*mu;