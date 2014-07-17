function [U, S, D] = incrementalPCA2(samples, k, meanSize, alignmentIO,filepath,parm)
%INCREMENTALPCA Performs simultaneous alignment and PCA. 
%   [U, S] = INCREMENTALPCA(samples, d, k, meanSize) returns the eigen-
%   decomposition of the dataset stored in the samples string array.

% Initialize the algorithm
meanImgSize = meanSize;
meanSize(1) = meanSize(1) - floor(meanSize(1)/73);
d = prod([meanSize 3]);
U = zeros(d, k + 1);
S = zeros(k + 1);
N = length(samples);
opts.issym = 1;
D = zeros(round(N/10), 1);
Uold = U;
Sold = S;
j = 1;

% Do this for each sample

for t = 1:N
	fprintf([datestr(now) ' Iteration %3d: \n'],t);
    xt = readSample(samples{t}, meanImgSize,filepath);
    % Do alignment: IO
    if t > 5 && alignmentIO
        xt = alignImage(xt, U, S, meanSize, k,parm);
    end
    % Determine what part of U and S to decompose
    l = min(k, t);
    St = S(1:l, 1:l);
    xhat = U(:,1:l)'*xt;
    xperp = xt - U(:,1:l)*xhat;
    xperp_norm = norm(xperp);
    % Eigendecomposition of Q
    [Up, Sp] = eigs(@(x) multFunct(x, St, xhat, xperp_norm), l + 2, l + 1, 'LM', opts);
    % Update U and S matrices
    S(1:l + 1, 1:l + 1) = Sp;
    U(:, l + 1) = xperp./xperp_norm;
    U(:, 1:l + 1) = U(:, 1:l + 1)*Up(1:l + 1, :);
    % Compute convergence measures
    if mod(t, 10) == 0
        D(j) = frobeniusNorm(U(:, 1:l + 1), S(1:l + 1, 1:l + 1)/(t), Uold, Sold);
        j = j + 1;
        Uold = U(:, 1:l + 1);
        Sold = S(1:l + 1, 1:l + 1)/(t);
    end
end

U = U(:, 1:end - 1);
S = S(1:end - 1, 1:end - 1);

end

function d = frobeniusNorm(U1, S1, U2, S2)

  d = norm(U1*S1*U1' - U2*S2*U2','fro');
return

ind1 = find(diag(S1) ~= 0);
if length(ind1) ~= size(S1, 1)
    U1 = U1(:, ind1);
    S1 = S1(ind1, ind1);
end
ind2 = find(diag(S2) ~= 0);
if length(ind2) ~= size(S2, 1)
    U2 = U2(:, ind2);
    S2 = S2(ind2, ind2);
end

if size(U2, 2) < size(U1, 2)
    d = inf;
    return
end
U2t=U1'*U2;
d = sum(diag(S1).^2)+sum(diag(S2).^2) - 2*trace(U2t*S2*U2t'*S1);
end

function Ax = multFunct(x, S, xhat, xperp_norm)
% Function to speed up the eigendecomposition
Ax = [diag(S).*x(1:end - 2) + xhat*(xhat'*x(1:end - 2)) + (xperp_norm*x(end - 1)).*xhat;...
      xperp_norm.*xhat'*x(1:end - 2) + xperp_norm*xperp_norm*x(end - 1); 0*x(end)];
end
