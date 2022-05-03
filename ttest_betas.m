function output = ttest_betas(participants,filedir,figname)
%takes a participants struct output from individual regressions outputs the results of a one-sample t-test of the betas of interest    

    %collate lm data
    for part = 1:length(participants)
lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(3,1));

    end
      %collate lm data in case of interaction
    for part = 1:22
lm_beta(part,1) = table2cell(participants(part).lm.Coefficients(4,1));

    end

%one-sample t-test with histogram
[h,p,ci,stats] = ttest(cell2mat(lm_beta));
histogram(cell2mat(lm_beta),15);

    fignamesave =  [filedir figname];
    saveas(gca, fignamesave);
output.h = h;
output.p = p;
output.ci = ci;
output.stats = stats;
end 