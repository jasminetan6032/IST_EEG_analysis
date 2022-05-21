save_filedir = 'C:\Github\IST_EEG_analysis\Regression_results\Answer\By_behaviour\';

%plot interaction with scatter plots
w = linspace(min(tbl.pCorrect),max(tbl.pCorrect));
fit = fitlm(tbl,'interactions','ResponseVar','amplitude','PredictorVars',{'pCorrect', 'answer'},'CategoricalVars','answer');

figure()
gscatter(tbl.pCorrect,tbl.amplitude,tbl.answer,'br','xo')
line(w,feval(fit,w,'0'),'Color','b','LineWidth',2)
line(w,feval(fit,w,'1'),'Color','r','LineWidth',2)
title('Fitted Regression Lines by decisionPoint')
savefilename = [save_filedir 'sig_participants_regression_answer_STV.jpg'];
saveas(gca,savefilename);

