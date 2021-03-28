function final_Pred = finalPred(smooth_logPred, smooth_Pred)
    %
    % finalPred.m
    %
    % Instructions: Function that weights linear regression results with
    % logistic regression results according to y = y_{lin}*y_{log} to
    % produce final predictions
    %
    % Input:    smooth_logPred:     Smoothed logistic regression results
    %           smooth_Pred:        Smoothed linear regression results
    %
    % Output:   final_Pred:         Final predictions
%% Code Here
final_Pred = cell(3,1);
for subj = 1:size(smooth_logPred,1)
    final_Pred{subj} = smooth_logPred{subj}.*smooth_Pred{subj};
end
end