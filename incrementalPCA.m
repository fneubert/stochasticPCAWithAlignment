function [U, S] = incrementalPCA(samples, d, k, meanSize)

% Initialize the algorithm
U = zeros(d, 1);
S = zeros(1);
N = length(samples);
opts.issym = 1;
% Do this for each sample

for t = 1:N
	fprintf('Iteration %3d: \n',t);
    xt = readSample(samples{t}, meanSize);
    %%% ALIGN IMAGE

    xhat = U'*xt;
    xperp = xt - U*U'*xt;
    xperp_norm = norm(xperp);
    l = size(S, 1) + 1;
    [Up, S] = eigs(@(x) multFunct(x, S, xhat, xperp_norm), l, min(k + 1, l), 'LM', opts);
	size(Up)
    U = [U xperp./xperp_norm]*Up;

end

U = U(:, 1:end - 1);
S = S(1:end - 1, 1:end - 1);

end

function Ax = multFunct(x, S, xhat, xperp_norm)

Ax = [diag(S).*x(1:end - 1) + xhat*(xhat'*x(1:end - 1)) + (xperp_norm*x(end)).*xhat;...
      xperp_norm.*xhat'*x(1:end - 1) + xperp_norm*xperp_norm*x(end)];
end