function plotData(maxiter, var)

plot(1:maxiter, var);
title('SGD for different learning rates')
xlabel('Iteration number')
ylabel('Sum of approximated eigenvalues')
legend('c = 6','c = 3','c = 1.5','c = 1','c = 0.666','c = 0.444','c = 0.296',...
       'Location', 'SouthEast')
end