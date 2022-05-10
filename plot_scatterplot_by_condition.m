save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Images\';

%plot interaction with scatter plots
w = linspace(min(tbl.pCorrect),max(tbl.pCorrect));
fit = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'condition'},'CategoricalVars','condition');

figure()
gscatter(tbl.pCorrect,tbl.amplitude,tbl.condition,'br','xo')
line(w,feval(fit,w,'decreasing'),'Color','b','LineWidth',2)
line(w,feval(fit,w,'fixed'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by Condition')
savefilename = [save_filedir 'Part12_condition_sig_interaction.jpg'];
saveas(gca,savefilename);

