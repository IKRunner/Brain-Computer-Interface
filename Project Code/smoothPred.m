function new_pred = smoothPred(pred,len)
    %
    % smoothPred.m
    %
    % Instructions: Function that computes movine mean smoothing of
    % predictions using optimal window length.
    %
    % Input:    pred:       3x1 cell array of unfiltered predictions
    %           len:        Optimal window length
    %
    % Output:   new_pred:   3x1 cell array of filtered predictions
    % 
%% Code Here
% Initialize container for filtered predictions
new_pred = cell(3,1);
for subj = 1:size(pred,1)
    % Apply moving mean to predictions for all subjects and fingers
    new_pred{subj} = movmean(pred{subj}, len);
end
end
