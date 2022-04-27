%plot histograms of reaction times by condition

%plot ERPs (Pz and weighted average EEG) for high and low pcorrect by condition

%Sensitivity to information inherent in flip is modulated by confidence
%(only confidence trials)


%Sensitivity to information provided by flip (strength of the P300-like
%activity) is modulated by the current available evidence

%what's the individual's average pcorrect threshold for fixed and
%decreasing win conditions?

%distinguish neural activity related to accumulating evidence for correct colour and other colour

%what happens in the long period where pcorrect stays the same? How does
%amplitude vary while pcorrect stays flat? People are calibrating
%confidence? Being extra sure? Still gathering evidence? Haven't picked up
%that there is already a clear answer?

%plot STV over flips (but how to account for different lengths of trials?)

%majority and minority still having a role to play at marking the two
%different options you are accumulating evidence for. 

%extract beta estimates and run second order statistics comparing them to 0
for part = 1:22
answer_beta(part,1) = table2cell(participants(part).lm_answer.Coefficients(3,1));
%answer_beta(part,2) = table2cell(participants(part).lm_answer.Coefficients(3,4));

end
[h,p] = ttest(cell2mat(answer_beta));
histogram(cell2mat(answer_beta),15)