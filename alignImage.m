function xt = alignImage(xt, U, S, meanSize, K, parm)
% Determines whether the flipped or non-flipped image received the
% highest scores and returns the one with the highest
meanSize = cropImage(meanSize);
[xt1,score1] = translateImage(xt, U, S, meanSize, K,parm);
score2 = -Inf;
if parm.lrflip
    [xt,score2] = translateImage(flipImage(xt,meanSize), U, S, meanSize, K,parm);
end

if(score1>score2)
    xt = xt1;
end
end

function xt = flipImage(xt, meanSize)
% Flips images from left to right
xt = reshape(xt, [meanSize 3]);
for i=1:3
    xt(:,:,i) = fliplr(xt(:,:,i));
end
end

    
function [xt, score] = translateImage(xt, U, S, meanSize, K, parm)
% Calculates the projections of all allowed translations of image
% xt onto the current eigenspace spanned by the columns of U

m = meanSize(1); n = meanSize(2);
X = reshape(xt, [meanSize 3]);
C = 0; %zeros(2*m - 1, 2*n - 1);

ypad = round(m/2);
xpad = round(n/2);

for i = 1:K
    if(S(i,i)>0)
        Ui = reshape(U(:, i), [meanSize 3]);
        for j = 1:3
            Xj = X(:, :, j);
            Uij = Ui(:, :, j);
            %C = C + (xcorr2(Xj, Uij).^2).*S(i, i);
            C = C + (1/S(i,i)).*(xcorr2(Xj, padarray(Uij,[ypad,xpad],'circular')).^2);
        end
    end
end

% probability distribution is propto exp -sqrt(C) 
C = -C(ypad+1:end-ypad,xpad+1:end-xpad);

if ~parm.translatevert
    C(:,[1:n-1,n+1:end])=-Inf;
end

if ~parm.translatehoriz
    C([1:m-1,m+1:end],:) = -Inf;
end

score = max(C(:));

[k, l] = find(C == max(C(:)));

k = k(1) - m;
l = l(1) - n;

xt = zeros(m,n,3);

% shift by k

if(k>0)
  xt = [X(end-k+1:end,:,:);X(1:end-k,:,:)];
 else
   xt = [X(1-k:end,:,:);X(1:-k,:,:)];
end

if(l>0)
  xt = [xt(:,end-l+1:end,:),xt(:,1:end-l,:)];
 else
   xt = [xt(:,1-l:end,:),xt(:,1:-l,:)];
end


%xt(max(1, k+1):min(m, m+k),max(1, l+1):min(n, n+l),:) = ...
%    X(max(1, 1-k):min(m, m-k),max(1, 1-l):min(n, n-l),:); % A
%xt(max(1, m+k):min(m,-k),max(1, n+l):min(n,l),:) = ...
%    X(max(1,m+k):min(m,-k),max(1,n-l):min(n,l),:); % D
%xt(max(1, k+1):min(m, m+k),max(1, 1-l):min(n, n-l),:) = ...
%    X(max(1, 1-k):min(m, m-k),max(1, 1+l):min(n, n+l),:);
%xt(max(1, 1-k):min(m, m-k),max(1, l+1):min(n, n+l),:) = ...
%    X(max(1, 1-k):min(m, m-k),max(1, 1-l):min(n, n-l),:);

xt = xt(:);

end
