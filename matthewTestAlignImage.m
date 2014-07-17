
X = [1:5]'*[1:4];
k = 0;
l = 0;




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
