function output = ttest_betas(participants,fignamesave,outputsave,variableNumber)
%takes a participants struct output from individual regressions
%outputs the results of a one-sample t-test of the betas of interest
%saves a histogram of betas in desired file

%collate lm data
for part = 1:length(participants)
    lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(variableNumber,1));
end

%remove outliers
lm_beta = cell2mat(lm_beta);
%lm_beta = rmoutliers(cell2mat(lm_beta));

%one-sample t-test with histogram
[h,p,ci,stats] = ttest(lm_beta);
histogram(lm_beta,15);

saveas(gca, fignamesave);

if h == 1

result = ['A one-sample t-test was significant (t(' ...
    num2str(stats.df) ') = ' ...
    num2str(stats.tstat) ', p = ' num2str(p) '). The mean beta was ' ...
    num2str(mean (lm_beta)) '.']; 
else 
    result = ['A one-sample t-test was non-significant (t(' ...
    num2str(stats.df) ') = ' ...
    num2str(stats.tstat) ', p = ' num2str(p) '). The mean beta was ' ...
    num2str(mean(lm_beta)) '.' ]; 
end 

%print result to command window
disp(result)

output.h = h;
output.p = p;
output.ci = ci;
output.stats = stats;
output.results = result;
output.betas = lm_beta;

save(outputsave, 'output', '-v7.3');

print
end