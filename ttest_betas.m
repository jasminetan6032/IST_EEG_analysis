function output = ttest_betas(participants,fignamesave,variableNumber)
%takes a participants struct output from individual regressions
%outputs the results of a one-sample t-test of the betas of interest
%saves a histogram of betas in desired file

%collate lm data
for part = 1:length(participants)
    lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(variableNumber,1));
end

%one-sample t-test with histogram
[h,p,ci,stats] = ttest(cell2mat(lm_beta));
histogram(cell2mat(lm_beta),15);

saveas(gca, fignamesave);
output.h = h;
output.p = p;
output.ci = ci;
output.stats = stats;
end