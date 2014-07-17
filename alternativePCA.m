function [U, S, D] = alternativePCA(samples, k, meanSize, filepath, parm)

N = length(samples);
D = zeros(round(N/10), 1);
croppedImgSize = cropImage(meanSize);
d = prod([croppedImgSize 3]);
opts.issym = 1;

[U, S] = eigs(@(a) multFunct1(a, samples, meanSize, filepath), d, k, 'LM', opts);
Uold = U;
Sold = S;
j = 1;

for iter = 1:N
	fprintf([datestr(now) ' Iteration %3d: \n'], iter);
    [U, S] = eigs(@(a) multFunct2(a, samples, meanSize, filepath, U, S, k, parm), d, k, 'LM', opts);
    
    if mod(iter, 10) == 0
        D(j) = frobeniusNorm(U, S/(iter), Uold, Sold);
        j = j + 1;
        Uold = U;
        Sold = S/(iter);
    end
end

end

function C = multFunct1(a, samples, meanSize, filepath)

croppedImgSize = cropImage(meanSize);
C = zeros(prod([croppedImgSize 3]), 1);
for iter = 1:length(samples)
    % fprintf([datestr(now) ' Iteration %3d: \n'], iter);
    x = readSample(samples{iter}, meanSize, filepath);
    C = C + x*(x'*a);
end

C = C./length(samples);

end

function C = multFunct2(a, samples, meanSize, filepath, U, S, k, parm)

croppedImgSize = cropImage(meanSize);
C = zeros(prod([croppedImgSize 3]), 1);
for iter = 1:length(samples)
    % fprintf([datestr(now) ' Iteration %3d: \n'], iter);
    x = readSample(samples{iter}, meanSize, filepath);
    x = alignImage(x, U, S, meanSize, k, parm);
    C = C + x*(x'*a);
end

C = C./length(samples);

end

function d = frobeniusNorm(U1, S1, U2, S2)

d = norm(U1*S1*U1' - U2*S2*U2','fro');

end