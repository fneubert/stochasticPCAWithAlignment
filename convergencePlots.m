
load('ICIPexp1.mat'); D1 = D; S1 = S; U1 = U;
load('ICIPexp8.mat'); D8 = D; S8 = S; U8 = U;

normC1 = norm(U1*(S1./10000)*U1', 'fro');
normC8 = norm(U8*(S8./10000)*U8', 'fro');

trC1 = sum(diag(S1))/10000;
trC8 = sum(diag(S8))/10000;

loglog(1:10:10000, D1, 'r');
hold on
loglog(1:10:10000, D8, 'b');

legend('without alignment','with alignment')

xlabel('number of images')

ylabel('Delta')

figure();
loglog(diag(S1)./10000,'r');
hold on
loglog(diag(S8)./10000,'b');
legend(sprintf('without alignment - Tr[C] = %6.2e',trC1),sprintf('with alignment - Tr[C] = %6.2e',trC8))