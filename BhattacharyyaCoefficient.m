function [b,d] = BhattacharyyaCoefficient(U1,S1,U2,S2)
% implements Bhattacharyya's affinity between two zero mean Gaussian
% distributions with covariance matrices C1=U1*S1*U1' and C2=U2*S2*U2'
%
% also optionally computes d= ||C1-C2||

d=Inf;
ind1 = find(diag(S1)~=0);
if(length(ind1)~=size(S1,1))
    U1 = U1(:,ind1);
    S1 = S1(ind1,ind1);
end
ind2 = find(diag(S2)~=0);
if(length(ind2)~=size(S2,1))
    U2 = U2(:,ind2);
    S2 = S2(ind2,ind2);
end

if(size(U2,2)<size(U1,2))
    b=0;
    return
end

D = size(U1,2);
U2t=U1'*U2;

b = (0.5^(-D/2)) * (prod(diag(S1)).^-0.25) * (det(U2t*S2*U2t').^-0.25) ...
    * (det(inv(diag(1./diag(S1))+inv(U2t*S2*U2t')))^.5);

if(nargout>1)
    d = sum(diag(S1).^2)+sum(diag(S2).^2) - 2*trace(U2t*S2*U2t'*S1);
end
end