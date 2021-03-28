function dg_descrip = classifyFinger(dg)
    %
    % classifyFinger.m
    %
    % Instructions: Function that classifies fingers angles as motion,
    % no-motion based on a threshold angle
    %
    % Input:    dg:         3x1 cell array of finger angles
    %
    % Output:   dg_descrip: 3x1 cell array of finger states
%% Code Here
% Container for finger threshold
dg_descrip = cell(3,1);
% Threshold for finger data
thresh = 1.5;

for subj = 1:size(dg,1)
    for fing = 1:size(dg{subj},2)
        dg_descrip{subj}(:,fing) = dg{subj}(:,fing) >= thresh;
    end
end
end
